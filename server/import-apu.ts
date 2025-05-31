import { db } from "./db";
import { activityCompositions, activities, materials as materialsTable } from "@shared/schema";
import { eq, ilike } from "drizzle-orm";
import { importAPUsFromInsucons, getAPUGroups, getAPUsByGroup, getAPUDetail } from "./web-scraper";
import { storage } from "./storage";

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
    activityName: "EXCAVACION 0-1.5 M. TERR. BLANDO",
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
    activityName: "CIMIENTO DE Ho Co",
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
  console.log("Iniciando importación COMPLETA de APUs desde insucons.com...");
  
  try {
    // Obtener TODOS los grupos
    const groups = await getAPUGroups();
    console.log(`Encontrados ${groups.length} grupos disponibles`);
    
    let importedCount = 0;
    let errorCount = 0;
    const details: string[] = [];

    // Procesar TODOS los grupos
    for (const group of groups) {
      try {
        console.log(`Procesando grupo: ${group.name}`);
        const apus = await getAPUsByGroup(group.url);
        
        // Procesar TODOS los APUs del grupo
        for (const apu of apus) {
          try {
            if (!apu.url) continue;
            
            const apuDetail = await getAPUDetail(apu.url);
            if (!apuDetail) {
              errorCount++;
              continue;
            }

            // Buscar actividad similar en la base de datos
            let activity = await findActivityByName(apuDetail.name);
            
            // Si no existe la actividad, crearla automáticamente
            if (!activity) {
              try {
                // Determinar la fase según el grupo de insucons.com
                let phaseId = 3; // Obra gruesa por defecto
                const groupName = group.name.toLowerCase();
                
                if (groupName.includes('demolicion')) phaseId = 1; // Trabajos preliminares
                else if (groupName.includes('excavacion') || groupName.includes('movimiento')) phaseId = 2; // Movimientos de tierras
                else if (groupName.includes('acabado') || groupName.includes('pintura') || groupName.includes('revoque')) phaseId = 4; // Acabados
                else if (groupName.includes('instalacion') || groupName.includes('electrica') || groupName.includes('sanitaria')) phaseId = 5; // Instalaciones
                else if (groupName.includes('vidrio') || groupName.includes('carpinteria') || groupName.includes('cerrajeria')) phaseId = 4; // Acabados
                else if (groupName.includes('cubierta') || groupName.includes('techo')) phaseId = 3; // Obra gruesa
                
                activity = await storage.createActivity({
                  phaseId: phaseId,
                  name: apuDetail.name.toUpperCase(),
                  unit: apuDetail.unit || 'UND',
                  description: `Actividad importada desde APU (${group.name}): ${apuDetail.name}`
                });
                details.push(`✓ Creada nueva actividad en ${phaseId === 1 ? 'Preliminares' : phaseId === 2 ? 'Mov. Tierras' : phaseId === 3 ? 'Obra Gruesa' : phaseId === 4 ? 'Acabados' : 'Instalaciones'}: ${activity.name}`);
              } catch (error) {
                details.push(`✗ Error creando actividad: ${apuDetail.name}`);
                errorCount++;
                continue;
              }
            }

            console.log(`Importando composiciones para: ${activity.name}`);

            // Limpiar composiciones existentes
            await db.delete(activityCompositions)
              .where(eq(activityCompositions.activityId, activity.id));

            // Importar materiales
            for (const material of apuDetail.materials) {
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
            for (const labor of apuDetail.labor) {
              await db.insert(activityCompositions).values({
                activityId: activity.id,
                materialId: null,
                description: labor.description,
                unit: labor.unit,
                quantity: labor.quantity.toString(),
                unitCost: labor.unitPrice.toString(),
                type: 'labor'
              });
            }

            // Importar equipos
            for (const equipment of apuDetail.equipment) {
              await db.insert(activityCompositions).values({
                activityId: activity.id,
                materialId: null,
                description: equipment.description,
                unit: equipment.unit,
                quantity: equipment.quantity.toString(),
                unitCost: equipment.unitPrice.toString(),
                type: 'equipment'
              });
            }

            importedCount++;
            details.push(`✓ Importado: ${activity.name}`);
            
            // Pausa más pequeña para importación masiva
            await new Promise(resolve => setTimeout(resolve, 200));

          } catch (error) {
            console.error(`Error procesando APU ${apu.name}:`, error);
            errorCount++;
            details.push(`✗ Error: ${apu.name}`);
          }
        }
      } catch (error) {
        console.error(`Error procesando grupo ${group.name}:`, error);
        errorCount++;
      }
    }

    console.log(`Importación completada: ${importedCount} éxito, ${errorCount} errores`);
    return { 
      imported: importedCount, 
      errors: errorCount,
      details: details.slice(0, 10)
    };

  } catch (error) {
    console.error("Error en importación de insucons.com:", error);
    throw new Error("Error accediendo a insucons.com. Verifica la conexión a internet.");
  }
}

// Función anterior para importar datos locales como fallback
export async function importLocalAPUCompositions() {
  console.log("Iniciando importación de composiciones APU locales...");
  
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