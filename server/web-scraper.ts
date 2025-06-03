import axios from 'axios';
import * as cheerio from 'cheerio';

interface APUGroup {
  id: string;
  name: string;
  url: string;
}

interface APUItem {
  code: string;
  name: string;
  unit: string;
  price: number;
  url: string;
}

interface APUComposition {
  description: string;
  unit: string;
  quantity: number;
  unitPrice: number;
  totalPrice: number;
  type: 'material' | 'labor' | 'equipment';
}

interface APUDetail {
  code: string;
  name: string;
  unit: string;
  totalPrice: number;
  materials: APUComposition[];
  labor: APUComposition[];
  equipment: APUComposition[];
  indirectCosts: {
    equipment: number;
    administrative: number;
    utility: number;
    tax: number;
  };
}

// Función para obtener APUs específicos usando URLs conocidas
export async function getKnownAPUs(): Promise<APUItem[]> {
  const knownAPUs = [
    {
      code: 'JABON001',
      name: 'JABONERO',
      unit: 'PZA',
      price: 0,
      url: 'https://www.micaa.store/analisis-precio-unitario/hh/artefactos-sanitarios/5/jabonero'
    },
    {
      code: 'HO193',
      name: 'CIMIENTO DE HO AO',
      unit: 'M3',
      price: 0,
      url: 'https://www.micaa.store/analisis-precio-unitario/hh/hormigones/193/cimiento-de-ho-ao'
    },
    {
      code: 'ACCES001',
      name: 'ACCESORIOS DE BAÑO',
      unit: 'JGO',
      price: 525.41,
      url: 'https://www.micaa.store/analisis-precio-unitario/hh/artefactos-sanitarios/1/accesorios-de-bano'
    }
  ];

  console.log(`Usando ${knownAPUs.length} APUs conocidos del sistema`);
  return knownAPUs;
}

// Función para obtener todos los grupos de APU
export async function getAPUGroups(): Promise<APUGroup[]> {
  try {
    console.log('Obteniendo grupos de APU desde base de datos...');
    const response = await axios.get('https://www.micaa.store/analisis-precio-unitario/hh/grupos', {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'es-ES,es;q=0.9,en;q=0.8'
      }
    });

    const $ = cheerio.load(response.data);
    const groups: APUGroup[] = [];

    // Buscar enlaces que sigan el patrón grupos/[número]/[nombre]
    $('a[href*="grupos/"]').each((_, element) => {
      const link = $(element);
      const href = link.attr('href');
      const text = link.text().trim();
      
      if (href && text && href.includes('grupos/') && href.match(/grupos\/\d+\//)) {
        const fullUrl = href.startsWith('http') ? href : `https://www.insucons.com/${href}`;
        const pathParts = href.split('/');
        const groupId = pathParts[pathParts.length - 2] || '';
        
        groups.push({
          id: groupId,
          name: text,
          url: fullUrl
        });
      }
    });

    console.log(`Encontrados ${groups.length} grupos de APU`);
    return groups;
  } catch (error) {
    console.error('Error obteniendo grupos APU:', error);
    throw new Error('No se pudieron obtener los grupos de APU');
  }
}

// Función para obtener APUs de un grupo específico
export async function getAPUsByGroup(groupUrl: string): Promise<APUItem[]> {
  if (groupUrl === 'known') {
    return await getKnownAPUs();
  }
  
  try {
    console.log(`Obteniendo APUs del grupo: ${groupUrl}`);
    const response = await axios.get(groupUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'es-ES,es;q=0.9,en;q=0.8'
      }
    });

    const $ = cheerio.load(response.data);
    const apus: APUItem[] = [];

    // Buscar enlaces específicos que sigan el patrón de APUs individuales
    // Ejemplo: analisis-precio-unitario/hh/cerramiento/108/colocacion-de-malla-olimpica-16
    $('a').each((_, element) => {
      const link = $(element);
      const href = link.attr('href');
      const text = link.text().trim();
      
      if (href && text) {
        // Verificar si es un enlace a un APU individual (tiene patrón: categoria/numero/nombre)
        const apuPattern = /\/[a-z-]+\/\d+\/[a-z0-9-]+$/;
        if (href.match(apuPattern) && !href.includes('/grupos/') && href.includes('analisis-precio-unitario/hh/')) {
          const fullUrl = href.startsWith('http') ? href : `https://www.insucons.com/${href}`;
          const pathParts = href.split('/');
          const code = pathParts[pathParts.length - 2] || ''; // El número del APU
          const name = text;
          
          apus.push({
            code,
            name,
            unit: 'UND',
            price: 0,
            url: fullUrl
          });
        }
      }
    });

    // También buscar en tablas si las hay
    $('table tr').each((_, row) => {
      const $row = $(row);
      const cells = $row.find('td');
      
      if (cells.length >= 2) {
        const link = cells.find('a').first();
        const href = link.attr('href');
        const name = link.text().trim() || cells.eq(1).text().trim();
        
        if (href && name && href.match(/\/\d+\/[a-z0-9-]+$/)) {
          const fullUrl = href.startsWith('http') ? href : `https://www.insucons.com/${href}`;
          const pathParts = href.split('/');
          const code = pathParts[pathParts.length - 2] || '';
          
          apus.push({
            code,
            name,
            unit: cells.eq(2)?.text().trim() || 'UND',
            price: parseFloat(cells.eq(3)?.text().replace(/[^\d.,]/g, '').replace(',', '.')) || 0,
            url: fullUrl
          });
        }
      }
    });

    // Eliminar duplicados basándose en la URL
    const uniqueAPUs = apus.filter((apu, index, self) => 
      index === self.findIndex(a => a.url === apu.url)
    );

    console.log(`Encontrados ${uniqueAPUs.length} APUs únicos en el grupo`);
    return uniqueAPUs;
  } catch (error) {
    console.error('Error obteniendo APUs del grupo:', error);
    return [];
  }
}

// Función para obtener el detalle completo de un APU
export async function getAPUDetail(apuUrl: string): Promise<APUDetail | null> {
  try {
    console.log(`Obteniendo detalle del APU: ${apuUrl}`);
    const response = await axios.get(apuUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'es-ES,es;q=0.9,en;q=0.8',
        'Accept-Encoding': 'gzip, deflate, br',
        'DNT': '1',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1'
      }
    });

    const $ = cheerio.load(response.data);
    
    // Extraer información básica del título de la página
    const pageTitle = $('title').text() || '';
    const h2Title = $('h2').first().text().trim();
    
    const name = h2Title || pageTitle.split(' - ')[0] || 'APU';
    const code = apuUrl.split('/').pop() || '';
    
    // Buscar el precio total al final de la página
    let totalPrice = 0;
    $('td, th, span, div').each((_, element) => {
      const text = $(element).text().trim();
      if (text.includes('Total') && text.includes('Precio') && text.includes('Unitario')) {
        const nextElement = $(element).next();
        const priceText = nextElement.text() || $(element).text();
        const match = priceText.match(/(\d+(?:\.\d+)?)/);
        if (match) {
          totalPrice = parseFloat(match[1]);
        }
      }
    });

    const materials: APUComposition[] = [];
    const labor: APUComposition[] = [];
    const equipment: APUComposition[] = [];

    // Buscar secciones específicas por encabezados
    let currentSection = '';
    
    $('*').each((_, element) => {
      const $el = $(element);
      const text = $el.text().trim();
      
      // Identificar secciones
      if (text.includes('1. MATERIALES')) {
        currentSection = 'materials';
        return;
      } else if (text.includes('2. MANO DE OBRA')) {
        currentSection = 'labor';
        return;
      } else if (text.includes('3. EQUIPO')) {
        currentSection = 'equipment';
        return;
      } else if (text.includes('4. GASTOS GENERALES') || text.includes('5. UTILIDAD') || text.includes('6. IMPUESTOS')) {
        currentSection = 'indirect';
        return;
      }
      
      // Extraer datos de filas de tabla
      if ($el.is('tr') && currentSection && currentSection !== 'indirect') {
        const cells = $el.find('td');
        if (cells.length >= 5) {
          const description = cells.eq(1).text().trim();
          const unit = cells.eq(2).text().trim();
          const quantity = parseFloat(cells.eq(3).text().trim()) || 0;
          const unitPrice = parseFloat(cells.eq(4).text().trim()) || 0;
          const totalCost = parseFloat(cells.eq(5).text().trim()) || (quantity * unitPrice);

          if (description && quantity > 0 && description !== 'Descripción') {
            const composition: APUComposition = {
              description,
              unit,
              quantity,
              unitPrice,
              totalPrice: totalCost,
              type: currentSection as 'material' | 'labor' | 'equipment'
            };

            switch (currentSection) {
              case 'materials':
                materials.push(composition);
                break;
              case 'labor':
                labor.push(composition);
                break;
              case 'equipment':
                equipment.push(composition);
                break;
            }
          }
        }
      }
    });

    // Buscar costos indirectos basándose en patrones de texto específicos
    const indirectCosts = {
      equipment: 0,
      administrative: 0,
      utility: 0,
      tax: 0
    };

    $('*').each((_, element) => {
      const text = $(element).text();
      
      // Buscar porcentajes específicos
      if (text.includes('Herramientas') && text.includes('%')) {
        const match = text.match(/(\d+(?:\.\d+)?)%/);
        if (match) indirectCosts.equipment = parseFloat(match[1]);
      }
      
      if (text.includes('Gastos generales') && text.includes('%')) {
        const match = text.match(/(\d+(?:\.\d+)?)%/);
        if (match) indirectCosts.administrative = parseFloat(match[1]);
      }
      
      if (text.includes('Utilidad') && text.includes('%')) {
        const match = text.match(/(\d+(?:\.\d+)?)%/);
        if (match) indirectCosts.utility = parseFloat(match[1]);
      }
      
      if (text.includes('IT') && text.includes('%')) {
        const match = text.match(/(\d+(?:\.\d+)?)%/);
        if (match) indirectCosts.tax = parseFloat(match[1]);
      }
    });

    console.log(`Extraído APU: ${name}, Materiales: ${materials.length}, Mano de obra: ${labor.length}, Equipos: ${equipment.length}`);

    return {
      code,
      name,
      unit: 'UND',
      totalPrice,
      materials,
      labor,
      equipment,
      indirectCosts
    };

  } catch (error) {
    console.error('Error obteniendo detalle del APU:', error);
    return null;
  }
}

// Función para importar APUs por lotes desde insucons.com
export async function importAPUsFromInsucons(limitGroups?: number): Promise<{
  imported: number;
  errors: number;
  details: string[];
}> {
  const results = {
    imported: 0,
    errors: 0,
    details: [] as string[]
  };

  try {
    // Obtener grupos
    const groups = await getAPUGroups();
    const groupsToProcess = limitGroups ? groups.slice(0, limitGroups) : groups;
    
    results.details.push(`Procesando ${groupsToProcess.length} grupos de APU`);

    for (const group of groupsToProcess) {
      try {
        // Obtener APUs del grupo
        const apus = await getAPUsByGroup(group.url);
        
        for (const apu of apus.slice(0, 5)) { // Limitar a 5 APUs por grupo para no sobrecargar
          try {
            if (apu.url) {
              const detail = await getAPUDetail(apu.url);
              if (detail) {
                // Aquí llamarías a la función que guarda en la base de datos
                results.imported++;
                results.details.push(`Importado: ${detail.name}`);
              }
            }
          } catch (error) {
            results.errors++;
            results.details.push(`Error en APU ${apu.name}: ${error}`);
          }
          
          // Pausa pequeña para no sobrecargar el servidor
          await new Promise(resolve => setTimeout(resolve, 500));
        }
        
      } catch (error) {
        results.errors++;
        results.details.push(`Error en grupo ${group.name}: ${error}`);
      }
    }

  } catch (error) {
    results.errors++;
    results.details.push(`Error general: ${error}`);
  }

  return results;
}