import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Eye, Wrench, Users, Package } from "lucide-react";
import { formatCurrency } from "@/lib/utils";
import type { ActivityComposition } from "@shared/schema";

interface ActivityDetailDialogProps {
  activityId: number;
  activityName: string;
  unitPrice: string;
  children: React.ReactNode;
}

export default function ActivityDetailDialog({ 
  activityId, 
  activityName, 
  unitPrice,
  children 
}: ActivityDetailDialogProps) {
  const [open, setOpen] = useState(false);

  const { data: compositions, isLoading } = useQuery<ActivityComposition[]>({
    queryKey: ["/api/activities", activityId, "compositions"],
    queryFn: async () => {
      const response = await fetch(`/api/activities/${activityId}/compositions`);
      if (!response.ok) throw new Error('Failed to fetch compositions');
      return response.json();
    },
    enabled: open && activityId > 0,
  });

  const { data: apuCalculation, isLoading: calculationLoading } = useQuery({
    queryKey: ["/api/activities", activityId, "apu-calculation"],
    queryFn: async () => {
      const response = await fetch(`/api/activities/${activityId}/apu-calculation`);
      if (!response.ok) throw new Error('Failed to fetch APU calculation');
      return response.json();
    },
    enabled: open && activityId > 0,
  });

  const priceValue = parseFloat(unitPrice || "0");

  // Group compositions by type
  const materials = compositions?.filter(c => c.type === 'material') || [];
  const labor = compositions?.filter(c => c.type === 'labor') || [];
  const equipment = compositions?.filter(c => c.type === 'equipment') || [];

  const materialsTotal = materials.reduce((sum, item) => sum + (parseFloat(item.quantity) * parseFloat(item.unitCost)), 0);
  const laborTotal = labor.reduce((sum, item) => sum + (parseFloat(item.quantity) * parseFloat(item.unitCost)), 0);
  const equipmentTotal = equipment.reduce((sum, item) => sum + (parseFloat(item.quantity) * parseFloat(item.unitCost)), 0);
  const directTotal = materialsTotal + laborTotal + equipmentTotal;

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        {children}
      </DialogTrigger>
      <DialogContent className="max-w-4xl max-h-[80vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="text-lg font-semibold">
            Análisis de Precios Unitarios (APU)
          </DialogTitle>
          <DialogDescription className="text-sm text-gray-600">
            Desglose detallado de materiales, mano de obra y costos para: {activityName}
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-6">
          {/* APU Calculation Summary */}
          {apuCalculation && !calculationLoading && (
            <Card>
              <CardHeader>
                <CardTitle className="text-base flex items-center gap-2">
                  <Package className="w-4 h-4" />
                  Análisis de Precios Unitarios
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3 text-sm">
                  {/* 1. Materiales */}
                  <div className="border-b pb-2">
                    <div className="flex justify-between font-medium">
                      <span>1. MATERIALES</span>
                      <span>{formatCurrency(apuCalculation.materialsTotal)}</span>
                    </div>
                  </div>
                  
                  {/* 2. Mano de Obra */}
                  <div className="border-b pb-2">
                    <div className="flex justify-between font-medium mb-1">
                      <span>2. MANO DE OBRA</span>
                      <span></span>
                    </div>
                    <div className="ml-4 space-y-1 text-xs">
                      <div className="flex justify-between">
                        <span>Total mano de obra</span>
                        <span>{formatCurrency(apuCalculation.laborTotal)}</span>
                      </div>
                      <div className="flex justify-between">
                        <span>Cargas sociales (55.00%)</span>
                        <span>{formatCurrency(apuCalculation.breakdown.laborCharges)}</span>
                      </div>
                      <div className="flex justify-between">
                        <span>I.V.A. de M.O. y cargas sociales (14.94%)</span>
                        <span>{formatCurrency(apuCalculation.breakdown.laborIVA)}</span>
                      </div>
                      <div className="flex justify-between font-medium text-sm">
                        <span>Total mano de obra</span>
                        <span>{formatCurrency(apuCalculation.laborWithCharges + apuCalculation.breakdown.laborIVA)}</span>
                      </div>
                    </div>
                  </div>
                  
                  {/* 3. Equipos */}
                  <div className="border-b pb-2">
                    <div className="flex justify-between font-medium mb-1">
                      <span>3. EQUIPO, MAQUINARIA Y HERRAMIENTAS</span>
                      <span></span>
                    </div>
                    <div className="ml-4 space-y-1 text-xs">
                      <div className="flex justify-between">
                        <span>Total equipos</span>
                        <span>{formatCurrency(apuCalculation.equipmentTotal)}</span>
                      </div>
                      <div className="flex justify-between">
                        <span>Herramientas (5.00%)</span>
                        <span>{formatCurrency(apuCalculation.breakdown.tools)}</span>
                      </div>
                      <div className="flex justify-between font-medium text-sm">
                        <span>Total equipo, maquinaria y herramientas</span>
                        <span>{formatCurrency(apuCalculation.equipmentWithTools)}</span>
                      </div>
                    </div>
                  </div>
                  
                  {/* 4. Gastos Generales */}
                  <div className="border-b pb-2">
                    <div className="flex justify-between font-medium">
                      <span>4. GASTOS GENERALES Y ADMINISTRATIVOS</span>
                      <span></span>
                    </div>
                    <div className="ml-4 text-xs">
                      <div className="flex justify-between font-medium">
                        <span>Gastos generales (8.00%)</span>
                        <span>{formatCurrency(apuCalculation.administrativeCost)}</span>
                      </div>
                    </div>
                  </div>
                  
                  {/* 5. Utilidad */}
                  <div className="border-b pb-2">
                    <div className="flex justify-between font-medium">
                      <span>5. UTILIDAD</span>
                      <span></span>
                    </div>
                    <div className="ml-4 text-xs">
                      <div className="flex justify-between font-medium">
                        <span>Utilidad (15.00%)</span>
                        <span>{formatCurrency(apuCalculation.utilityCost)}</span>
                      </div>
                    </div>
                  </div>
                  
                  {/* 6. Impuestos */}
                  <div className="border-b pb-2">
                    <div className="flex justify-between font-medium">
                      <span>6. IMPUESTOS</span>
                      <span></span>
                    </div>
                    <div className="ml-4 text-xs">
                      <div className="flex justify-between font-medium">
                        <span>IT (3.09%)</span>
                        <span>{formatCurrency(apuCalculation.taxCost)}</span>
                      </div>
                    </div>
                  </div>
                  
                  {/* Total Final */}
                  <div className="bg-blue-50 p-3 rounded-lg mt-3">
                    <div className="flex justify-between text-base font-bold">
                      <span>Total Precio Unitario</span>
                      <span>{formatCurrency(apuCalculation.totalUnitPrice)}</span>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          )}

          {isLoading ? (
            <div className="space-y-4">
              <Skeleton className="h-8 w-48" />
              <Skeleton className="h-32 w-full" />
            </div>
          ) : compositions?.length ? (
            <div className="space-y-6">
              {/* Materials */}
              {materials.length > 0 && (
                <Card>
                  <CardHeader>
                    <CardTitle className="text-base flex items-center gap-2">
                      <Package className="w-4 h-4 text-blue-600" />
                      Materiales
                      <Badge variant="outline">{materials.length} items</Badge>
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <Table>
                      <TableHeader>
                        <TableRow>
                          <TableHead>Descripción</TableHead>
                          <TableHead>Unidad</TableHead>
                          <TableHead className="text-right">Cantidad</TableHead>
                          <TableHead className="text-right">Precio Unit.</TableHead>
                          <TableHead className="text-right">Total</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {materials.map((item, index) => (
                          <TableRow key={index}>
                            <TableCell className="font-medium">{item.description}</TableCell>
                            <TableCell>{item.unit}</TableCell>
                            <TableCell className="text-right">{parseFloat(item.quantity).toFixed(3)}</TableCell>
                            <TableCell className="text-right">{formatCurrency(parseFloat(item.unitCost))}</TableCell>
                            <TableCell className="text-right font-medium">
                              {formatCurrency(parseFloat(item.quantity) * parseFloat(item.unitCost))}
                            </TableCell>
                          </TableRow>
                        ))}
                        <TableRow className="border-t-2">
                          <TableCell colSpan={4} className="font-semibold">Subtotal Materiales:</TableCell>
                          <TableCell className="text-right font-semibold text-blue-600">
                            {formatCurrency(materialsTotal)}
                          </TableCell>
                        </TableRow>
                      </TableBody>
                    </Table>
                  </CardContent>
                </Card>
              )}

              {/* Labor */}
              {labor.length > 0 && (
                <Card>
                  <CardHeader>
                    <CardTitle className="text-base flex items-center gap-2">
                      <Users className="w-4 h-4 text-green-600" />
                      Mano de Obra
                      <Badge variant="outline">{labor.length} items</Badge>
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <Table>
                      <TableHeader>
                        <TableRow>
                          <TableHead>Descripción</TableHead>
                          <TableHead>Unidad</TableHead>
                          <TableHead className="text-right">Cantidad</TableHead>
                          <TableHead className="text-right">Precio Unit.</TableHead>
                          <TableHead className="text-right">Total</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {labor.map((item, index) => (
                          <TableRow key={index}>
                            <TableCell className="font-medium">{item.description}</TableCell>
                            <TableCell>{item.unit}</TableCell>
                            <TableCell className="text-right">{parseFloat(item.quantity).toFixed(3)}</TableCell>
                            <TableCell className="text-right">{formatCurrency(parseFloat(item.unitCost))}</TableCell>
                            <TableCell className="text-right font-medium">
                              {formatCurrency(parseFloat(item.quantity) * parseFloat(item.unitCost))}
                            </TableCell>
                          </TableRow>
                        ))}
                        <TableRow className="border-t-2">
                          <TableCell colSpan={4} className="font-semibold">Subtotal Mano de Obra:</TableCell>
                          <TableCell className="text-right font-semibold text-green-600">
                            {formatCurrency(laborTotal)}
                          </TableCell>
                        </TableRow>
                      </TableBody>
                    </Table>
                  </CardContent>
                </Card>
              )}

              {/* Equipment */}
              {equipment.length > 0 && (
                <Card>
                  <CardHeader>
                    <CardTitle className="text-base flex items-center gap-2">
                      <Wrench className="w-4 h-4 text-orange-600" />
                      Equipos y Herramientas
                      <Badge variant="outline">{equipment.length} items</Badge>
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <Table>
                      <TableHeader>
                        <TableRow>
                          <TableHead>Descripción</TableHead>
                          <TableHead>Unidad</TableHead>
                          <TableHead className="text-right">Cantidad</TableHead>
                          <TableHead className="text-right">Precio Unit.</TableHead>
                          <TableHead className="text-right">Total</TableHead>
                        </TableRow>
                      </TableHeader>
                      <TableBody>
                        {equipment.map((item, index) => (
                          <TableRow key={index}>
                            <TableCell className="font-medium">{item.description}</TableCell>
                            <TableCell>{item.unit}</TableCell>
                            <TableCell className="text-right">{parseFloat(item.quantity).toFixed(3)}</TableCell>
                            <TableCell className="text-right">{formatCurrency(parseFloat(item.unitCost))}</TableCell>
                            <TableCell className="text-right font-medium">
                              {formatCurrency(parseFloat(item.quantity) * parseFloat(item.unitCost))}
                            </TableCell>
                          </TableRow>
                        ))}
                        <TableRow className="border-t-2">
                          <TableCell colSpan={4} className="font-semibold">Subtotal Equipos:</TableCell>
                          <TableCell className="text-right font-semibold text-orange-600">
                            {formatCurrency(equipmentTotal)}
                          </TableCell>
                        </TableRow>
                      </TableBody>
                    </Table>
                  </CardContent>
                </Card>
              )}

              {/* Total Summary */}
              <Card className="border-2 border-primary/20">
                <CardContent className="pt-6">
                  <div className="space-y-2">
                    <div className="flex justify-between text-sm">
                      <span>Costo Directo:</span>
                      <span className="font-medium">{formatCurrency(directTotal)}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span>Costos Indirectos e Impuestos:</span>
                      <span className="font-medium">{formatCurrency(priceValue - directTotal)}</span>
                    </div>
                    <div className="border-t pt-2">
                      <div className="flex justify-between text-lg font-semibold">
                        <span>Precio Unitario Total:</span>
                        <span className="text-primary">{formatCurrency(priceValue)}</span>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          ) : (
            <Card>
              <CardContent className="py-8 text-center text-gray-500">
                <Package className="w-12 h-12 mx-auto mb-4 text-gray-300" />
                <p>No hay composiciones disponibles para esta actividad</p>
                <p className="text-sm">Las composiciones se importan desde los APU de insucons.com</p>
              </CardContent>
            </Card>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}