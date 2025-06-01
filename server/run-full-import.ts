import { extractAndImportAllCompanies } from "./extract-all-companies";

async function runFullImport() {
  try {
    console.log("Iniciando importación completa de todas las empresas...");
    const result = await extractAndImportAllCompanies();
    console.log("Resultado:", result);
    process.exit(0);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

runFullImport();