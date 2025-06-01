import { linkToolsAndLaborToActivities } from "./link-tools-labor-activities";

async function runLinkActivities() {
  try {
    console.log("Iniciando enlace de herramientas y mano de obra con actividades...");
    const result = await linkToolsAndLaborToActivities();
    console.log("Resultado:", result);
    process.exit(0);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

runLinkActivities();