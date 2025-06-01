import { db } from "./db";
import { supplierCompanies } from "../shared/schema";
import { eq } from "drizzle-orm";

interface CompanyClassification {
  id: number;
  companyName: string;
  suggestedSpeciality: string;
  reason: string;
}

/**
 * Clasifica empresas por rubro basándose en sus nombres y tipos de negocio
 */
function classifyCompanyByName(companyName: string, businessType: string): { speciality: string; reason: string } {
  const name = companyName.toLowerCase();
  
  // Construcción y constructoras
  if (name.includes('construct') || name.includes('constructora')) {
    return { speciality: 'general', reason: 'Empresa constructora general' };
  }
  
  // Muebles
  if (name.includes('mueble') || name.includes('mobili') || name.includes('carpinte')) {
    return { speciality: 'maderas', reason: 'Empresa de muebles y carpintería' };
  }
  
  // Eléctricos
  if (name.includes('electric') || name.includes('electro') || name.includes('electrocable') || 
      name.includes('bolivian electric') || name.includes('equicomst') || name.includes('fabocelt') ||
      name.includes('makose')) {
    return { speciality: 'electricos', reason: 'Materiales eléctricos' };
  }
  
  // Acero y metales
  if (name.includes('ferro') || name.includes('metal') || name.includes('acero') || 
      name.includes('hierro') || name.includes('mil metales')) {
    return { speciality: 'acero', reason: 'Acero y materiales metálicos' };
  }
  
  // Vidrios
  if (name.includes('vidrio') || name.includes('cristal') || name.includes('templa')) {
    return { speciality: 'vidrios', reason: 'Vidrios y cristales' };
  }
  
  // Cemento y hormigón
  if (name.includes('cement') || name.includes('hormig') || name.includes('concret') || 
      name.includes('vigueta') || name.includes('prensad')) {
    return { speciality: 'cemento', reason: 'Cemento y elementos prefabricados' };
  }
  
  // Plomería
  if (name.includes('plomer') || name.includes('gasfit') || name.includes('agua') ||
      name.includes('sanitari')) {
    return { speciality: 'plomeria', reason: 'Plomería y gasfitería' };
  }
  
  // Cerámicos y pisos
  if (name.includes('ceramic') || name.includes('piso') || name.includes('mosaico') ||
      name.includes('marmol') || name.includes('gramar')) {
    return { speciality: 'ceramicos', reason: 'Cerámicos, pisos y mármol' };
  }
  
  // Pinturas
  if (name.includes('pintura') || name.includes('barniz') || name.includes('esmalte')) {
    return { speciality: 'pinturas', reason: 'Pinturas y acabados' };
  }
  
  // Publicidad y diseño (no construcción tradicional)
  if (name.includes('publicidad') || name.includes('gigant') || name.includes('graphics') ||
      name.includes('neon') || name.includes('logo') || name.includes('diseño')) {
    return { speciality: 'general', reason: 'Empresa de publicidad y diseño' };
  }
  
  // Herramientas
  if (name.includes('herram') || name.includes('tool') || name.includes('equip')) {
    return { speciality: 'herramientas', reason: 'Herramientas y equipos' };
  }
  
  // Elevadores y mecánica
  if (name.includes('elevator') || name.includes('elevador') || name.includes('mowrey')) {
    return { speciality: 'herramientas', reason: 'Equipos especializados' };
  }
  
  // Según el tipo de negocio
  if (businessType === 'manufacturer') {
    if (name.includes('mueble')) {
      return { speciality: 'maderas', reason: 'Fabricante de muebles' };
    }
    return { speciality: 'general', reason: 'Fabricante general' };
  }
  
  // Por defecto, general
  return { speciality: 'general', reason: 'Empresa general de construcción' };
}

export async function organizeCompaniesBySpecialty() {
  console.log("🔄 Iniciando organización de empresas por especialidad...");
  
  try {
    // Obtener todas las empresas sin especialidad definida
    const companies = await db.select().from(supplierCompanies);
    const companiesToUpdate = companies.filter(company => !company.speciality);
    
    console.log(`📊 Encontradas ${companiesToUpdate.length} empresas sin especialidad definida`);
    
    const classifications: CompanyClassification[] = [];
    let updatedCount = 0;
    
    // Clasificar cada empresa
    for (const company of companiesToUpdate) {
      const classification = classifyCompanyByName(company.companyName, company.businessType || '');
      
      classifications.push({
        id: company.id,
        companyName: company.companyName,
        suggestedSpeciality: classification.speciality,
        reason: classification.reason
      });
      
      // Actualizar en la base de datos
      await db
        .update(supplierCompanies)
        .set({ 
          speciality: classification.speciality,
          updatedAt: new Date()
        })
        .where(eq(supplierCompanies.id, company.id));
      
      updatedCount++;
      
      if (updatedCount % 10 === 0) {
        console.log(`✅ Actualizadas ${updatedCount} empresas...`);
      }
    }
    
    // Mostrar resumen por especialidad
    const summary = classifications.reduce((acc, curr) => {
      acc[curr.suggestedSpeciality] = (acc[curr.suggestedSpeciality] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);
    
    console.log("\n📈 Resumen de empresas organizadas por especialidad:");
    Object.entries(summary).forEach(([speciality, count]) => {
      const labels: Record<string, string> = {
        acero: "Acero para Construcción",
        aluminio: "Aluminio", 
        cemento: "Cemento y Hormigón",
        agua: "Agua y Saneamiento",
        electricos: "Materiales Eléctricos",
        ceramicos: "Cerámicos y Pisos",
        maderas: "Maderas",
        pinturas: "Pinturas y Acabados",
        plomeria: "Plomería y Gasfitería",
        prefabricados: "Elementos Prefabricados",
        herramientas: "Herramientas y Equipos",
        seguridad: "Seguridad Industrial",
        aislantes: "Materiales Aislantes",
        vidrios: "Vidrios y Cristales",
        general: "General/Varios"
      };
      console.log(`   ${labels[speciality] || speciality}: ${count} empresas`);
    });
    
    console.log(`\n✅ Proceso completado. ${updatedCount} empresas organizadas por especialidad.`);
    
    return {
      totalUpdated: updatedCount,
      classifications,
      summary
    };
    
  } catch (error) {
    console.error("❌ Error organizando empresas por especialidad:", error);
    throw error;
  }
}

// Ejecutar el script
organizeCompaniesBySpecialty()
  .then(() => {
    console.log("🎉 Organización completada exitosamente!");
    process.exit(0);
  })
  .catch((error) => {
    console.error("❌ Error en la organización:", error);
    process.exit(1);
  });