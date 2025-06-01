import { db } from "./db";
import { activityCompositions, materials, activities } from "@shared/schema";
import { eq } from "drizzle-orm";

export async function calculateActivityUnitPrice(activityId: number): Promise<number> {
  try {
    // Obtener todas las composiciones de la actividad
    const compositions = await db
      .select()
      .from(activityCompositions)
      .leftJoin(materials, eq(activityCompositions.materialId, materials.id))
      .where(eq(activityCompositions.activityId, activityId));

    let totalPrice = 0;

    for (const comp of compositions) {
      const composition = comp.activity_compositions;
      const material = comp.materials;
      
      const quantity = parseFloat(composition.quantity) || 0;
      let unitCost = parseFloat(composition.unitCost) || 0;

      // Si hay material vinculado, usar su precio actualizado
      if (material) {
        const materialPrice = parseFloat(material.price);
        if (materialPrice > 0) {
          unitCost = materialPrice;
        }
      }

      // Calcular costo de esta composición
      const compositionCost = quantity * unitCost;
      totalPrice += compositionCost;

      console.log(`Composición: ${composition.description}, Cantidad: ${quantity}, Precio unitario: ${unitCost}, Subtotal: ${compositionCost}`);
    }

    console.log(`Precio total calculado para actividad ${activityId}: ${totalPrice}`);
    return totalPrice;

  } catch (error) {
    console.error(`Error calculando precio para actividad ${activityId}:`, error);
    return 0;
  }
}

export async function updateActivityPricesFromCompositions(): Promise<{
  updated: number;
  errors: number;
  details: string[];
}> {
  console.log('Iniciando actualización de precios de actividades...');
  
  // Obtener todas las actividades que tienen composiciones
  const activitiesWithCompositions = await db
    .select({ activityId: activityCompositions.activityId })
    .from(activityCompositions)
    .groupBy(activityCompositions.activityId);

  let updated = 0;
  let errors = 0;
  const details: string[] = [];

  for (const { activityId } of activitiesWithCompositions) {
    try {
      const calculatedPrice = await calculateActivityUnitPrice(activityId);
      
      if (calculatedPrice > 0) {
        // Actualizar el precio en la tabla de actividades
        await db
          .update(activities)
          .set({ unitPrice: calculatedPrice.toFixed(2) })
          .where(eq(activities.id, activityId));

        updated++;
        details.push(`✓ Actividad ${activityId}: ${calculatedPrice.toFixed(2)} Bs`);
      } else {
        details.push(`⚠ Actividad ${activityId}: Sin precio calculable`);
      }
    } catch (error) {
      errors++;
      details.push(`✗ Error en actividad ${activityId}: ${error}`);
    }
  }

  console.log(`Actualización completada: ${updated} precios actualizados, ${errors} errores`);
  
  return {
    updated,
    errors,
    details: details.slice(0, 20) // Limitar detalles mostrados
  };
}