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
    
    // Extract all INSERT statements for materials
    const insertRegex = /INSERT INTO `tbl_materiales`[^;]+;/gi;
    const insertStatements = sqlContent.match(insertRegex) || [];
    
    console.log(`Found ${insertStatements.length} insert statements`);
    
    let totalInserted = 0;
    
    for (const statement of insertStatements) {
      // Extract values from each INSERT statement
      const valuesMatch = statement.match(/VALUES\s*(.*);$/);
      if (!valuesMatch) continue;
      
      const valuesString = valuesMatch[1];
      
      // Parse individual value rows by splitting on parentheses
      const rows = valuesString.split(/\),\s*\(/);
      
      for (let i = 0; i < rows.length; i++) {
        let rowData = rows[i].replace(/^\(|\)$/g, '');
        const valuesList = rowData.split(',').map(v => v.trim().replace(/^'|'$/g, ''));
        
        if (valuesList.length >= 5) {
          const materialData: MaterialData = {
            IdClasMaterial: parseInt(valuesList[1]) || 1,
            Descripcion: valuesList[2] || 'Material sin descripción',
            Unidad: valuesList[3] || 'Unidad',
            LP: parseFloat(valuesList[4]) || 0
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
              description: `Material de categoría ${categoryId}`
            });
            
            totalInserted++;
            
            if (totalInserted % 50 === 0) {
              console.log(`Inserted ${totalInserted} materials...`);
            }
          } catch (error) {
            // Skip duplicates or invalid entries
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