import { db } from './db';
import { sql } from 'drizzle-orm';
import fs from 'fs';

// Función para exportar todas las tablas de MICAA
export async function exportDatabase() {
  console.log('🚀 Iniciando exportación de base de datos MICAA\n');
  
  try {
    // Obtener lista de todas las tablas
    const tablesResult = await db.execute(sql`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      AND table_type = 'BASE TABLE'
      ORDER BY table_name;
    `);
    
    const tables = tablesResult.rows.map((row: any) => row.table_name);
    
    console.log(`Encontradas ${tables.length} tablas:`);
    tables.forEach(table => console.log(`  - ${table}`));
    console.log('');
    
    let consolidatedContent = `-- EXPORTACIÓN COMPLETA DE MICAA\n`;
    consolidatedContent += `-- Fecha: ${new Date().toISOString()}\n`;
    consolidatedContent += `-- Total de tablas: ${tables.length}\n\n`;
    
    // Exportar cada tabla
    for (const tableName of tables) {
      try {
        console.log(`Exportando tabla: ${tableName}`);
        
        // Obtener estructura de la tabla
        const structureResult = await db.execute(sql.raw(`
          SELECT column_name, data_type, is_nullable, column_default
          FROM information_schema.columns 
          WHERE table_name = '${tableName}' 
          ORDER BY ordinal_position;
        `));
        
        // Obtener datos de la tabla
        const dataResult = await db.execute(sql.raw(`SELECT * FROM ${tableName}`));
        
        consolidatedContent += `-- ================================================\n`;
        consolidatedContent += `-- Tabla: ${tableName}\n`;
        consolidatedContent += `-- Registros: ${dataResult.rows.length}\n`;
        consolidatedContent += `-- ================================================\n\n`;
        
        // Agregar información de estructura
        consolidatedContent += `-- Estructura de la tabla ${tableName}\n`;
        structureResult.rows.forEach((col: any) => {
          consolidatedContent += `-- ${col.column_name}: ${col.data_type} (nullable: ${col.is_nullable})\n`;
        });
        consolidatedContent += '\n';
        
        // Agregar datos
        if (dataResult.rows.length > 0) {
          const columns = Object.keys(dataResult.rows[0]);
          consolidatedContent += `-- Datos de la tabla ${tableName}\n`;
          
          dataResult.rows.forEach((row: any) => {
            const values = columns.map(col => {
              const value = row[col];
              if (value === null) return 'NULL';
              if (typeof value === 'string') return `'${value.replace(/'/g, "''")}'`;
              if (value instanceof Date) return `'${value.toISOString()}'`;
              if (typeof value === 'object') return `'${JSON.stringify(value).replace(/'/g, "''")}'`;
              return value;
            });
            
            consolidatedContent += `INSERT INTO ${tableName} (${columns.join(', ')}) VALUES (${values.join(', ')});\n`;
          });
        }
        
        consolidatedContent += '\n\n';
        
        console.log(`✓ Tabla ${tableName}: ${dataResult.rows.length} registros exportados`);
        
      } catch (error) {
        console.error(`Error exportando tabla ${tableName}:`, error);
        consolidatedContent += `-- Error exportando tabla ${tableName}: ${error}\n\n`;
      }
    }
    
    // Guardar archivo consolidado
    const fileName = `micaa_database_export_${new Date().toISOString().split('T')[0]}.sql`;
    fs.writeFileSync(fileName, consolidatedContent);
    
    console.log(`\n✅ Exportación completada:`);
    console.log(`   📄 Archivo: ${fileName}`);
    console.log(`   💾 Total de tablas: ${tables.length}`);
    
    // Mostrar estadísticas por tabla
    console.log('\n📊 Estadísticas por tabla:');
    for (const tableName of tables) {
      try {
        const countResult = await db.execute(sql.raw(`SELECT COUNT(*) as count FROM ${tableName}`));
        console.log(`   ${tableName}: ${(countResult.rows[0] as any).count} registros`);
      } catch (error) {
        console.log(`   ${tableName}: Error contando registros`);
      }
    }
    
    return fileName;
    
  } catch (error) {
    console.error('❌ Error durante la exportación:', error);
    throw error;
  }
}

// Ejecutar si se llama directamente
if (import.meta.url === `file://${process.argv[1]}`) {
  exportDatabase().catch(console.error);
}