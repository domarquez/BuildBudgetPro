import { db } from "./db";
import { activities, budgetItems, activityCompositions } from "@shared/schema";
import { eq, and, sql, not, like } from "drizzle-orm";

export async function cleanDuplicateActivities() {
  console.log("🧹 Eliminando actividades que no son de la importación APU...");
  
  try {
    // Obtener actividades que NO son de la importación APU (no tienen "APU" en el nombre)
    const activitiesWithoutAPU = await db.select()
      .from(activities)
      .where(not(like(activities.name, '%APU%')));
    
    console.log(`📋 Actividades antiguas encontradas: ${activitiesWithoutAPU.length}`);
    
    let deletedCount = 0;
    let keptCount = 0;
    
    for (const activity of activitiesWithoutAPU) {
      console.log(`🔍 Analizando: ${activity.name}`);
      
      // Verificar si esta actividad tiene presupuestos asociados
      const budgetItemsCount = await db.select()
        .from(budgetItems)
        .where(eq(budgetItems.activityId, activity.id));
      
      if (budgetItemsCount.length > 0) {
        console.log(`   ⚠️ Tiene ${budgetItemsCount.length} presupuestos asociados - MANTENIENDO`);
        keptCount++;
        continue;
      }
      
      // Eliminar las composiciones asociadas primero
      await db.delete(activityCompositions)
        .where(eq(activityCompositions.activityId, activity.id));
      
      // Eliminar la actividad
      await db.delete(activities)
        .where(eq(activities.id, activity.id));
      
      console.log(`   🗑️ ELIMINADO - No tiene presupuestos asociados`);
      deletedCount++;
    }
    
    // Resumen final
    const finalActivities = await db.select().from(activities);
    const onlyAPUActivities = finalActivities.filter(a => a.name.includes('APU'));
    
    console.log("\n📊 RESUMEN DE LIMPIEZA:");
    console.log(`   • Actividades eliminadas: ${deletedCount}`);
    console.log(`   • Actividades mantenidas (con presupuestos): ${keptCount}`);
    console.log(`   • Total actividades después: ${finalActivities.length}`);
    console.log(`   • Actividades APU (válidas): ${onlyAPUActivities.length}`);
    
    return {
      success: true,
      message: "Limpieza de actividades completada",
      data: {
        deleted: deletedCount,
        kept: keptCount,
        totalAfter: finalActivities.length,
        validAPUActivities: onlyAPUActivities.length
      }
    };
    
  } catch (error) {
    console.error("❌ Error durante la limpieza:", error);
    throw error;
  }
}