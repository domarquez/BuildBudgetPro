import { findAndImportMissingCompanies } from "./find-missing-companies";

async function runMissingImport() {
  try {
    console.log("Iniciando búsqueda e importación de empresas faltantes...");
    const result = await findAndImportMissingCompanies();
    console.log("Resultado:", result);
    process.exit(0);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

runMissingImport();