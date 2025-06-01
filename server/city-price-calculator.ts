import { storage } from "./storage";
import type { CityPriceFactor } from "@shared/schema";

interface PriceAdjustment {
  originalPrice: number;
  adjustedPrice: number;
  cityFactor: CityPriceFactor;
  breakdown: {
    materials: number;
    labor: number;
    equipment: number;
    transport: number;
  };
}

/**
 * Aplica factores de precios por ciudad a un precio base de actividad
 */
export async function applyGeographicPriceAdjustment(
  basePrice: number,
  city: string,
  country: string = "Bolivia"
): Promise<PriceAdjustment | null> {
  try {
    const cityFactor = await storage.getCityPriceFactor(city, country);
    
    if (!cityFactor) {
      console.log(`No se encontró factor de precios para ${city}, ${country}`);
      return null;
    }

    // Asumimos una distribución típica de costos en construcción boliviana:
    // 40% materiales, 35% mano de obra, 15% equipos, 10% transporte
    const costDistribution = {
      materials: 0.40,
      labor: 0.35,
      equipment: 0.15,
      transport: 0.10
    };

    const materialsFactor = parseFloat(cityFactor.materialsFactor);
    const laborFactor = parseFloat(cityFactor.laborFactor);
    const equipmentFactor = parseFloat(cityFactor.equipmentFactor);
    const transportFactor = parseFloat(cityFactor.transportFactor);

    // Calcular el precio ajustado aplicando factores por componente
    const adjustedComponents = {
      materials: basePrice * costDistribution.materials * materialsFactor,
      labor: basePrice * costDistribution.labor * laborFactor,
      equipment: basePrice * costDistribution.equipment * equipmentFactor,
      transport: basePrice * costDistribution.transport * transportFactor
    };

    const adjustedPrice = Object.values(adjustedComponents).reduce((sum, value) => sum + value, 0);

    return {
      originalPrice: basePrice,
      adjustedPrice,
      cityFactor,
      breakdown: adjustedComponents
    };
  } catch (error) {
    console.error("Error aplicando ajuste geográfico de precios:", error);
    return null;
  }
}

/**
 * Calcula el factor de ajuste promedio para una ciudad
 */
export async function getCityAverageFactor(
  city: string,
  country: string = "Bolivia"
): Promise<number> {
  try {
    const cityFactor = await storage.getCityPriceFactor(city, country);
    
    if (!cityFactor) {
      return 1.0; // Factor neutral si no se encuentra la ciudad
    }

    const materialsFactor = parseFloat(cityFactor.materialsFactor);
    const laborFactor = parseFloat(cityFactor.laborFactor);
    const equipmentFactor = parseFloat(cityFactor.equipmentFactor);
    const transportFactor = parseFloat(cityFactor.transportFactor);

    // Promedio ponderado según distribución típica de costos
    const weightedAverage = (
      materialsFactor * 0.40 +
      laborFactor * 0.35 +
      equipmentFactor * 0.15 +
      transportFactor * 0.10
    );

    return weightedAverage;
  } catch (error) {
    console.error("Error calculando factor promedio de ciudad:", error);
    return 1.0;
  }
}

/**
 * Aplica ajustes geográficos a todos los elementos de un presupuesto
 */
export async function adjustBudgetItemsByLocation(
  budgetItems: any[],
  city: string,
  country: string = "Bolivia"
): Promise<any[]> {
  try {
    const adjustedItems = [];
    
    for (const item of budgetItems) {
      const basePrice = parseFloat(item.unitPrice);
      const adjustment = await applyGeographicPriceAdjustment(basePrice, city, country);
      
      if (adjustment) {
        const adjustedItem = {
          ...item,
          unitPrice: adjustment.adjustedPrice.toFixed(2),
          subtotal: (adjustment.adjustedPrice * parseFloat(item.quantity)).toFixed(2),
          priceAdjustment: {
            originalPrice: adjustment.originalPrice,
            adjustedPrice: adjustment.adjustedPrice,
            factor: adjustment.adjustedPrice / adjustment.originalPrice,
            city: adjustment.cityFactor.city,
            country: adjustment.cityFactor.country
          }
        };
        adjustedItems.push(adjustedItem);
      } else {
        // Si no hay factor de ciudad, mantener precio original
        adjustedItems.push(item);
      }
    }
    
    return adjustedItems;
  } catch (error) {
    console.error("Error ajustando elementos del presupuesto por ubicación:", error);
    return budgetItems; // Retornar items originales en caso de error
  }
}

/**
 * Obtiene información detallada de factores de precios para una ciudad
 */
export async function getCityPriceInfo(
  city: string,
  country: string = "Bolivia"
): Promise<{
  city: string;
  country: string;
  factors: CityPriceFactor | null;
  averageFactor: number;
  description: string;
} | null> {
  try {
    const cityFactor = await storage.getCityPriceFactor(city, country);
    const averageFactor = await getCityAverageFactor(city, country);
    
    return {
      city,
      country,
      factors: cityFactor ?? null,
      averageFactor,
      description: cityFactor?.description || `Información de precios para ${city}, ${country}`
    };
  } catch (error) {
    console.error("Error obteniendo información de precios de ciudad:", error);
    return null;
  }
}