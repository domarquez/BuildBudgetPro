#!/usr/bin/env node

// Script para exportar todas las tablas de MICAA a archivos SQL
import { Pool } from '@neondatabase/serverless';
import fs from 'fs';
import path from 'path';

// Configuración de la base de datos
const pool = new Pool({ 
  connectionString: process.env.DATABASE_URL 
});

async function exportTable(tableName) {
  try {
    console.log(`Exportando tabla: ${tableName}`);
    
    // Obtener la estructura de la tabla
    const structureQuery = `
      SELECT column_name, data_type, is_nullable, column_default
      FROM information_schema.columns 
      WHERE table_name = $1 
      ORDER BY ordinal_position;
    `;
    
    const structureResult = await pool.query(structureQuery, [tableName]);
    
    // Obtener todos los datos
    const dataResult = await pool.query(`SELECT * FROM ${tableName}`);
    
    let sqlContent = `-- Exportación de tabla: ${tableName}\n`;
    sqlContent += `-- Fecha: ${new Date().toISOString()}\n`;
    sqlContent += `-- Total de registros: ${dataResult.rows.length}\n\n`;
    
    // Crear estructura de la tabla (simplificada)
    sqlContent += `-- Estructura de la tabla ${tableName}\n`;
    structureResult.rows.forEach(col => {
      sqlContent += `-- ${col.column_name}: ${col.data_type} (nullable: ${col.is_nullable})\n`;
    });
    sqlContent += '\n';
    
    // Insertar datos
    if (dataResult.rows.length > 0) {
      const columns = Object.keys(dataResult.rows[0]);
      sqlContent += `-- Datos de la tabla ${tableName}\n`;
      
      dataResult.rows.forEach(row => {
        const values = columns.map(col => {
          const value = row[col];
          if (value === null) return 'NULL';
          if (typeof value === 'string') return `'${value.replace(/'/g, "''")}'`;
          if (value instanceof Date) return `'${value.toISOString()}'`;
          if (typeof value === 'object') return `'${JSON.stringify(value).replace(/'/g, "''")}'`;
          return value;
        });
        
        sqlContent += `INSERT INTO ${tableName} (${columns.join(', ')}) VALUES (${values.join(', ')});\n`;
      });
    }
    
    sqlContent += '\n\n';
    
    // Guardar archivo
    const fileName = `export_${tableName}_${new Date().toISOString().split('T')[0]}.sql`;
    fs.writeFileSync(fileName, sqlContent);
    
    console.log(`✓ Tabla ${tableName} exportada: ${dataResult.rows.length} registros → ${fileName}`);
    return fileName;
    
  } catch (error) {
    console.error(`Error exportando tabla ${tableName}:`, error.message);
    return null;
  }
}

async function exportAllTables() {
  try {
    console.log('🚀 Iniciando exportación de base de datos MICAA\n');
    
    // Obtener lista de todas las tablas
    const tablesQuery = `
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      AND table_type = 'BASE TABLE'
      ORDER BY table_name;
    `;
    
    const tablesResult = await pool.query(tablesQuery);
    const tables = tablesResult.rows.map(row => row.table_name);
    
    console.log(`Encontradas ${tables.length} tablas:`);
    tables.forEach(table => console.log(`  - ${table}`));
    console.log('');
    
    const exportedFiles = [];
    
    // Exportar cada tabla
    for (const tableName of tables) {
      const fileName = await exportTable(tableName);
      if (fileName) {
        exportedFiles.push(fileName);
      }
    }
    
    // Crear archivo consolidado
    console.log('\n📦 Creando archivo consolidado...');
    let consolidatedContent = `-- EXPORTACIÓN COMPLETA DE MICAA\n`;
    consolidatedContent += `-- Fecha: ${new Date().toISOString()}\n`;
    consolidatedContent += `-- Tablas exportadas: ${exportedFiles.length}\n\n`;
    
    for (const fileName of exportedFiles) {
      if (fs.existsSync(fileName)) {
        consolidatedContent += fs.readFileSync(fileName, 'utf8');
        consolidatedContent += '\n-- ================================================\n\n';
      }
    }
    
    const consolidatedFileName = `micaa_database_export_${new Date().toISOString().split('T')[0]}.sql`;
    fs.writeFileSync(consolidatedFileName, consolidatedContent);
    
    console.log(`\n✅ Exportación completada:`);
    console.log(`   📁 Archivos individuales: ${exportedFiles.length}`);
    console.log(`   📄 Archivo consolidado: ${consolidatedFileName}`);
    console.log(`   💾 Total de tablas: ${tables.length}`);
    
    // Mostrar estadísticas
    console.log('\n📊 Estadísticas por tabla:');
    for (const tableName of tables) {
      try {
        const countResult = await pool.query(`SELECT COUNT(*) as count FROM ${tableName}`);
        console.log(`   ${tableName}: ${countResult.rows[0].count} registros`);
      } catch (error) {
        console.log(`   ${tableName}: Error contando registros`);
      }
    }
    
  } catch (error) {
    console.error('❌ Error durante la exportación:', error.message);
  } finally {
    await pool.end();
  }
}

// Ejecutar exportación
exportAllTables().catch(console.error);