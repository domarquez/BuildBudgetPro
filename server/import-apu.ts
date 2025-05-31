import { db } from "./db";
import { activityCompositions, activities, materials as materialsTable } from "@shared/schema";
import { eq, ilike } from "drizzle-orm";

interface APUMaterial {
  description: string;
  unit: string;
  quantity: number;
  unitPrice: number;
}

interface APULabor {
  description: string;
  unit: string;
  quantity: number;
  unitPrice: number;
}

interface APUData {
  activityName: string;
  materials: APUMaterial[];
  labor: APULabor[];
  equipmentPercentage: number;
  administrativePercentage: number;
  utilityPercentage: number;
  taxPercentage: number;
}

// Datos de ejemplo basados en los APUs de insucons.com
const apuData: APUData[] = [
  {
    activityName: "EXCAVACION MANUAL",
    materials: [], // No tiene materiales específicos
    labor: [
      { description: "Ayudante", unit: "hr", quantity: 2.20, unitPrice: 12.50 },
      { description: "Maestro albañil", unit: "hr", quantity: 0.20, unitPrice: 18.75 }
    ],
    equipmentPercentage: 5.00,
    administrativePercentage: 8.00,
    utilityPercentage: 15.00,
    taxPercentage: 3.09
  },
  {
    activityName: "CIMIENTO DE LADRILLO ADOBITO",
    materials: [
      { description: "Cemento portland IP-30", unit: "kg", quantity: 60.00, unitPrice: 1.20 },
      { description: "Arena fina", unit: "m3", quantity: 0.35, unitPrice: 70.00 },
      { description: "Ladrillo adobito", unit: "pza", quantity: 515.00, unitPrice: 0.65 },
      { description: "Agua", unit: "lt", quantity: 350.00, unitPrice: 0.06 }
    ],
    labor: [
      { description: "Ayudante", unit: "hr", quantity: 5.70, unitPrice: 12.50 },
      { description: "Maestro albañil", unit: "hr", quantity: 7.12, unitPrice: 18.75 }
    ],
    equipmentPercentage: 5.00,
    administrativePercentage: 8.00,
    utilityPercentage: 15.00,
    taxPercentage: 3.09
  }
];

// Función para buscar material similar en la base de datos
async function findSimilarMaterial(description: string) {
  const materialResults = await db.select()
    .from(materialsTable)
    .where(ilike(materialsTable.description, `%${description}%`))
    .limit(1);
  
  return materialResults[0];
}

// Función para buscar actividad por nombre
async function findActivityByName(activityName: string) {
  const activityResults = await db.select()
    .from(activities)
    .where(ilike(activities.name, `%${activityName}%`))
    .limit(1);
  
  return activityResults[0];
}

// Función principal para importar APUs
export async function importAPUCompositions() {
  console.log("Iniciando importación de composiciones APU...");
  
  let importedCount = 0;
  let errorCount = 0;

  for (const apu of apuData) {
    try {
      // Buscar la actividad correspondiente
      const activity = await findActivityByName(apu.activityName);
      if (!activity) {
        console.log(`Actividad no encontrada: ${apu.activityName}`);
        errorCount++;
        continue;
      }

      console.log(`Procesando actividad: ${activity.name} (ID: ${activity.id})`);

      // Limpiar composiciones existentes para esta actividad
      await db.delete(activityCompositions)
        .where(eq(activityCompositions.activityId, activity.id));

      // Importar materiales
      for (const material of apu.materials) {
        const foundMaterial = await findSimilarMaterial(material.description);
        
        await db.insert(activityCompositions).values({
          activityId: activity.id,
          materialId: foundMaterial?.id || null,
          description: material.description,
          unit: material.unit,
          quantity: material.quantity.toString(),
          unitCost: material.unitPrice.toString(),
          type: 'material'
        });
      }

      // Importar mano de obra
      for (const labor of apu.labor) {
        await db.insert(activityCompositions).values({
          activityId: activity.id,
          materialId: null, // Mano de obra no tiene materialId
          description: labor.description,
          unit: labor.unit,
          quantity: labor.quantity.toString(),
          unitCost: labor.unitPrice.toString(),
          type: 'labor'
        });
      }

      // Agregar costos indirectos como composiciones adicionales
      if (apu.equipmentPercentage > 0) {
        await db.insert(activityCompositions).values({
          activityId: activity.id,
          materialId: null,
          description: "Herramientas y equipos",
          unit: "%",
          quantity: apu.equipmentPercentage.toString(),
          unitCost: "0",
          type: 'equipment'
        });
      }

      importedCount++;
      console.log(`✓ Composición importada para: ${activity.name}`);

    } catch (error) {
      console.error(`Error procesando ${apu.activityName}:`, error);
      errorCount++;
    }
  }

  console.log(`\nImportación completada:`);
  console.log(`- Actividades procesadas: ${importedCount}`);
  console.log(`- Errores: ${errorCount}`);

  return {
    imported: importedCount,
    errors: errorCount
  };
}

// Función para calcular precio de actividad basado en composiciones
export async function calculateActivityPrice(activityId: number): Promise<number> {
  const compositions = await db.select()
    .from(activityCompositions)
    .where(eq(activityCompositions.activityId, activityId));

  let materialCost = 0;
  let laborCost = 0;
  let equipmentPercentage = 0;

  for (const comp of compositions) {
    const quantity = parseFloat(comp.quantity);
    const unitCost = parseFloat(comp.unitCost);
    const subtotal = quantity * unitCost;

    if (comp.type === 'material') {
      materialCost += subtotal;
    } else if (comp.type === 'labor') {
      laborCost += subtotal;
    } else if (comp.type === 'equipment') {
      equipmentPercentage = quantity;
    }
  }

  const directCost = materialCost + laborCost;
  const equipmentCost = (directCost * equipmentPercentage) / 100;
  const subtotalCost = directCost + equipmentCost;
  
  // Aplicar gastos generales (8%), utilidad (15%) e impuestos (3.09%)
  const administrativeCost = subtotalCost * 0.08;
  const utilityCost = (subtotalCost + administrativeCost) * 0.15;
  const subtotalBeforeTax = subtotalCost + administrativeCost + utilityCost;
  const taxCost = subtotalBeforeTax * 0.0309;
  
  const totalCost = subtotalBeforeTax + taxCost;

  return Math.round(totalCost * 100) / 100; // Redondear a 2 decimales
}