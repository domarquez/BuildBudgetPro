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
  StarOff,
  Copy,
  Settings
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
  const [tempName, setTempName] = useState<string>("");
  const [userPrices, setUserPrices] = useState(() => 
    JSON.parse(localStorage.getItem('userMaterialPrices') || '[]')
  );
  const { toast } = useToast();
  const queryClient = useQueryClient();

  const { data: composition, isLoading } = useQuery<ActivityComposition>({
    queryKey: [`/api/activities/${activityId}/composition`],
    enabled: isOpen,
  });

  const savePriceMutation = useMutation({
    mutationFn: async ({ materialName, customName, newPrice, unit }: { materialName: string; customName: string; newPrice: number; unit: string }) => {
      const newEntry = {
        id: Date.now(),
        originalName: materialName,
        customName: customName,
        price: newPrice,
        unit: unit,
        savedAt: new Date().toISOString()
      };
      
      // Update existing or add new
      const updatedPrices = [...userPrices];
      const existingIndex = updatedPrices.findIndex((p: any) => p.originalName === materialName);
      if (existingIndex >= 0) {
        updatedPrices[existingIndex] = newEntry;
      } else {
        updatedPrices.push(newEntry);
      }
      
      // Update both localStorage and state
      localStorage.setItem('userMaterialPrices', JSON.stringify(updatedPrices));
      setUserPrices(updatedPrices);
      return newEntry;
    },
    onSuccess: () => {
      toast({
        title: "Material personalizado guardado",
        description: "Tu material personalizado se ha guardado exitosamente",
      });
      setEditingMaterial(null);
      setTempPrice("");
      setTempName("");
    },
    onError: (error) => {
      toast({
        title: "Error",
        description: "No se pudo guardar el material personalizado",
        variant: "destructive",
      });
    },
  });

  const handleEditPrice = (index: number, currentPrice: number, currentName: string) => {
    setEditingMaterial(index);
    setTempPrice(currentPrice.toString());
    setTempName(currentName);
  };

  const handleSavePrice = (originalMaterialName: string, unit: string) => {
    const newPrice = parseFloat(tempPrice);
    if (isNaN(newPrice) || newPrice <= 0) {
      toast({
        title: "Error",
        description: "El precio debe ser un número válido mayor a 0",
        variant: "destructive",
      });
      return;
    }

    if (!tempName.trim()) {
      toast({
        title: "Error",
        description: "El nombre del material no puede estar vacío",
        variant: "destructive",
      });
      return;
    }

    savePriceMutation.mutate({ 
      materialName: originalMaterialName,
      customName: tempName.trim(),
      newPrice, 
      unit 
    });
  };

  const handleCancelEdit = () => {
    setEditingMaterial(null);
    setTempPrice("");
    setTempName("");
  };

  const calculateNewTotal = (originalQuantity: number, newPrice: number) => {
    return originalQuantity * newPrice;
  };

  const copyToCustomActivities = useMutation({
    mutationFn: async () => {
      if (!composition) throw new Error('No composition data');
      
      const customActivities = JSON.parse(localStorage.getItem('userCustomActivities') || '[]');
      const newActivity = {
        id: `custom_${Date.now()}`,
        originalActivityId: activityId,
        customName: `${activityName} (Personalizada)`,
        originalName: activityName,
        unit: "m2", // Default unit, user can modify
        description: `Copia personalizada de ${activityName}`,
        materials: composition.materials?.map((mat: any, index: number) => ({
          id: `mat_${Date.now()}_${index}`,
          description: mat.description,
          unit: mat.unit,
          quantity: mat.quantity,
          unitPrice: mat.unitPrice,
          total: mat.total
        })) || [],
        labor: composition.labor?.map((lab: any, index: number) => ({
          id: `lab_${Date.now()}_${index}`,
          description: lab.description,
          unit: lab.unit,
          quantity: lab.quantity,
          unitPrice: lab.unitPrice,
          total: lab.total
        })) || [],
        equipment: composition.equipment?.map((eq: any, index: number) => ({
          id: `eq_${Date.now()}_${index}`,
          description: eq.description,
          unit: eq.unit,
          quantity: eq.quantity,
          unitPrice: eq.unitPrice,
          total: eq.total
        })) || [],
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      };
      
      customActivities.push(newActivity);
      localStorage.setItem('userCustomActivities', JSON.stringify(customActivities));
      return newActivity;
    },
    onSuccess: () => {
      toast({
        title: "Actividad copiada",
        description: "La actividad se ha copiado a tu lista personalizada y puedes editarla completamente",
      });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo copiar la actividad",
        variant: "destructive",
      });
    },
  });

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
              <div className="flex items-center gap-3">
                <Button
                  size="sm"
                  variant="outline"
                  onClick={() => copyToCustomActivities.mutate()}
                  disabled={copyToCustomActivities.isPending || !composition}
                  className="gap-2"
                  title="Copiar esta actividad a tu lista personalizada para editarla"
                >
                  <Copy className="w-4 h-4" />
                  {copyToCustomActivities.isPending ? "Copiando..." : "Copiar y Personalizar"}
                </Button>
                <div className="text-right">
                  <div className="text-sm text-gray-600">
                    {quantity} unidades × {formatCurrency(unitPrice)}
                  </div>
                  <div className="text-lg font-bold text-primary">
                    {formatCurrency(subtotal)}
                  </div>
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
                              <div className="flex flex-col gap-2">
                                <div className="flex items-center gap-2">
                                  <Input
                                    type="text"
                                    value={tempName}
                                    onChange={(e) => setTempName(e.target.value)}
                                    className="w-48 h-8"
                                    placeholder="Nombre personalizado"
                                  />
                                  <Input
                                    type="number"
                                    step="0.01"
                                    value={tempPrice}
                                    onChange={(e) => setTempPrice(e.target.value)}
                                    className="w-24 h-8"
                                    placeholder="Precio"
                                  />
                                </div>
                                <div className="flex items-center gap-2">
                                  <Button
                                    size="sm"
                                    onClick={() => handleSavePrice(material.description, material.unit)}
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
                              </div>
                            ) : (
                              <div className="flex items-center gap-2">
                                <div className="text-right">
                                  {(() => {
                                    const userPrice = userPrices.find((p: any) => p.originalName === material.description);
                                    const displayPrice = userPrice ? userPrice.price : material.unitPrice;
                                    const displayName = userPrice ? userPrice.customName : material.description;
                                    const calculatedTotal = calculateNewTotal(material.quantity, displayPrice);
                                    
                                    return (
                                      <>
                                        <div className="mb-1">
                                          {userPrice && (
                                            <div className="flex items-center gap-1">
                                              <Star className="w-3 h-3 text-yellow-500 fill-current" />
                                              <span className="text-xs text-yellow-600 font-medium">Personalizado</span>
                                            </div>
                                          )}
                                          <p className="font-medium text-sm">{displayName}</p>
                                        </div>
                                        <p className="font-medium">{formatCurrency(displayPrice)}</p>
                                        <p className="text-sm text-gray-600">
                                          Total: {formatCurrency(calculatedTotal)}
                                        </p>
                                      </>
                                    );
                                  })()}
                                </div>
                                <Button
                                  size="sm"
                                  variant="ghost"
                                  onClick={() => handleEditPrice(index, material.unitPrice, material.description)}
                                  className="h-8 px-2"
                                  title="Editar nombre y precio personalizado"
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
                {composition.equipment && composition.equipment.length > 0 && (
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
                    <span>Haz clic en el ícono de edición para personalizar nombres y precios de materiales</span>
                  </div>
                  {/* Show user's saved custom materials */}
                  {(() => {
                    const savedMaterials = JSON.parse(localStorage.getItem('userMaterialPrices') || '[]');
                    const relevantMaterials = savedMaterials.filter((saved: any) => 
                      composition?.materials?.some(mat => mat.description === saved.originalName)
                    );
                    
                    if (relevantMaterials.length > 0) {
                      return (
                        <div className="mt-3 p-3 bg-green-50 rounded-lg">
                          <p className="text-sm font-medium text-green-800 mb-2">
                            Materiales personalizados guardados:
                          </p>
                          {relevantMaterials.map((saved: any) => (
                            <div key={saved.id} className="text-xs text-green-700">
                              • {saved.customName} - {formatCurrency(saved.price)} / {saved.unit}
                            </div>
                          ))}
                        </div>
                      );
                    }
                    return null;
                  })()}
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