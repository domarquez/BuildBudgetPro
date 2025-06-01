import { cleanDuplicateActivities } from "./clean-duplicate-activities";

async function runCleanActivities() {
  try {
    console.log("Iniciando limpieza de actividades duplicadas...");
    const result = await cleanDuplicateActivities();
    console.log("Resultado:", result);
    process.exit(0);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

runCleanActivities();