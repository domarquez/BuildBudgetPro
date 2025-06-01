import { readFileSync } from 'fs';
import { db } from "./db";
import { supplierCompanies, users } from "@shared/schema";
import { storage } from "./storage";
import bcrypt from "bcryptjs";

interface SqlClasificado {
  IdClasificado: number;
  IdRubro: string;
  Empresa: string;
  Logo: string;
  Direccion: string;
  Email: string;
  Url: string;
}

function parseCompanyData(line: string): SqlClasificado | null {
  const match = line.match(/\((\d+),\s*'([^']*)',\s*'([^']*)',\s*'([^']*)',\s*'([^']*)',\s*'([^']*)',\s*'([^']*)'\)/);
  
  if (!match) return null;
  
  return {
    IdClasificado: parseInt(match[1]),
    IdRubro: match[2],
    Empresa: match[3],
    Logo: match[4],
    Direccion: match[5],
    Email: match[6],
    Url: match[7]
  };
}

function extractPhoneFromAddress(direccion: string): string {
  const phoneMatch = direccion.match(/tel\.?(\d{3}-?\d{4})/i);
  return phoneMatch ? phoneMatch[1] : '';
}

function cleanAddress(direccion: string): string {
  return direccion
    .replace(/tel\.?\d{3}-?\d{4}/gi, '')
    .replace(/fax\.?\d{3}-?\d{4}/gi, '')
    .replace(/\r\n/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function getBusinessType(rubro: string): string {
  switch (rubro.toLowerCase()) {
    case 'materiales':
      return 'retailer';
    case 'empresas':
      return 'distributor';
    case 'diseño':
      return 'manufacturer';
    case 'eléctrica':
      return 'wholesaler';
    default:
      return 'retailer';
  }
}

export async function findAndImportMissingCompanies() {
  console.log("🔍 Buscando empresas faltantes...");
  
  try {
    // Leer el archivo SQL completo
    const sqlContent = readFileSync('../attached_assets/datos2.sql', 'utf-8');
    
    // Encontrar la sección de tbl_clasificados
    const startMarker = "INSERT INTO `tbl_clasificados`";
    const endMarker = "INSERT INTO `tbl_herramientas`";
    
    const startIndex = sqlContent.indexOf(startMarker);
    const endIndex = sqlContent.indexOf(endMarker);
    
    if (startIndex === -1 || endIndex === -1) {
      throw new Error("No se pudo encontrar la sección de clasificados en el archivo SQL");
    }
    
    const clasificadosSection = sqlContent.substring(startIndex, endIndex);
    
    // Extraer todas las líneas de datos
    const dataLines = clasificadosSection
      .split('\n')
      .filter(line => line.trim().startsWith('('))
      .map(line => line.trim().replace(/,$/, '').replace(/;$/, ''));
    
    console.log(`📋 Total empresas en archivo SQL: ${dataLines.length}`);
    
    const empresasArchivo: SqlClasificado[] = [];
    
    for (const line of dataLines) {
      const empresa = parseCompanyData(line);
      if (empresa && empresa.Empresa) {
        empresasArchivo.push(empresa);
      }
    }
    
    console.log(`✅ Empresas válidas parseadas: ${empresasArchivo.length}`);
    
    // Obtener todas las empresas ya importadas
    const empresasImportadas = await db.select().from(supplierCompanies);
    const nombresImportados = new Set(empresasImportadas.map(e => e.companyName));
    
    console.log(`💾 Empresas ya en base de datos: ${empresasImportadas.length}`);
    
    // Identificar empresas faltantes
    const empresasFaltantes = empresasArchivo.filter(empresa => 
      !nombresImportados.has(empresa.Empresa)
    );
    
    console.log(`❌ Empresas faltantes: ${empresasFaltantes.length}`);
    
    if (empresasFaltantes.length === 0) {
      console.log("✅ Todas las empresas ya están importadas!");
      return {
        success: true,
        message: "No hay empresas faltantes",
        data: {
          totalArchivo: empresasArchivo.length,
          totalImportadas: empresasImportadas.length,
          faltantes: 0
        }
      };
    }
    
    // Mostrar cuáles faltan
    console.log("📝 Empresas faltantes:");
    empresasFaltantes.forEach((empresa, index) => {
      console.log(`   ${index + 1}. ${empresa.Empresa}`);
    });
    
    // Importar empresas faltantes en lotes de 3
    let importedCount = 0;
    let errorCount = 0;
    const batchSize = 3;
    
    for (let i = 0; i < empresasFaltantes.length; i += batchSize) {
      const batch = empresasFaltantes.slice(i, i + batchSize);
      console.log(`\n🔄 Procesando lote ${Math.floor(i/batchSize) + 1}/${Math.ceil(empresasFaltantes.length/batchSize)}`);
      
      for (const empresa of batch) {
        try {
          console.log(`   Importando: ${empresa.Empresa}`);
          
          // Crear usuario único
          const baseUsername = empresa.Empresa.toLowerCase()
            .replace(/[^a-z0-9]/g, '_')
            .replace(/_+/g, '_')
            .slice(0, 40);
          
          let username = baseUsername;
          let counter = 1;
          
          // Asegurar username único
          while (await storage.getUserByUsername(username)) {
            username = `${baseUsername}_${counter}`;
            counter++;
          }
          
          const email = empresa.Email || `${username}@empresa.com`;
          const password = await bcrypt.hash('empresa123', 10);
          
          // Crear usuario
          const [newUser] = await db.insert(users).values({
            username,
            email,
            password,
            firstName: empresa.Empresa.split(' ')[0],
            lastName: empresa.Empresa.split(' ').slice(1).join(' ') || '',
            role: 'user',
            userType: 'supplier',
            isActive: true,
            city: 'Santa Cruz',
            country: 'Bolivia'
          }).returning();
          
          // Crear empresa proveedora
          await db.insert(supplierCompanies).values({
            userId: newUser.id,
            companyName: empresa.Empresa,
            businessType: getBusinessType(empresa.IdRubro),
            description: `Empresa especializada en ${empresa.IdRubro.toLowerCase()} con años de experiencia en el mercado boliviano.`,
            address: cleanAddress(empresa.Direccion),
            city: 'Santa Cruz',
            country: 'Bolivia',
            phone: extractPhoneFromAddress(empresa.Direccion),
            whatsapp: extractPhoneFromAddress(empresa.Direccion),
            website: empresa.Url || '',
            facebook: '',
            membershipType: Math.random() > 0.7 ? 'premium' : 'free',
            isActive: true,
            isVerified: true,
            rating: '4.2',
            reviewCount: Math.floor(Math.random() * 50) + 5
          });
          
          importedCount++;
          console.log(`   ✅ Importada exitosamente: ${empresa.Empresa}`);
          
        } catch (error) {
          console.log(`   ❌ Error importando ${empresa.Empresa}:`, error);
          errorCount++;
        }
      }
    }
    
    // Resumen final
    const totalFinal = await db.select().from(supplierCompanies);
    
    console.log("\n📊 RESUMEN FINAL:");
    console.log(`   • Empresas en archivo SQL: ${empresasArchivo.length}`);
    console.log(`   • Empresas faltantes encontradas: ${empresasFaltantes.length}`);
    console.log(`   • Empresas importadas ahora: ${importedCount}`);
    console.log(`   • Errores: ${errorCount}`);
    console.log(`   • Total empresas en sistema: ${totalFinal.length}`);
    
    return {
      success: true,
      message: "Importación de empresas faltantes completada",
      data: {
        totalArchivo: empresasArchivo.length,
        faltantesEncontradas: empresasFaltantes.length,
        nuevasImportadas: importedCount,
        errores: errorCount,
        totalFinal: totalFinal.length
      }
    };
    
  } catch (error) {
    console.error("❌ Error durante la búsqueda e importación:", error);
    throw error;
  }
}