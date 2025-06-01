import { db } from "./db";
import { activities, budgetItems, activityCompositions } from "@shared/schema";
import { eq, and } from "drizzle-orm";

export async function cleanDuplicateActivities() {
  console.log("🧹 Calculando precios para actividades sin precio...");
  
  try {
    // Importar la función de cálculo APU
    const { updateActivityUnitPrice } = await import("./apu-calculator");
    
    // Obtener actividades sin precio
    const activitiesWithoutPrice = await db.select()
      .from(activities)
      .where(eq(activities.unitPrice, "0.00"));
    
    console.log(`📋 Actividades sin precio encontradas: ${activitiesWithoutPrice.length}`);
    
    let calculatedCount = 0;
    let skippedCount = 0;
    
    for (const activity of activitiesWithoutPrice) {
      console.log(`🔍 Calculando precio para: ${activity.name}`);
      
      // Verificar si tiene composiciones
      const compositionsCount = await db.select()
        .from(activityCompositions)
        .where(eq(activityCompositions.activityId, activity.id));
      
      if (compositionsCount.length === 0) {
        console.log(`   ⚠️ Sin composiciones - SALTANDO`);
        skippedCount++;
        continue;
      }
      
      try {
        // Calcular el precio unitario usando el sistema APU
        const newPrice = await updateActivityUnitPrice(activity.id);
        
        if (newPrice > 0) {
          console.log(`   ✅ Precio calculado: ${newPrice.toFixed(2)} BOB`);
          calculatedCount++;
        } else {
          console.log(`   ⚠️ No se pudo calcular precio válido`);
          skippedCount++;
        }
      } catch (error) {
        console.log(`   ❌ Error calculando precio: ${error}`);
        skippedCount++;
      }
    }
    
    // Resumen final
    const finalActivities = await db.select().from(activities);
    const finalWithoutPrice = finalActivities.filter(a => a.unitPrice === "0.00");
    
    console.log("\n📊 RESUMEN DE CÁLCULO:");
    console.log(`   • Actividades con precio calculado: ${calculatedCount}`);
    console.log(`   • Actividades saltadas: ${skippedCount}`);
    console.log(`   • Total actividades después: ${finalActivities.length}`);
    console.log(`   • Actividades sin precio restantes: ${finalWithoutPrice.length}`);
    
    // Mostrar actividades sin precio que quedaron
    if (finalWithoutPrice.length > 0) {
      console.log("\n📝 Actividades sin precio restantes:");
      for (const activity of finalWithoutPrice) {
        const compositions = await db.select().from(activityCompositions).where(eq(activityCompositions.activityId, activity.id));
        console.log(`   • ${activity.name} (${compositions.length} composiciones)`);
      }
    }
    
    return {
      success: true,
      message: "Cálculo de precios completado",
      data: {
        calculated: calculatedCount,
        skipped: skippedCount,
        totalAfter: finalActivities.length,
        withoutPriceRemaining: finalWithoutPrice.length
      }
    };
    
  } catch (error) {
    console.error("❌ Error durante la limpieza:", error);
    throw error;
  }
}