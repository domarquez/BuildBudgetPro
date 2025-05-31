import { storage } from './storage';

interface ActivityClassification {
  id: number;
  name: string;
  currentPhaseId: number;
  suggestedPhaseId: number;
  reason: string;
}

export async function reorganizeExistingActivities(): Promise<{
  analyzed: number;
  reclassified: number;
  details: ActivityClassification[];
}> {
  console.log('Iniciando reorganización de actividades existentes...');
  
  const activities = await storage.getActivities();
  const classifications: ActivityClassification[] = [];
  let reclassified = 0;

  for (const activity of activities) {
    const name = activity.name.toLowerCase();
    let suggestedPhaseId = activity.phaseId;
    let reason = 'Sin cambios';

    // Determinar la fase correcta según el contenido del nombre
    if (name.includes('demolicion') || name.includes('desmont') || name.includes('limpieza')) {
      suggestedPhaseId = 1; // Trabajos preliminares
      reason = 'Actividad de demolición/preliminar';
    }
    else if (name.includes('excavacion') || name.includes('movimiento') || name.includes('tierra') || name.includes('zanja')) {
      suggestedPhaseId = 2; // Movimientos de tierras
      reason = 'Actividad de movimiento de tierras';
    }
    else if (name.includes('vidrio') || name.includes('espejo') || name.includes('carpinteria') || 
             name.includes('cerrajeria') || name.includes('pintura') || name.includes('acabado') ||
             name.includes('revoque') || name.includes('enlucido') || name.includes('ceramica') ||
             name.includes('azulejo') || name.includes('piso') || name.includes('cielo') ||
             name.includes('puerta') || name.includes('ventana')) {
      suggestedPhaseId = 4; // Acabados
      reason = 'Actividad de acabados/terminaciones';
    }
    else if (name.includes('instalacion') || name.includes('electrica') || name.includes('sanitaria') ||
             name.includes('tuberia') || name.includes('cable') || name.includes('punto') ||
             name.includes('toma') || name.includes('interruptor') || name.includes('luminaria')) {
      suggestedPhaseId = 5; // Instalaciones
      reason = 'Actividad de instalaciones';
    }
    else if (name.includes('hormigon') || name.includes('concreto') || name.includes('cimiento') ||
             name.includes('columna') || name.includes('viga') || name.includes('losa') ||
             name.includes('muro') || name.includes('estructura') || name.includes('cubierta') ||
             name.includes('techo')) {
      suggestedPhaseId = 3; // Obra gruesa
      reason = 'Actividad estructural/obra gruesa';
    }

    classifications.push({
      id: activity.id,
      name: activity.name,
      currentPhaseId: activity.phaseId,
      suggestedPhaseId,
      reason
    });

    // Si la fase sugerida es diferente, actualizar
    if (suggestedPhaseId !== activity.phaseId) {
      try {
        await storage.updateActivity(activity.id, { phaseId: suggestedPhaseId });
        reclassified++;
        console.log(`✓ Movida: ${activity.name} → Fase ${suggestedPhaseId}`);
      } catch (error) {
        console.error(`✗ Error moviendo actividad ${activity.id}:`, error);
      }
    }
  }

  console.log(`Reorganización completada: ${reclassified} actividades reclasificadas de ${activities.length} analizadas`);
  
  return {
    analyzed: activities.length,
    reclassified,
    details: classifications
  };
}