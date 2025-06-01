import { db } from "./db";
import { activities, activityCompositions, projects } from "@shared/schema";
import { eq } from "drizzle-orm";

export interface APUCalculationResult {
  materialsTotal: number;
  laborTotal: number;
  laborWithCharges: number;
  equipmentTotal: number;
  equipmentWithTools: number;
  subtotalDirect: number;
  administrativeCost: number;
  subtotalWithAdmin: number;
  utilityCost: number;
  subtotalWithUtility: number;
  taxCost: number;
  totalUnitPrice: number;
  breakdown: {
    materials: number;
    labor: number;
    laborCharges: number;
    laborIVA: number;
    equipment: number;
    tools: number;
    administrative: number;
    utility: number;
    tax: number;
  };
}

/**
 * Calcula el precio unitario de una actividad siguiendo el modelo exacto de insucons.com
 */
export async function calculateAPUPrice(
  activityId: number, 
  projectId?: number
): Promise<APUCalculationResult> {
  // Obtener composiciones de la actividad
  const compositions = await db.select()
    .from(activityCompositions)
    .where(eq(activityCompositions.activityId, activityId));

  // Obtener porcentajes del proyecto (si se proporciona) o usar valores por defecto
  let percentages = {
    socialChargesPercentage: 55.00, // Cargas sociales
    laborIVAPercentage: 14.94,      // I.V.A. de M.O. y cargas sociales
    equipmentPercentage: 5.00,      // Herramientas
    administrativePercentage: 8.00, // Gastos generales
    utilityPercentage: 15.00,       // Utilidad
    taxPercentage: 3.09             // Impuesto IT
  };

  if (projectId) {
    const project = await db.select()
      .from(projects)
      .where(eq(projects.id, projectId))
      .limit(1);
    
    if (project[0]) {
      percentages = {
        socialChargesPercentage: parseFloat(project[0].socialChargesPercentage || "55.00"),
        laborIVAPercentage: 14.94, // Este no está en la tabla, usar valor fijo
        equipmentPercentage: parseFloat(project[0].equipmentPercentage || "5.00"),
        administrativePercentage: parseFloat(project[0].administrativePercentage || "8.00"),
        utilityPercentage: parseFloat(project[0].utilityPercentage || "15.00"),
        taxPercentage: parseFloat(project[0].taxPercentage || "3.09")
      };
    }
  }

  // 1. MATERIALES - Precio productivo directo
  let materialsTotal = 0;
  const materialCompositions = compositions.filter(c => c.type === 'material');
  for (const comp of materialCompositions) {
    const quantity = parseFloat(comp.quantity);
    const unitCost = parseFloat(comp.unitCost);
    materialsTotal += quantity * unitCost;
  }

  // 2. MANO DE OBRA - Precio productivo + cargas sociales + IVA
  let laborBaseTotal = 0;
  const laborCompositions = compositions.filter(c => c.type === 'labor');
  for (const comp of laborCompositions) {
    const quantity = parseFloat(comp.quantity);
    const unitCost = parseFloat(comp.unitCost);
    laborBaseTotal += quantity * unitCost;
  }

  const laborCharges = laborBaseTotal * (percentages.socialChargesPercentage / 100);
  const laborWithCharges = laborBaseTotal + laborCharges;
  const laborIVA = laborWithCharges * (percentages.laborIVAPercentage / 100);
  const laborTotal = laborWithCharges + laborIVA;

  // 3. EQUIPOS - Precio productivo + herramientas
  let equipmentBaseTotal = 0;
  const equipmentCompositions = compositions.filter(c => c.type === 'equipment');
  for (const comp of equipmentCompositions) {
    const quantity = parseFloat(comp.quantity);
    const unitCost = parseFloat(comp.unitCost);
    equipmentBaseTotal += quantity * unitCost;
  }

  const toolsCost = equipmentBaseTotal * (percentages.equipmentPercentage / 100);
  const equipmentTotal = equipmentBaseTotal + toolsCost;

  // 4. SUBTOTAL DIRECTO (1 + 2 + 3)
  const subtotalDirect = materialsTotal + laborTotal + equipmentTotal;

  // 5. GASTOS GENERALES Y ADMINISTRATIVOS (% del subtotal directo)
  const administrativeCost = subtotalDirect * (percentages.administrativePercentage / 100);
  const subtotalWithAdmin = subtotalDirect + administrativeCost;

  // 6. UTILIDAD (% del subtotal con gastos generales)
  const utilityCost = subtotalWithAdmin * (percentages.utilityPercentage / 100);
  const subtotalWithUtility = subtotalWithAdmin + utilityCost;

  // 7. IMPUESTOS (% del subtotal con utilidad)
  const taxCost = subtotalWithUtility * (percentages.taxPercentage / 100);
  const totalUnitPrice = subtotalWithUtility + taxCost;

  return {
    materialsTotal,
    laborTotal: laborBaseTotal,
    laborWithCharges,
    equipmentTotal: equipmentBaseTotal,
    equipmentWithTools: equipmentTotal,
    subtotalDirect,
    administrativeCost,
    subtotalWithAdmin,
    utilityCost,
    subtotalWithUtility,
    taxCost,
    totalUnitPrice,
    breakdown: {
      materials: materialsTotal,
      labor: laborBaseTotal,
      laborCharges,
      laborIVA,
      equipment: equipmentBaseTotal,
      tools: toolsCost,
      administrative: administrativeCost,
      utility: utilityCost,
      tax: taxCost
    }
  };
}

/**
 * Actualiza el precio unitario de una actividad en la base de datos
 */
export async function updateActivityUnitPrice(activityId: number, projectId?: number): Promise<number> {
  const calculation = await calculateAPUPrice(activityId, projectId);
  
  // Actualizar el precio en la tabla de actividades
  await db.update(activities)
    .set({ 
      unitPrice: calculation.totalUnitPrice.toFixed(2),
      updatedAt: new Date() 
    })
    .where(eq(activities.id, activityId));

  return calculation.totalUnitPrice;
}