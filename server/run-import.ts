import { importCompleteDataFromSQL } from "./import-complete-data";

async function runImport() {
  try {
    console.log("Iniciando importación de empresas reales...");
    const result = await importCompleteDataFromSQL();
    console.log("Resultado:", result);
    process.exit(0);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

runImport();