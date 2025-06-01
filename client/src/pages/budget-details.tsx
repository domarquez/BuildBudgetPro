import { useParams } from "wouter";
import { useQuery } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { ArrowLeft, Calendar, MapPin, User, FileText, Calculator, Download } from "lucide-react";
import { formatCurrency, formatDate } from "@/lib/utils";
import type { BudgetWithProject, BudgetItemWithActivity } from "@shared/schema";

export default function BudgetDetails() {
  const { id } = useParams();
  const budgetId = Number(id);

  const handleGeneratePDF = async () => {
    if (!budget || !budgetItems) {
      alert('No hay datos disponibles para generar el PDF');
      return;
    }

    try {
      const { default: jsPDF } = await import('jspdf');
      const doc = new jsPDF();
      
      const pageWidth = doc.internal.pageSize.getWidth();
      const margin = 20;
      let yPosition = 20;

      // Encabezado empresarial
      doc.setFontSize(18);
      doc.text('MICA', margin, yPosition);
      doc.setFontSize(10);
      doc.text('Sistema Integral de Construccion y Arquitectura', margin, yPosition + 8);
      doc.text('La Paz, Bolivia | contacto@mica.bo | +591 70000000', margin, yPosition + 16);
      yPosition += 30;

      // Título del documento
      doc.setFontSize(16);
      doc.text('PRESUPUESTO DETALLADO DE CONSTRUCCION', pageWidth / 2, yPosition, { align: 'center' });
      yPosition += 20;

      // Información del proyecto
      doc.setFontSize(11);
      doc.text(`PROYECTO: ${budget.project?.name || 'Sin nombre'}`, margin, yPosition);
      yPosition += 8;
      doc.text(`CLIENTE: ${budget.project?.client || 'No especificado'}`, margin, yPosition);
      yPosition += 8;
      doc.text(`UBICACION: ${budget.project?.location || 'No especificada'}`, margin, yPosition);
      yPosition += 8;
      doc.text(`FECHA DE EMISION: ${new Date().toLocaleDateString('es-BO')}`, margin, yPosition);
      yPosition += 8;
      doc.text(`PRESUPUESTO #${budget.id}`, margin, yPosition);
      yPosition += 15;

      // Encabezado de tabla principal
      doc.setFontSize(9);
      doc.text('ITEM', margin, yPosition);
      doc.text('DESCRIPCION DE LA ACTIVIDAD', margin + 15, yPosition);
      doc.text('UND', margin + 110, yPosition);
      doc.text('CANT.', margin + 125, yPosition);
      doc.text('P.UNIT. (Bs)', margin + 145, yPosition);
      doc.text('TOTAL (Bs)', margin + 170, yPosition);
      yPosition += 5;

      // Línea separadora principal
      doc.line(margin, yPosition, pageWidth - margin, yPosition);
      yPosition += 8;

      // Items del presupuesto con detalles
      let totalGeneral = 0;
      
      for (let index = 0; index < budgetItems.length; index++) {
        const item = budgetItems[index];
        
        if (yPosition > 230) {
          doc.addPage();
          yPosition = 30;
          // Repetir encabezado en nueva página
          doc.setFontSize(9);
          doc.text('ITEM', margin, yPosition);
          doc.text('DESCRIPCION DE LA ACTIVIDAD', margin + 15, yPosition);
          doc.text('UND', margin + 110, yPosition);
          doc.text('CANT.', margin + 125, yPosition);
          doc.text('P.UNIT. (Bs)', margin + 145, yPosition);
          doc.text('TOTAL (Bs)', margin + 170, yPosition);
          yPosition += 5;
          doc.line(margin, yPosition, pageWidth - margin, yPosition);
          yPosition += 8;
        }

        const quantity = typeof item.quantity === 'string' ? parseFloat(item.quantity) : item.quantity;
        const unitPrice = typeof item.unitPrice === 'string' ? parseFloat(item.unitPrice) : item.unitPrice;
        const subtotal = typeof item.subtotal === 'string' ? parseFloat(item.subtotal) : item.subtotal;
        totalGeneral += subtotal;

        // Actividad principal
        doc.setFontSize(8);
        doc.text(`${(index + 1).toString().padStart(2, '0')}`, margin, yPosition);
        
        // Limpiar nombre de la actividad
        let activityName = item.activity?.name || 'Sin descripcion';
        activityName = activityName.replace(/^ANÁLISIS DE PRECIOS UNITARIOS \(APU\) DE:\s*/i, '');
        activityName = activityName.replace(/^APU DE:\s*/i, '');
        
        if (activityName.length > 40) {
          activityName = activityName.substring(0, 40) + '...';
        }
        
        doc.text(activityName, margin + 15, yPosition);
        doc.text(item.activity?.unit || 'und', margin + 110, yPosition);
        doc.text(quantity.toFixed(2), margin + 125, yPosition);
        doc.text(unitPrice.toFixed(2), margin + 145, yPosition);
        doc.text(subtotal.toFixed(2), margin + 170, yPosition);
        yPosition += 12;

        // Obtener composición de la actividad
        try {
          const response = await fetch(`/api/activities/${item.activity?.id}/composition`);
          if (response.ok) {
            const composition = await response.json();
            
            doc.setFontSize(7);
            doc.text('    COMPOSICION DE PRECIO UNITARIO:', margin + 20, yPosition);
            yPosition += 5;
            
            // Mostrar materiales
            if (composition.materials && composition.materials.length > 0) {
              doc.text('    • MATERIALES:', margin + 25, yPosition);
              yPosition += 4;
              
              composition.materials.forEach((material: any) => {
                // Verificar si necesitamos nueva página
                if (yPosition > 270) {
                  doc.addPage();
                  yPosition = 30;
                }
                
                const materialCost = material.quantity * material.unitPrice;
                const matDesc = material.description.length > 40 ? 
                  material.description.substring(0, 40) + '...' : material.description;
                doc.text(`      - ${matDesc}`, margin + 30, yPosition);
                doc.text(`${material.quantity} ${material.unit}`, margin + 100, yPosition);
                doc.text(`Bs ${materialCost.toFixed(2)}`, margin + 145, yPosition);
                yPosition += 4;
              });
            }
            
            // Mostrar mano de obra
            if (composition.labor && composition.labor.length > 0) {
              yPosition += 2;
              doc.text('    • MANO DE OBRA:', margin + 25, yPosition);
              yPosition += 4;
              
              composition.labor.forEach((labor: any) => {
                // Verificar si necesitamos nueva página
                if (yPosition > 270) {
                  doc.addPage();
                  yPosition = 30;
                }
                
                const laborCost = labor.quantity * labor.unitPrice;
                const labDesc = labor.description.length > 40 ? 
                  labor.description.substring(0, 40) + '...' : labor.description;
                doc.text(`      - ${labDesc}`, margin + 30, yPosition);
                doc.text(`${labor.quantity} ${labor.unit}`, margin + 100, yPosition);
                doc.text(`Bs ${laborCost.toFixed(2)}`, margin + 145, yPosition);
                yPosition += 4;
              });
            }
            
            // Mostrar herramientas
            if (composition.tools && composition.tools.length > 0) {
              yPosition += 2;
              doc.text('    • HERRAMIENTAS Y EQUIPOS:', margin + 25, yPosition);
              yPosition += 4;
              
              composition.tools.forEach((tool: any) => {
                // Verificar si necesitamos nueva página
                if (yPosition > 270) {
                  doc.addPage();
                  yPosition = 30;
                }
                
                const toolCost = tool.quantity * tool.unitPrice;
                const toolDesc = tool.description.length > 40 ? 
                  tool.description.substring(0, 40) + '...' : tool.description;
                doc.text(`      - ${toolDesc}`, margin + 30, yPosition);
                doc.text(`${tool.quantity} ${tool.unit}`, margin + 100, yPosition);
                doc.text(`Bs ${toolCost.toFixed(2)}`, margin + 145, yPosition);
                yPosition += 4;
              });
            }
          } else {
            // Análisis estimado si no hay composición
            doc.setFontSize(7);
            doc.text('    ANALISIS ESTIMADO:', margin + 20, yPosition);
            yPosition += 4;
            doc.text('    • Materiales: 60%', margin + 25, yPosition);
            doc.text(`Bs ${(unitPrice * 0.6).toFixed(2)}`, margin + 145, yPosition);
            yPosition += 4;
            doc.text('    • Mano de obra: 25%', margin + 25, yPosition);
            doc.text(`Bs ${(unitPrice * 0.25).toFixed(2)}`, margin + 145, yPosition);
            yPosition += 4;
            doc.text('    • Equipos: 15%', margin + 25, yPosition);
            doc.text(`Bs ${(unitPrice * 0.15).toFixed(2)}`, margin + 145, yPosition);
            yPosition += 4;
          }
        } catch (error) {
          console.error('Error obteniendo composición:', error);
          // Análisis estimado en caso de error
          doc.setFontSize(7);
          doc.text('    ANALISIS ESTIMADO:', margin + 20, yPosition);
          yPosition += 4;
          doc.text('    • Materiales: 60%', margin + 25, yPosition);
          doc.text(`Bs ${(unitPrice * 0.6).toFixed(2)}`, margin + 145, yPosition);
          yPosition += 4;
          doc.text('    • Mano de obra: 25%', margin + 25, yPosition);
          doc.text(`Bs ${(unitPrice * 0.25).toFixed(2)}`, margin + 145, yPosition);
          yPosition += 4;
          doc.text('    • Equipos: 15%', margin + 25, yPosition);
          doc.text(`Bs ${(unitPrice * 0.15).toFixed(2)}`, margin + 145, yPosition);
          yPosition += 4;
        }
        
        yPosition += 4;
        // Línea separadora entre items
        doc.line(margin, yPosition, pageWidth - margin, yPosition);
        yPosition += 5;
      }

      // Resumen financiero
      yPosition += 10;
      doc.setFontSize(11);
      doc.text('RESUMEN FINANCIERO', margin, yPosition);
      yPosition += 10;

      doc.setFontSize(9);
      doc.text('Subtotal de actividades:', margin + 20, yPosition);
      doc.text(`Bs ${totalGeneral.toFixed(2)}`, margin + 140, yPosition);
      yPosition += 6;

      // Calcular IVA
      const iva = totalGeneral * 0.13;
      const totalConIva = totalGeneral + iva;

      doc.text('IVA (13%):', margin + 20, yPosition);
      doc.text(`Bs ${iva.toFixed(2)}`, margin + 140, yPosition);
      yPosition += 8;

      // Línea final
      doc.line(margin + 120, yPosition, pageWidth - margin, yPosition);
      yPosition += 5;

      doc.setFontSize(12);
      doc.text('TOTAL GENERAL:', margin + 20, yPosition);
      doc.text(`Bs ${totalConIva.toFixed(2)}`, margin + 140, yPosition);
      yPosition += 15;

      // Información adicional
      doc.setFontSize(8);
      doc.text('* Los precios incluyen materiales, mano de obra y gastos generales', margin, yPosition);
      yPosition += 5;
      doc.text('* Validez de la oferta: 30 dias calendario', margin, yPosition);
      yPosition += 5;
      doc.text('* Moneda: Bolivianos (Bs)', margin, yPosition);
      yPosition += 10;

      // Pie de página profesional
      doc.setFontSize(7);
      doc.text('Este presupuesto ha sido elaborado con MICA - Sistema Integral de Construccion', pageWidth / 2, yPosition, { align: 'center' });
      doc.text('www.mica.bo | contacto@mica.bo | La Paz, Bolivia', pageWidth / 2, yPosition + 5, { align: 'center' });

      // Descargar
      const projectName = budget.project?.name?.replace(/[^a-zA-Z0-9\s]/g, '') || 'proyecto';
      doc.save(`Presupuesto_${projectName}_${budget.id}.pdf`);
      
    } catch (error) {
      console.error('Error generando PDF:', error);
      alert('Error al generar el PDF. Intenta de nuevo.');
    }
  };

  const { data: budget, isLoading: budgetLoading } = useQuery<BudgetWithProject>({
    queryKey: [`/api/budgets/${budgetId}`],
    enabled: !!budgetId,
  });

  const { data: budgetItems, isLoading: itemsLoading } = useQuery<BudgetItemWithActivity[]>({
    queryKey: [`/api/budgets/${budgetId}/items`],
    enabled: !!budgetId,
  });

  if (budgetLoading) {
    return (
      <div className="space-y-6">
        <div className="flex items-center space-x-4">
          <Skeleton className="h-10 w-24" />
          <Skeleton className="h-8 w-64" />
        </div>
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <Skeleton className="h-32 lg:col-span-2" />
          <Skeleton className="h-32" />
        </div>
        <Skeleton className="h-64" />
      </div>
    );
  }

  if (!budget) {
    return (
      <div className="text-center py-12">
        <FileText className="w-16 h-16 text-gray-400 mx-auto mb-4" />
        <h2 className="text-2xl font-semibold text-gray-900 mb-2">
          Presupuesto no encontrado
        </h2>
        <p className="text-gray-600 mb-6">
          El presupuesto que buscas no existe o no tienes permisos para verlo.
        </p>
        <Button onClick={() => window.history.back()}>
          <ArrowLeft className="w-4 h-4 mr-2" />
          Volver
        </Button>
      </div>
    );
  }

  const totalItems = budgetItems?.reduce((sum, item) => sum + Number(item.subtotal), 0) || 0;

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-4">
          <Button
            variant="outline"
            onClick={() => window.history.back()}
            className="flex items-center space-x-2"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Volver</span>
          </Button>
          <div>
            <h1 className="text-2xl font-bold text-on-surface">
              {budget.project.name}
            </h1>
            <p className="text-gray-600">
              {budget.phase ? budget.phase.name : "Multifase"} • Presupuesto #{budget.id}
            </p>
          </div>
        </div>
        <div className="flex items-center space-x-2">
          <Button
            onClick={handleGeneratePDF}
            className="flex items-center space-x-2 bg-red-600 hover:bg-red-700"
          >
            <Download className="w-4 h-4" />
            <span>Descargar PDF</span>
          </Button>
          <Badge
            variant={budget.status === 'active' ? 'default' : 
                    budget.status === 'completed' ? 'secondary' : 'outline'}
            className="text-sm"
          >
            {budget.status === 'active' ? 'Activo' : 
             budget.status === 'completed' ? 'Completado' : 'Borrador'}
          </Badge>
        </div>
      </div>

      {/* Project Info */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <Card className="lg:col-span-2 shadow-material">
          <CardHeader>
            <CardTitle className="text-lg">Información del Proyecto</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="flex items-center space-x-3">
                <User className="w-5 h-5 text-gray-500" />
                <div>
                  <p className="text-sm text-gray-600">Cliente</p>
                  <p className="font-medium">{budget.project.client || "No especificado"}</p>
                </div>
              </div>
              <div className="flex items-center space-x-3">
                <MapPin className="w-5 h-5 text-gray-500" />
                <div>
                  <p className="text-sm text-gray-600">Ubicación</p>
                  <p className="font-medium">{budget.project.location || "No especificado"}</p>
                </div>
              </div>
              <div className="flex items-center space-x-3">
                <Calendar className="w-5 h-5 text-gray-500" />
                <div>
                  <p className="text-sm text-gray-600">Fecha de Inicio</p>
                  <p className="font-medium">
                    {budget.project.startDate ? formatDate(budget.project.startDate) : "No definida"}
                  </p>
                </div>
              </div>
              <div className="flex items-center space-x-3">
                <FileText className="w-5 h-5 text-gray-500" />
                <div>
                  <p className="text-sm text-gray-600">Estado</p>
                  <p className="font-medium capitalize">{budget.project.status}</p>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-material">
          <CardHeader>
            <CardTitle className="text-lg">Resumen Financiero</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <p className="text-sm text-gray-600">Total del Presupuesto</p>
              <p className="text-2xl font-bold text-primary">
                {formatCurrency(budget.total)}
              </p>
            </div>
            <div>
              <p className="text-sm text-gray-600">Items Calculados</p>
              <p className="text-xl font-semibold text-on-surface">
                {formatCurrency(totalItems)}
              </p>
            </div>
            <div>
              <p className="text-sm text-gray-600">Fase de Construcción</p>
              <p className="font-medium">{budget.phase ? budget.phase.name : "Multifase"}</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Budget Items */}
      <Card className="shadow-material">
        <CardHeader>
          <CardTitle className="text-lg flex items-center space-x-2">
            <Calculator className="w-5 h-5" />
            <span>Detalles del Presupuesto</span>
          </CardTitle>
        </CardHeader>
        <CardContent>
          {itemsLoading ? (
            <div className="space-y-4">
              {Array.from({ length: 3 }).map((_, i) => (
                <div key={i} className="flex items-center justify-between p-4 border rounded-lg">
                  <div className="space-y-2">
                    <Skeleton className="h-4 w-48" />
                    <Skeleton className="h-3 w-32" />
                  </div>
                  <div className="text-right space-y-2">
                    <Skeleton className="h-4 w-24" />
                    <Skeleton className="h-3 w-16" />
                  </div>
                </div>
              ))}
            </div>
          ) : budgetItems && budgetItems.length > 0 ? (
            <div className="space-y-4">
              {budgetItems.map((item) => (
                <div key={item.id} className="flex items-center justify-between p-4 border rounded-lg hover:bg-gray-50">
                  <div>
                    <p className="font-medium text-on-surface">
                      {item.activity.name}
                    </p>
                    <p className="text-sm text-gray-600">
                      {item.activity.phase.name} • Cantidad: {item.quantity} {item.activity.unit}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="font-semibold text-on-surface">
                      {formatCurrency(Number(item.subtotal))}
                    </p>
                    <p className="text-sm text-gray-600">
                      {formatCurrency(Number(item.unitPrice))} por {item.activity.unit}
                    </p>
                  </div>
                </div>
              ))}
              <div className="border-t pt-4">
                <div className="flex justify-between items-center">
                  <p className="text-lg font-semibold">Total:</p>
                  <p className="text-xl font-bold text-primary">
                    {formatCurrency(totalItems)}
                  </p>
                </div>
              </div>
            </div>
          ) : (
            <div className="text-center py-8">
              <Calculator className="w-12 h-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600">
                Este presupuesto aún no tiene items calculados.
              </p>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}