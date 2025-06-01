import { importToolsAndLaborFromSQL } from "./import-tools-labor";

async function runToolsLaborImport() {
  try {
    console.log("Iniciando importación de herramientas y mano de obra...");
    const result = await importToolsAndLaborFromSQL();
    console.log("Resultado:", result);
    process.exit(0);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

runToolsLaborImport();