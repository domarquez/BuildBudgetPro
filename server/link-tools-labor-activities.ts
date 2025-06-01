import { db } from "./db";
import { activities, tools, laborCategories, activityCompositions } from "@shared/schema";
import { eq } from "drizzle-orm";

interface ActivityToolMapping {
  activityPattern: string;
  toolNames: string[];
  laborCategories: string[];
  toolQuantity: number;
  laborQuantity: number;
}

// Mapeo de actividades con herramientas y mano de obra específicas
const activityMappings: ActivityToolMapping[] = [
  {
    activityPattern: "excavacion|movimiento.*tierra|zanja",
    toolNames: ["RETROEXCAVADORA", "VOLQUETA"],
    laborCategories: ["PEON", "AYUDANTE"],
    toolQuantity: 0.25,
    laborQuantity: 2.0
  },
  {
    activityPattern: "hormigon|concreto|vaciado",
    toolNames: ["MEZCLADORA", "VIBRADORA"],
    laborCategories: ["ALBAÑIL", "PEON"],
    toolQuantity: 0.5,
    laborQuantity: 1.5
  },
  {
    activityPattern: "encofrado|cimbra",
    toolNames: ["HERRAMIENTAS MENORES"],
    laborCategories: ["ENCOFRADOR", "CARPINTERO"],
    toolQuantity: 0.1,
    laborQuantity: 1.0
  },
  {
    activityPattern: "armadura|hierro|acero",
    toolNames: ["EQUIPO DE SOLDADURA", "HERRAMIENTAS MENORES"],
    laborCategories: ["ARMADOR", "AYUDANTE"],
    toolQuantity: 0.2,
    laborQuantity: 1.2
  },
  {
    activityPattern: "instalacion.*electrica|electrico",
    toolNames: ["HERRAMIENTAS MENORES"],
    laborCategories: ["ELECTRICISTA", "AYUDANTE"],
    toolQuantity: 0.1,
    laborQuantity: 0.8
  },
  {
    activityPattern: "instalacion.*sanitaria|plomeria|tuberia",
    toolNames: ["HERRAMIENTAS MENORES"],
    laborCategories: ["PLOMERO ESPECIALISTA", "AYUDANTE"],
    toolQuantity: 0.1,
    laborQuantity: 0.6
  },
  {
    activityPattern: "perforacion|taladro",
    toolNames: ["EQUIPO DE PERFORACION", "COMPRESORA ATLAS COPCO"],
    laborCategories: ["PERFORISTA", "AYUDANTE"],
    toolQuantity: 0.8,
    laborQuantity: 1.0
  },
  {
    activityPattern: "compactacion|apisonado",
    toolNames: ["COMPACTADORAS", "VIBRADORA"],
    laborCategories: ["ESPECIALISTA", "PEON"],
    toolQuantity: 0.3,
    laborQuantity: 1.0
  },
  {
    activityPattern: "carpinteria|madera|puerta|ventana",
    toolNames: ["HERRAMIENTAS MENORES"],
    laborCategories: ["CARPINTERO", "AYUDANTE"],
    toolQuantity: 0.2,
    laborQuantity: 1.5
  },
  {
    activityPattern: "cerrajeria|herreria|metal",
    toolNames: ["EQUIPO DE SOLDADURA", "HERRAMIENTAS MENORES"],
    laborCategories: ["ESPECIALISTA CERRAJERO", "AYUDANTE"],
    toolQuantity: 0.3,
    laborQuantity: 1.0
  }
];

export async function linkToolsAndLaborToActivities() {
  console.log("🔗 Enlazando herramientas y mano de obra a actividades...");
  
  try {
    // Obtener todas las actividades
    const allActivities = await db.select().from(activities);
    console.log(`📋 Total actividades: ${allActivities.length}`);
    
    // Obtener todas las herramientas y categorías de mano de obra
    const allTools = await db.select().from(tools);
    const allLaborCategories = await db.select().from(laborCategories);
    
    console.log(`🛠️ Total herramientas: ${allTools.length}`);
    console.log(`👷 Total categorías de mano de obra: ${allLaborCategories.length}`);
    
    let linkedActivities = 0;
    let totalCompositions = 0;
    
    for (const activity of allActivities) {
      const activityName = activity.name.toLowerCase();
      let hasMatches = false;
      
      // Buscar mapeos que coincidan con la actividad
      for (const mapping of activityMappings) {
        const regex = new RegExp(mapping.activityPattern, 'i');
        
        if (regex.test(activityName)) {
          console.log(`🎯 Actividad coincidente: ${activity.name}`);
          hasMatches = true;
          
          // Enlazar herramientas
          for (const toolName of mapping.toolNames) {
            const tool = allTools.find(t => t.name.toUpperCase().includes(toolName.toUpperCase()));
            if (tool) {
              try {
                await db.insert(activityCompositions).values({
                  activityId: activity.id,
                  toolId: tool.id,
                  description: `Herramienta: ${tool.name}`,
                  unit: tool.unit,
                  quantity: mapping.toolQuantity.toString(),
                  unitCost: tool.unitPrice,
                  type: 'tool'
                });
                totalCompositions++;
                console.log(`   🔧 Enlazada herramienta: ${tool.name}`);
              } catch (error) {
                // Ignorar duplicados
              }
            }
          }
          
          // Enlazar mano de obra
          for (const laborName of mapping.laborCategories) {
            const labor = allLaborCategories.find(l => l.name.toUpperCase().includes(laborName.toUpperCase()));
            if (labor) {
              try {
                await db.insert(activityCompositions).values({
                  activityId: activity.id,
                  laborId: labor.id,
                  description: `Mano de obra: ${labor.name}`,
                  unit: labor.unit,
                  quantity: mapping.laborQuantity.toString(),
                  unitCost: labor.hourlyRate,
                  type: 'labor'
                });
                totalCompositions++;
                console.log(`   👷 Enlazada mano de obra: ${labor.name}`);
              } catch (error) {
                // Ignorar duplicados
              }
            }
          }
          
          break; // Solo usar el primer mapeo que coincida
        }
      }
      
      if (hasMatches) {
        linkedActivities++;
      }
    }
    
    // Agregar mano de obra básica a actividades sin enlace específico
    console.log("\n🔄 Agregando mano de obra básica a actividades restantes...");
    
    const basicLabor = allLaborCategories.find(l => l.name === 'PEON');
    const basicTools = allTools.find(t => t.name === 'HERRAMIENTAS MENORES');
    
    let basicLinked = 0;
    
    for (const activity of allActivities) {
      // Verificar si ya tiene composiciones de mano de obra
      const existingLabor = await db.select()
        .from(activityCompositions)
        .where(eq(activityCompositions.activityId, activity.id))
        .then(comps => comps.some(c => c.type === 'labor'));
      
      if (!existingLabor && basicLabor) {
        try {
          await db.insert(activityCompositions).values({
            activityId: activity.id,
            laborId: basicLabor.id,
            description: `Mano de obra básica: ${basicLabor.name}`,
            unit: basicLabor.unit,
            quantity: "0.5",
            unitCost: basicLabor.hourlyRate,
            type: 'labor'
          });
          basicLinked++;
        } catch (error) {
          // Ignorar duplicados
        }
      }
      
      // Verificar si ya tiene herramientas
      const existingTools = await db.select()
        .from(activityCompositions)
        .where(eq(activityCompositions.activityId, activity.id))
        .then(comps => comps.some(c => c.type === 'tool'));
      
      if (!existingTools && basicTools) {
        try {
          await db.insert(activityCompositions).values({
            activityId: activity.id,
            toolId: basicTools.id,
            description: `Herramientas básicas: ${basicTools.name}`,
            unit: basicTools.unit,
            quantity: "0.05",
            unitCost: basicTools.unitPrice,
            type: 'tool'
          });
          basicLinked++;
        } catch (error) {
          // Ignorar duplicados
        }
      }
    }
    
    // Resumen final
    const finalCompositions = await db.select().from(activityCompositions);
    const withTools = finalCompositions.filter(c => c.type === 'tool').length;
    const withLabor = finalCompositions.filter(c => c.type === 'labor').length;
    const withMaterials = finalCompositions.filter(c => c.type === 'material').length;
    
    console.log("\n📊 RESUMEN FINAL:");
    console.log(`   • Actividades enlazadas específicamente: ${linkedActivities}`);
    console.log(`   • Composiciones agregadas: ${totalCompositions}`);
    console.log(`   • Enlaces básicos agregados: ${basicLinked}`);
    console.log(`   • Total composiciones en sistema: ${finalCompositions.length}`);
    console.log(`   • Con herramientas: ${withTools}`);
    console.log(`   • Con mano de obra: ${withLabor}`);
    console.log(`   • Con materiales: ${withMaterials}`);
    
    return {
      success: true,
      message: "Enlace de herramientas y mano de obra completado",
      data: {
        linkedActivities,
        totalCompositions: finalCompositions.length,
        withTools,
        withLabor,
        withMaterials
      }
    };
    
  } catch (error) {
    console.error("❌ Error durante el enlace:", error);
    throw error;
  }
}