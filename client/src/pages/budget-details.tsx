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
      // Importar jsPDF y autoTable
      const [{ default: jsPDF }, autoTable] = await Promise.all([
        import('jspdf'),
        import('jspdf-autotable')
      ]);

      const doc = new jsPDF();
      
      // Configuración
      const pageWidth = doc.internal.pageSize.getWidth();
      const margin = 20;
      let yPosition = 20;

      // Título
      doc.setFontSize(18);
      doc.text('PRESUPUESTO DE CONSTRUCCION', pageWidth / 2, yPosition, { align: 'center' });
      yPosition += 20;

      // Información del proyecto
      doc.setFontSize(12);
      const projectName = budget.project?.name || 'Sin nombre';
      const clientName = budget.project?.client || 'No especificado';
      const location = budget.project?.location || 'No especificada';
      
      doc.text(`Proyecto: ${projectName}`, margin, yPosition);
      yPosition += 8;
      doc.text(`Cliente: ${clientName}`, margin, yPosition);
      yPosition += 8;
      doc.text(`Ubicacion: ${location}`, margin, yPosition);
      yPosition += 8;
      doc.text(`Fecha: ${new Date().toLocaleDateString()}`, margin, yPosition);
      yPosition += 15;

      // Crear datos para la tabla
      const tableData = budgetItems.map((item, index) => {
        const quantity = typeof item.quantity === 'string' ? parseFloat(item.quantity) : item.quantity;
        const unitPrice = typeof item.unitPrice === 'string' ? parseFloat(item.unitPrice) : item.unitPrice;
        const subtotal = typeof item.subtotal === 'string' ? parseFloat(item.subtotal) : item.subtotal;
        
        return [
          (index + 1).toString(),
          item.activity?.name?.substring(0, 50) || 'Sin descripcion',
          item.activity?.unit || 'und',
          quantity.toString(),
          `Bs ${unitPrice.toFixed(2)}`,
          `Bs ${subtotal.toFixed(2)}`
        ];
      });

      // Usar autoTable para crear la tabla
      (doc as any).autoTable({
        head: [['#', 'Descripción', 'Unidad', 'Cantidad', 'P. Unitario', 'Subtotal']],
        body: tableData,
        startY: yPosition,
        margin: { left: margin, right: margin },
        styles: {
          fontSize: 9,
          cellPadding: 3
        },
        headStyles: {
          fillColor: [66, 139, 202],
          textColor: 255,
          fontStyle: 'bold'
        },
        alternateRowStyles: {
          fillColor: [245, 245, 245]
        }
      });

      // Obtener la posición Y después de la tabla
      const finalY = (doc as any).lastAutoTable.finalY + 10;

      // Total
      const totalAmount = typeof budget.total === 'string' ? parseFloat(budget.total) : budget.total;
      doc.setFontSize(14);
      doc.text(`TOTAL GENERAL: Bs ${totalAmount.toFixed(2)}`, pageWidth - margin, finalY, { align: 'right' });

      // Pie de página
      doc.setFontSize(8);
      doc.text('Generado por MICA - Sistema de Gestion de Presupuestos', pageWidth / 2, finalY + 20, { align: 'center' });

      // Descargar
      const filename = `Presupuesto_${budget.project?.name?.replace(/[^a-zA-Z0-9]/g, '_') || 'proyecto'}_${budget.id}.pdf`;
      doc.save(filename);
      
    } catch (error) {
      console.error('Error generando PDF:', error);
      alert('Error al generar el PDF. Verifica que todos los datos estén disponibles.');
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