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

function parseCompanyData(line: string): SqlClasificado | null {
  // Extraer datos usando regex para parsear la línea SQL
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

export async function extractAndImportAllCompanies() {
  console.log("🚀 Extrayendo TODAS las empresas del archivo SQL...");
  
  try {
    // Leer el archivo SQL completo
    const sqlContent = readFileSync('../attached_assets/datos2.sql', 'utf-8');
    
    // Encontrar la sección de tbl_clasificados
    const startMarker = "INSERT INTO `tbl_clasificados`";
    const endMarker = "AUTO_INCREMENT for table `tbl_clasificados`";
    
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
    
    console.log(`📋 Encontradas ${dataLines.length} empresas en el archivo SQL`);
    
    const empresas: SqlClasificado[] = [];
    
    for (const line of dataLines) {
      const empresa = parseCompanyData(line);
      if (empresa && empresa.Empresa) {
        empresas.push(empresa);
      }
    }
    
    console.log(`✅ Parseadas ${empresas.length} empresas válidas`);
    
    // Importar todas las empresas en lotes
    let importedCount = 0;
    let errorCount = 0;
    const batchSize = 10;
    
    for (let i = 0; i < empresas.length; i += batchSize) {
      const batch = empresas.slice(i, i + batchSize);
      console.log(`Procesando lote ${Math.floor(i/batchSize) + 1}/${Math.ceil(empresas.length/batchSize)}: empresas ${i + 1}-${Math.min(i + batchSize, empresas.length)}`);
      
      for (const empresa of batch) {
        try {
          // Crear usuario para la empresa
          const username = empresa.Empresa.toLowerCase()
            .replace(/[^a-z0-9]/g, '_')
            .replace(/_+/g, '_')
            .slice(0, 50);
          
          const email = empresa.Email || `${username}@empresa.com`;
          
          // Verificar si el usuario ya existe por username o email
          const existingUser = await storage.getUserByUsername(username) || 
                              await storage.getUserByEmail(email);
          let userId: number;
          
          if (!existingUser) {
            const password = await bcrypt.hash('empresa123', 10);
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
            userId = newUser.id;
          } else {
            userId = existingUser.id;
          }
          
          // Verificar si ya existe la empresa proveedora
          const existingCompany = await storage.getSupplierCompanyByUser(userId);
          
          if (!existingCompany) {
            await db.insert(supplierCompanies).values({
              userId,
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
            console.log(`✅ Importada: ${empresa.Empresa}`);
          } else {
            console.log(`⚠️ Ya existe: ${empresa.Empresa}`);
          }
          
        } catch (error) {
          console.log(`❌ Error importando empresa ${empresa.Empresa}:`, error);
          errorCount++;
        }
      }
    }
    
    console.log(`✅ Importación completa: ${importedCount} empresas nuevas, ${errorCount} errores`);
    
    // Resumen final
    const totalSuppliers = await db.select().from(supplierCompanies);
    const totalUsers = await db.select().from(users);
    
    console.log("📊 RESUMEN FINAL:");
    console.log(`   • Total empresas en el sistema: ${totalSuppliers.length}`);
    console.log(`   • Total usuarios: ${totalUsers.length}`);
    console.log(`   • Empresas nuevas importadas: ${importedCount}`);
    
    return {
      success: true,
      message: "Importación completa exitosa",
      data: {
        totalSuppliers: totalSuppliers.length,
        newImported: importedCount,
        errors: errorCount,
        totalUsers: totalUsers.length
      }
    };
    
  } catch (error) {
    console.error("❌ Error durante la extracción e importación:", error);
    throw error;
  }
}