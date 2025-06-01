import { readFileSync } from 'fs';
import { db } from "./db";
import { tools, laborCategories } from "@shared/schema";

interface SqlHerramienta {
  IdHerramienta: number;
  Descripcion: string;
  Unidad: string;
  PU: number;
}

interface SqlManoObra {
  IdManoObra: number;
  Descripcion: string;
  Unidad: string;
  PU: number;
}

function parseToolData(line: string): SqlHerramienta | null {
  const match = line.match(/\((\d+),\s*'([^']*)',\s*'([^']*)',\s*([0-9.]+)\)/);
  
  if (!match) return null;
  
  return {
    IdHerramienta: parseInt(match[1]),
    Descripcion: match[2],
    Unidad: match[3],
    PU: parseFloat(match[4])
  };
}

function parseLaborData(line: string): SqlManoObra | null {
  const match = line.match(/\((\d+),\s*'([^']*)',\s*'([^']*)',\s*([0-9.]+)\)/);
  
  if (!match) return null;
  
  return {
    IdManoObra: parseInt(match[1]),
    Descripcion: match[2],
    Unidad: match[3],
    PU: parseFloat(match[4])
  };
}

function getSkillLevel(descripcion: string): string {
  const desc = descripcion.toLowerCase();
  if (desc.includes('especialista') || desc.includes('calificado') || desc.includes('carpintero') || desc.includes('plomero')) {
    return 'specialist';
  } else if (desc.includes('albañil') || desc.includes('encofrador') || desc.includes('armador') || desc.includes('electricista')) {
    return 'skilled';
  } else {
    return 'basic';
  }
}

export async function importToolsAndLaborFromSQL() {
  console.log("🔧 Importando herramientas y mano de obra del archivo SQL...");
  
  try {
    const sqlContent = readFileSync('../attached_assets/datos2.sql', 'utf-8');
    
    // Importar herramientas
    console.log("🛠️ Procesando herramientas...");
    const toolsStartMarker = "INSERT INTO `tbl_herramientas`";
    const toolsEndMarker = "INSERT INTO `tbl_mano_obra`";
    
    const toolsStartIndex = sqlContent.indexOf(toolsStartMarker);
    const toolsEndIndex = sqlContent.indexOf(toolsEndMarker);
    
    if (toolsStartIndex !== -1 && toolsEndIndex !== -1) {
      const toolsSection = sqlContent.substring(toolsStartIndex, toolsEndIndex);
      const toolsLines = toolsSection
        .split('\n')
        .filter(line => line.trim().startsWith('('))
        .map(line => line.trim().replace(/,$/, '').replace(/;$/, ''));
      
      console.log(`📋 Encontradas ${toolsLines.length} herramientas`);
      
      let toolsImported = 0;
      for (const line of toolsLines) {
        const toolData = parseToolData(line);
        if (toolData) {
          try {
            await db.insert(tools).values({
              name: toolData.Descripcion,
              description: `Herramienta de construcción: ${toolData.Descripcion}`,
              unit: toolData.Unidad,
              unitPrice: toolData.PU.toString(),
              isActive: true
            });
            toolsImported++;
            console.log(`   ✅ Herramienta: ${toolData.Descripcion} - ${toolData.PU} ${toolData.Unidad}`);
          } catch (error) {
            console.log(`   ❌ Error importando herramienta ${toolData.Descripcion}:`, error);
          }
        }
      }
      
      console.log(`✅ Herramientas importadas: ${toolsImported}`);
    }
    
    // Importar mano de obra
    console.log("\n👷 Procesando categorías de mano de obra...");
    const laborStartMarker = "INSERT INTO `tbl_mano_obra`";
    const laborEndMarker = "--";
    
    const laborStartIndex = sqlContent.indexOf(laborStartMarker);
    let laborEndIndex = sqlContent.indexOf(laborEndMarker, laborStartIndex);
    
    if (laborStartIndex !== -1 && laborEndIndex !== -1) {
      const laborSection = sqlContent.substring(laborStartIndex, laborEndIndex);
      const laborLines = laborSection
        .split('\n')
        .filter(line => line.trim().startsWith('('))
        .map(line => line.trim().replace(/,$/, '').replace(/;$/, ''));
      
      console.log(`📋 Encontradas ${laborLines.length} categorías de mano de obra`);
      
      let laborImported = 0;
      for (const line of laborLines) {
        const laborData = parseLaborData(line);
        if (laborData) {
          try {
            await db.insert(laborCategories).values({
              name: laborData.Descripcion,
              description: `Categoría de mano de obra: ${laborData.Descripcion}`,
              unit: laborData.Unidad,
              hourlyRate: laborData.PU.toString(),
              skillLevel: getSkillLevel(laborData.Descripcion),
              isActive: true
            });
            laborImported++;
            console.log(`   ✅ Mano de obra: ${laborData.Descripcion} - ${laborData.PU} BOB/${laborData.Unidad} (${getSkillLevel(laborData.Descripcion)})`);
          } catch (error) {
            console.log(`   ❌ Error importando mano de obra ${laborData.Descripcion}:`, error);
          }
        }
      }
      
      console.log(`✅ Categorías de mano de obra importadas: ${laborImported}`);
    }
    
    // Resumen final
    const totalTools = await db.select().from(tools);
    const totalLabor = await db.select().from(laborCategories);
    
    console.log("\n📊 RESUMEN FINAL:");
    console.log(`   • Herramientas en el sistema: ${totalTools.length}`);
    console.log(`   • Categorías de mano de obra: ${totalLabor.length}`);
    
    return {
      success: true,
      message: "Importación de herramientas y mano de obra completada",
      data: {
        totalTools: totalTools.length,
        totalLabor: totalLabor.length
      }
    };
    
  } catch (error) {
    console.error("❌ Error durante la importación:", error);
    throw error;
  }
}