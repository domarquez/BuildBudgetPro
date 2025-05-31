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

// Función para obtener todos los grupos de APU
export async function getAPUGroups(): Promise<APUGroup[]> {
  try {
    console.log('Obteniendo grupos de APU desde insucons.com...');
    const response = await axios.get('https://www.insucons.com/analisis-precio-unitario/hh/grupos', {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      }
    });

    const $ = cheerio.load(response.data);
    const groups: APUGroup[] = [];

    // Buscar enlaces a grupos de APU
    $('a[href*="/analisis-precio-unitario/hh/"]').each((_, element) => {
      const link = $(element);
      const href = link.attr('href');
      const text = link.text().trim();
      
      if (href && text && href.includes('/grupos/')) {
        groups.push({
          id: href.split('/').pop() || '',
          name: text,
          url: href.startsWith('http') ? href : `https://www.insucons.com${href}`
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
  try {
    console.log(`Obteniendo APUs del grupo: ${groupUrl}`);
    const response = await axios.get(groupUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      }
    });

    const $ = cheerio.load(response.data);
    const apus: APUItem[] = [];

    // Buscar tabla de APUs o enlaces a APUs individuales
    $('tr, .apu-item, a[href*="/analisis-precio-unitario/hh/item/"]').each((_, element) => {
      const $el = $(element);
      
      // Intentar extraer información del APU
      let code = '';
      let name = '';
      let unit = '';
      let price = 0;
      let url = '';

      // Si es un enlace directo
      if ($el.is('a')) {
        const href = $el.attr('href');
        const text = $el.text().trim();
        
        if (href && text) {
          url = href.startsWith('http') ? href : `https://www.insucons.com${href}`;
          name = text;
          code = href.split('/').pop() || '';
        }
      } else {
        // Si es una fila de tabla
        const cells = $el.find('td');
        if (cells.length >= 3) {
          code = cells.eq(0).text().trim();
          name = cells.eq(1).text().trim();
          unit = cells.eq(2).text().trim();
          
          const priceText = cells.eq(3).text().trim();
          price = parseFloat(priceText.replace(/[^\d.,]/g, '').replace(',', '.')) || 0;
          
          const link = cells.find('a').first();
          const href = link.attr('href');
          if (href) {
            url = href.startsWith('http') ? href : `https://www.insucons.com${href}`;
          }
        }
      }

      if (code && name) {
        apus.push({
          code,
          name,
          unit,
          price,
          url
        });
      }
    });

    console.log(`Encontrados ${apus.length} APUs en el grupo`);
    return apus;
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
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      }
    });

    const $ = cheerio.load(response.data);
    
    // Extraer información básica
    const code = $('h1, .apu-code').first().text().trim();
    const name = $('h2, .apu-name').first().text().trim();
    const unit = $('.unit, .unidad').first().text().trim();
    
    const priceText = $('.total-price, .precio-total').first().text().trim();
    const totalPrice = parseFloat(priceText.replace(/[^\d.,]/g, '').replace(',', '.')) || 0;

    const materials: APUComposition[] = [];
    const labor: APUComposition[] = [];
    const equipment: APUComposition[] = [];

    // Buscar tablas de composición
    $('table').each((_, table) => {
      const $table = $(table);
      const tableText = $table.text().toLowerCase();
      
      let type: 'material' | 'labor' | 'equipment' = 'material';
      
      if (tableText.includes('mano de obra') || tableText.includes('labor')) {
        type = 'labor';
      } else if (tableText.includes('equipo') || tableText.includes('maquinaria')) {
        type = 'equipment';
      }

      $table.find('tr').each((_, row) => {
        const cells = $(row).find('td');
        if (cells.length >= 4) {
          const description = cells.eq(0).text().trim();
          const unit = cells.eq(1).text().trim();
          const quantity = parseFloat(cells.eq(2).text().trim()) || 0;
          const unitPrice = parseFloat(cells.eq(3).text().replace(/[^\d.,]/g, '').replace(',', '.')) || 0;
          const totalPrice = quantity * unitPrice;

          if (description && quantity > 0) {
            const composition: APUComposition = {
              description,
              unit,
              quantity,
              unitPrice,
              totalPrice,
              type
            };

            switch (type) {
              case 'material':
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
      });
    });

    // Buscar costos indirectos
    const indirectCosts = {
      equipment: 0,
      administrative: 0,
      utility: 0,
      tax: 0
    };

    $('.indirect-costs, .costos-indirectos').each((_, element) => {
      const text = $(element).text();
      
      const equipmentMatch = text.match(/equipo[:\s]*(\d+(?:\.\d+)?)/i);
      if (equipmentMatch) {
        indirectCosts.equipment = parseFloat(equipmentMatch[1]);
      }
      
      const adminMatch = text.match(/administrativo[:\s]*(\d+(?:\.\d+)?)/i);
      if (adminMatch) {
        indirectCosts.administrative = parseFloat(adminMatch[1]);
      }
      
      const utilityMatch = text.match(/utilidad[:\s]*(\d+(?:\.\d+)?)/i);
      if (utilityMatch) {
        indirectCosts.utility = parseFloat(utilityMatch[1]);
      }
      
      const taxMatch = text.match(/impuesto[:\s]*(\d+(?:\.\d+)?)/i);
      if (taxMatch) {
        indirectCosts.tax = parseFloat(taxMatch[1]);
      }
    });

    return {
      code,
      name,
      unit,
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