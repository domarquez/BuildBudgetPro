import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import { 
  ChevronDown, 
  ChevronRight, 
  Package, 
  Users, 
  Wrench, 
  Edit3, 
  Save, 
  X,
  Star,
  StarOff
} from "lucide-react";
import { formatCurrency } from "@/lib/utils";
import { useToast } from "@/hooks/use-toast";
import { apiRequest } from "@/lib/queryClient";

interface ActivityComposition {
  materials: Array<{
    description: string;
    unit: string;
    quantity: number;
    unitPrice: number;
    total: number;
  }>;
  labor: Array<{
    description: string;
    unit: string;
    quantity: number;
    unitPrice: number;
    total: number;
  }>;
  equipment: Array<{
    description: string;
    unit: string;
    quantity: number;
    unitPrice: number;
    total: number;
  }>;
}

interface ActivityBreakdownProps {
  activityId: number;
  activityName: string;
  quantity: number;
  unitPrice: number;
  subtotal: number;
}

export default function ActivityBreakdown({ 
  activityId, 
  activityName, 
  quantity, 
  unitPrice, 
  subtotal 
}: ActivityBreakdownProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [editingMaterial, setEditingMaterial] = useState<number | null>(null);
  const [tempPrice, setTempPrice] = useState<string>("");
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const { data: composition, isLoading } = useQuery<ActivityComposition>({
    queryKey: [`/api/activities/${activityId}/composition`],
    enabled: isOpen,
  });

  const savePriceMutation = useMutation({
    mutationFn: async ({ materialName, newPrice, unit }: { materialName: string; newPrice: number; unit: string }) => {
      return apiRequest("POST", "/api/user-material-prices", {
        materialName,
        price: newPrice,
        unit
      });
    },
    onSuccess: () => {
      toast({
        title: "Precio guardado",
        description: "El precio personalizado se ha guardado en tu lista",
      });
      setEditingMaterial(null);
      setTempPrice("");
      // Invalidate related queries
      queryClient.invalidateQueries({ queryKey: [`/api/activities/${activityId}/composition`] });
    },
    onError: (error) => {
      toast({
        title: "Error",
        description: "No se pudo guardar el precio personalizado",
        variant: "destructive",
      });
    },
  });

  const handleEditPrice = (index: number, currentPrice: number) => {
    setEditingMaterial(index);
    setTempPrice(currentPrice.toString());
  };

  const handleSavePrice = (materialName: string, unit: string) => {
    const newPrice = parseFloat(tempPrice);
    if (isNaN(newPrice) || newPrice <= 0) {
      toast({
        title: "Error",
        description: "El precio debe ser un número válido mayor a 0",
        variant: "destructive",
      });
      return;
    }

    savePriceMutation.mutate({ materialName, newPrice, unit });
  };

  const handleCancelEdit = () => {
    setEditingMaterial(null);
    setTempPrice("");
  };

  const calculateNewTotal = (originalQuantity: number, newPrice: number) => {
    return originalQuantity * newPrice;
  };

  return (
    <Card className="mb-4">
      <Collapsible open={isOpen} onOpenChange={setIsOpen}>
        <CollapsibleTrigger asChild>
          <CardHeader className="cursor-pointer hover:bg-gray-50 transition-colors">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                {isOpen ? <ChevronDown className="w-4 h-4" /> : <ChevronRight className="w-4 h-4" />}
                <CardTitle className="text-lg">{activityName}</CardTitle>
              </div>
              <div className="text-right">
                <div className="text-sm text-gray-600">
                  {quantity} unidades × {formatCurrency(unitPrice)}
                </div>
                <div className="text-lg font-bold text-primary">
                  {formatCurrency(subtotal)}
                </div>
              </div>
            </div>
          </CardHeader>
        </CollapsibleTrigger>

        <CollapsibleContent>
          <CardContent className="pt-0">
            {isLoading ? (
              <div className="text-center py-4">
                <div className="animate-spin w-6 h-6 border-2 border-primary border-t-transparent rounded-full mx-auto mb-2"></div>
                <p className="text-sm text-gray-600">Cargando composición...</p>
              </div>
            ) : composition ? (
              <div className="space-y-6">
                {/* Materials Section */}
                {composition.materials.length > 0 && (
                  <div>
                    <div className="flex items-center gap-2 mb-3">
                      <Package className="w-4 h-4 text-blue-600" />
                      <h4 className="font-semibold text-blue-600">Materiales</h4>
                    </div>
                    <div className="space-y-2">
                      {composition.materials.map((material, index) => (
                        <div key={index} className="flex items-center justify-between p-3 bg-blue-50 rounded-lg">
                          <div className="flex-1">
                            <p className="font-medium">{material.description}</p>
                            <p className="text-sm text-gray-600">
                              {material.quantity} {material.unit}
                            </p>
                          </div>
                          <div className="flex items-center gap-3">
                            {editingMaterial === index ? (
                              <div className="flex items-center gap-2">
                                <Input
                                  type="number"
                                  step="0.01"
                                  value={tempPrice}
                                  onChange={(e) => setTempPrice(e.target.value)}
                                  className="w-24 h-8"
                                  placeholder="Precio"
                                />
                                <Button
                                  size="sm"
                                  onClick={() => handleSavePrice(material.description)}
                                  disabled={savePriceMutation.isPending}
                                  className="h-8 px-2"
                                >
                                  <Save className="w-3 h-3" />
                                </Button>
                                <Button
                                  size="sm"
                                  variant="outline"
                                  onClick={handleCancelEdit}
                                  className="h-8 px-2"
                                >
                                  <X className="w-3 h-3" />
                                </Button>
                              </div>
                            ) : (
                              <div className="flex items-center gap-2">
                                <div className="text-right">
                                  <p className="font-medium">{formatCurrency(material.unitPrice)}</p>
                                  <p className="text-sm text-gray-600">
                                    Total: {formatCurrency(material.total)}
                                  </p>
                                </div>
                                <Button
                                  size="sm"
                                  variant="ghost"
                                  onClick={() => handleEditPrice(index, material.unitPrice)}
                                  className="h-8 px-2"
                                  title="Editar precio y guardar en lista personalizada"
                                >
                                  <Edit3 className="w-3 h-3" />
                                </Button>
                              </div>
                            )}
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                {/* Labor Section */}
                {composition.labor.length > 0 && (
                  <div>
                    <div className="flex items-center gap-2 mb-3">
                      <Users className="w-4 h-4 text-green-600" />
                      <h4 className="font-semibold text-green-600">Mano de Obra</h4>
                    </div>
                    <div className="space-y-2">
                      {composition.labor.map((labor, index) => (
                        <div key={index} className="flex items-center justify-between p-3 bg-green-50 rounded-lg">
                          <div className="flex-1">
                            <p className="font-medium">{labor.description}</p>
                            <p className="text-sm text-gray-600">
                              {labor.quantity} {labor.unit}
                            </p>
                          </div>
                          <div className="text-right">
                            <p className="font-medium">{formatCurrency(labor.unitPrice)}</p>
                            <p className="text-sm text-gray-600">
                              Total: {formatCurrency(labor.total)}
                            </p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                {/* Equipment Section */}
                {composition.equipment.length > 0 && (
                  <div>
                    <div className="flex items-center gap-2 mb-3">
                      <Wrench className="w-4 h-4 text-orange-600" />
                      <h4 className="font-semibold text-orange-600">Equipos y Herramientas</h4>
                    </div>
                    <div className="space-y-2">
                      {composition.equipment.map((equipment, index) => (
                        <div key={index} className="flex items-center justify-between p-3 bg-orange-50 rounded-lg">
                          <div className="flex-1">
                            <p className="font-medium">{equipment.description}</p>
                            <p className="text-sm text-gray-600">
                              {equipment.quantity} {equipment.unit}
                            </p>
                          </div>
                          <div className="text-right">
                            <p className="font-medium">{formatCurrency(equipment.unitPrice)}</p>
                            <p className="text-sm text-gray-600">
                              Total: {formatCurrency(equipment.total)}
                            </p>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                <div className="border-t pt-4">
                  <div className="flex items-center gap-2 text-sm text-gray-600 mb-2">
                    <Star className="w-4 h-4" />
                    <span>Haz clic en el ícono de edición para personalizar precios y guardarlos en tu lista</span>
                  </div>
                </div>
              </div>
            ) : (
              <div className="text-center py-4 text-gray-600">
                <p>No se pudo cargar la composición de esta actividad</p>
              </div>
            )}
          </CardContent>
        </CollapsibleContent>
      </Collapsible>
    </Card>
  );
}