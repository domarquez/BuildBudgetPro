import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';

export interface BudgetPDFData {
  budget: {
    id: number;
    total: number;
    status: string;
    createdAt: string;
    project: {
      name: string;
      description?: string;
      location?: string;
      clientName?: string;
    };
  };
  items: Array<{
    id: number;
    quantity: number;
    unitPrice: number;
    subtotal: number;
    activity: {
      name: string;
      unit: string;
      phase: {
        name: string;
      };
    };
  }>;
  creator: {
    name: string;
    company?: string;
    email?: string;
    phone?: string;
  };
}

export function generateBudgetPDF(data: BudgetPDFData): void {
  const doc = new jsPDF();
  const pageWidth = doc.internal.pageSize.width;
  
  // Configurar fuentes
  doc.setFont('helvetica');
  
  // CABECERA
  doc.setFontSize(20);
  doc.setTextColor(40, 40, 40);
  doc.text('PRESUPUESTO DE OBRA', pageWidth / 2, 25, { align: 'center' });
  
  // Información del proyecto
  doc.setFontSize(12);
  doc.setTextColor(60, 60, 60);
  
  let yPosition = 45;
  
  // Datos del proyecto
  doc.text('INFORMACIÓN DEL PROYECTO', 20, yPosition);
  yPosition += 10;
  
  doc.setFontSize(10);
  doc.text(`Proyecto: ${data.budget.project.name}`, 20, yPosition);
  yPosition += 6;
  
  if (data.budget.project.description) {
    doc.text(`Descripción: ${data.budget.project.description}`, 20, yPosition);
    yPosition += 6;
  }
  
  if (data.budget.project.location) {
    doc.text(`Ubicación: ${data.budget.project.location}`, 20, yPosition);
    yPosition += 6;
  }
  
  if (data.budget.project.clientName) {
    doc.text(`Cliente: ${data.budget.project.clientName}`, 20, yPosition);
    yPosition += 6;
  }
  
  doc.text(`Fecha: ${new Date(data.budget.createdAt).toLocaleDateString('es-BO')}`, 20, yPosition);
  doc.text(`Presupuesto N°: ${data.budget.id.toString().padStart(6, '0')}`, 120, yPosition);
  yPosition += 15;
  
  // Información del creador
  doc.setFontSize(12);
  doc.setTextColor(60, 60, 60);
  doc.text('ELABORADO POR', 20, yPosition);
  yPosition += 10;
  
  doc.setFontSize(10);
  doc.text(`${data.creator.name}`, 20, yPosition);
  yPosition += 6;
  
  if (data.creator.company) {
    doc.text(`Empresa: ${data.creator.company}`, 20, yPosition);
    yPosition += 6;
  }
  
  if (data.creator.email) {
    doc.text(`Email: ${data.creator.email}`, 20, yPosition);
    yPosition += 6;
  }
  
  if (data.creator.phone) {
    doc.text(`Teléfono: ${data.creator.phone}`, 20, yPosition);
    yPosition += 6;
  }
  
  yPosition += 10;
  
  // Agrupar items por fase
  const itemsByPhase = data.items.reduce((acc, item) => {
    const phaseName = item.activity.phase.name;
    if (!acc[phaseName]) {
      acc[phaseName] = [];
    }
    acc[phaseName].push(item);
    return acc;
  }, {} as Record<string, typeof data.items>);
  
  // DETALLE DE ACTIVIDADES POR FASE
  doc.setFontSize(14);
  doc.setTextColor(40, 40, 40);
  doc.text('ANÁLISIS DE PRECIOS UNITARIOS', 20, yPosition);
  yPosition += 15;
  
  let phaseTotal = 0;
  
  Object.entries(itemsByPhase).forEach(([phaseName, phaseItems]) => {
    // Título de la fase
    doc.setFontSize(12);
    doc.setTextColor(80, 80, 80);
    doc.text(phaseName.toUpperCase(), 20, yPosition);
    yPosition += 10;
    
    // Tabla de actividades de la fase
    const tableData = phaseItems.map(item => [
      item.activity.name,
      item.activity.unit,
      item.quantity.toFixed(2),
      `Bs ${item.unitPrice.toFixed(2)}`,
      `Bs ${item.subtotal.toFixed(2)}`
    ]);
    
    autoTable(doc, {
      head: [['Actividad', 'Unidad', 'Cantidad', 'P. Unitario', 'Subtotal']],
      body: tableData,
      startY: yPosition,
      theme: 'grid',
      headStyles: {
        fillColor: [70, 130, 180],
        textColor: 255,
        fontSize: 9,
        fontStyle: 'bold'
      },
      bodyStyles: {
        fontSize: 8,
        textColor: 50
      },
      columnStyles: {
        0: { cellWidth: 80 },
        1: { cellWidth: 20, halign: 'center' },
        2: { cellWidth: 25, halign: 'center' },
        3: { cellWidth: 30, halign: 'right' },
        4: { cellWidth: 35, halign: 'right' }
      },
      margin: { left: 20, right: 20 }
    });
    
    yPosition = (doc as any).lastAutoTable.finalY + 10;
    
    // Subtotal de la fase
    const phaseSubtotal = phaseItems.reduce((sum, item) => sum + item.subtotal, 0);
    phaseTotal += phaseSubtotal;
    
    doc.setFontSize(10);
    doc.setTextColor(60, 60, 60);
    doc.text(`Subtotal ${phaseName}: Bs ${phaseSubtotal.toFixed(2)}`, pageWidth - 70, yPosition, { align: 'right' });
    yPosition += 15;
    
    // Verificar si necesitamos nueva página
    if (yPosition > 250) {
      doc.addPage();
      yPosition = 30;
    }
  });
  
  // RESUMEN TOTAL
  yPosition += 10;
  doc.setFontSize(14);
  doc.setTextColor(40, 40, 40);
  doc.text('RESUMEN TOTAL', 20, yPosition);
  yPosition += 15;
  
  // Tabla resumen
  const summaryData = [
    ['Subtotal de Actividades', `Bs ${phaseTotal.toFixed(2)}`],
    ['Gastos Generales (10%)', `Bs ${(phaseTotal * 0.10).toFixed(2)}`],
    ['Utilidad (8%)', `Bs ${(phaseTotal * 0.08).toFixed(2)}`],
    ['IVA (13%)', `Bs ${(phaseTotal * 0.13).toFixed(2)}`]
  ];
  
  const finalTotal = phaseTotal * 1.31; // +10% gastos +8% utilidad +13% IVA
  
  autoTable(doc, {
    body: summaryData,
    startY: yPosition,
    theme: 'grid',
    bodyStyles: {
      fontSize: 10,
      textColor: 50
    },
    columnStyles: {
      0: { cellWidth: 120, fontStyle: 'bold' },
      1: { cellWidth: 60, halign: 'right', fontStyle: 'bold' }
    },
    margin: { left: 20, right: 20 }
  });
  
  yPosition = (doc as any).lastAutoTable.finalY + 10;
  
  // Total final
  doc.setFontSize(16);
  doc.setTextColor(200, 50, 50);
  doc.setFillColor(240, 240, 240);
  doc.rect(20, yPosition, pageWidth - 40, 15, 'F');
  doc.text(`TOTAL PRESUPUESTO: Bs ${finalTotal.toFixed(2)}`, pageWidth / 2, yPosition + 10, { align: 'center' });
  
  // Pie de página
  yPosition += 25;
  doc.setFontSize(8);
  doc.setTextColor(120, 120, 120);
  doc.text('Este presupuesto es válido por 30 días a partir de la fecha de emisión.', pageWidth / 2, yPosition, { align: 'center' });
  doc.text('Generado por MICA - Sistema de Presupuestos de Construcción', pageWidth / 2, yPosition + 8, { align: 'center' });
  
  // Descargar el PDF
  const fileName = `Presupuesto_${data.budget.id}_${data.budget.project.name.replace(/\s+/g, '_')}.pdf`;
  doc.save(fileName);
}

export function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('es-BO', {
    style: 'currency',
    currency: 'BOB',
    minimumFractionDigits: 2
  }).format(amount);
}