import { readFileSync } from 'fs';
import { db } from './db';
import { materials } from '@shared/schema';

interface MaterialData {
  IdClasMaterial: number;
  Descripcion: string;
  Unidad: string;
  LP: number;
}

export async function importMaterialsFromSQL() {
  try {
    console.log('Starting materials import...');
    
    // Read the SQL file
    const sqlContent = readFileSync('./attached_assets/datos2.sql', 'utf-8');
    
    // Find the exact INSERT statements with VALUES
    const materialsSection = sqlContent.match(/INSERT INTO `tbl_materiales`[\s\S]*?VALUES\s*([\s\S]*?)(?=INSERT INTO|$)/gi);
    
    if (!materialsSection || materialsSection.length === 0) {
      console.log('No materials section found');
      return { success: false, error: 'No materials data found in SQL file' };
    }
    
    console.log(`Found ${materialsSection.length} materials sections`);
    
    let totalInserted = 0;
    
    for (const section of materialsSection) {
      // Extract just the VALUES part
      const valuesMatch = section.match(/VALUES\s*([\s\S]*)/i);
      if (!valuesMatch) continue;
      
      let valuesString = valuesMatch[1];
      
      // Clean up and split by rows
      valuesString = valuesString.replace(/;[\s\S]*$/, ''); // Remove everything after semicolon
      
      // Split by ),( pattern to get individual rows
      const rows = valuesString.split(/\),\s*\(/);
      
      console.log(`Processing ${rows.length} rows in this section`);
      
      for (let i = 0; i < rows.length; i++) {
        let rowData = rows[i];
        
        // Clean up the row data
        rowData = rowData.replace(/^\(/, '').replace(/\)$/, '');
        
        // Split by comma, but be careful with quoted strings
        const values = [];
        let current = '';
        let inQuotes = false;
        let quoteChar = '';
        
        for (let j = 0; j < rowData.length; j++) {
          const char = rowData[j];
          
          if ((char === '"' || char === "'") && !inQuotes) {
            inQuotes = true;
            quoteChar = char;
          } else if (char === quoteChar && inQuotes) {
            inQuotes = false;
            quoteChar = '';
          } else if (char === ',' && !inQuotes) {
            values.push(current.trim().replace(/^['"]|['"]$/g, ''));
            current = '';
            continue;
          }
          
          current += char;
        }
        
        // Don't forget the last value
        if (current) {
          values.push(current.trim().replace(/^['"]|['"]$/g, ''));
        }
        
        if (values.length >= 5) {
          const materialData: MaterialData = {
            IdClasMaterial: parseInt(values[1]) || 1,
            Descripcion: values[2] || 'Material sin descripción',
            Unidad: values[3] || 'Unidad',
            LP: parseFloat(values[4]) || 0
          };
          
          // Skip if price is 0 or invalid
          if (materialData.LP <= 0) continue;
          
          // Map category ID (some adjustments might be needed)
          let categoryId = materialData.IdClasMaterial;
          if (categoryId > 58) categoryId = 1; // Default to steel if category doesn't exist
          
          try {
            await db.insert(materials).values({
              categoryId: categoryId,
              name: materialData.Descripcion.substring(0, 100),
              unit: materialData.Unidad,
              price: materialData.LP.toString(),
              description: `Importado de archivo SQL - Categoría ${categoryId}`
            });
            
            totalInserted++;
            
            if (totalInserted % 100 === 0) {
              console.log(`Inserted ${totalInserted} materials...`);
            }
          } catch (error) {
            // Skip duplicates or invalid entries
            console.log(`Skipped material: ${materialData.Descripcion}`);
            continue;
          }
        }
      }
    }
    
    console.log(`Import completed. Total materials inserted: ${totalInserted}`);
    return { success: true, totalInserted };
    
  } catch (error) {
    console.error('Error importing materials:', error);
    return { success: false, error: String(error) };
  }
}