import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { 
  Plus, 
  Edit3, 
  Save, 
  X, 
  Trash2, 
  Package, 
  Users, 
  Wrench,
  Calculator
} from "lucide-react";
import { formatCurrency } from "@/lib/utils";
import { useToast } from "@/hooks/use-toast";

interface CustomActivity {
  id: string;
  originalActivityId?: number;
  customName: string;
  originalName?: string;
  unit: string;
  description?: string;
  materials: CustomMaterial[];
  labor: CustomLabor[];
  equipment: CustomEquipment[];
  createdAt: string;
  updatedAt: string;
}

interface CustomMaterial {
  id: string;
  description: string;
  unit: string;
  quantity: number;
  unitPrice: number;
  total: number;
}

interface CustomLabor {
  id: string;
  description: string;
  unit: string;
  quantity: number;
  unitPrice: number;
  total: number;
}

interface CustomEquipment {
  id: string;
  description: string;
  unit: string;
  quantity: number;
  unitPrice: number;
  total: number;
}

interface ActivityCompositionEditorProps {
  activity: CustomActivity;
  onSave: (activity: CustomActivity) => void;
  onCancel: () => void;
}

export default function ActivityCompositionEditor({ 
  activity, 
  onSave, 
  onCancel 
}: ActivityCompositionEditorProps) {
  const [editedActivity, setEditedActivity] = useState<CustomActivity>(activity);
  const [activeTab, setActiveTab] = useState("materials");
  const [editingItem, setEditingItem] = useState<{ type: string; id: string } | null>(null);
  const [newItem, setNewItem] = useState({
    description: "",
    unit: "",
    quantity: 1,
    unitPrice: 1
  });
  const { toast } = useToast();

  const calculateTotal = (quantity: number, unitPrice: number) => quantity * unitPrice;

  const updateActivityName = (newName: string) => {
    setEditedActivity(prev => ({
      ...prev,
      customName: newName
    }));
  };

  const updateActivityUnit = (newUnit: string) => {
    setEditedActivity(prev => ({
      ...prev,
      unit: newUnit
    }));
  };

  const updateActivityDescription = (newDescription: string) => {
    setEditedActivity(prev => ({
      ...prev,
      description: newDescription
    }));
  };

  const addMaterial = () => {
    const quantity = Number(newItem.quantity) || 0;
    const unitPrice = Number(newItem.unitPrice) || 0;
    
    if (!newItem.description.trim() || !newItem.unit.trim() || quantity <= 0 || unitPrice <= 0) {
      toast({
        title: "Error",
        description: "Todos los campos son obligatorios y deben ser válidos",
        variant: "destructive",
      });
      return;
    }

    const material: CustomMaterial = {
      id: `mat_${Date.now()}`,
      description: newItem.description.trim(),
      unit: newItem.unit.trim(),
      quantity: quantity,
      unitPrice: unitPrice,
      total: calculateTotal(quantity, unitPrice)
    };

    setEditedActivity(prev => ({
      ...prev,
      materials: [...prev.materials, material]
    }));

    resetNewItem();
  };

  const addLabor = () => {
    const quantity = Number(newItem.quantity) || 0;
    const unitPrice = Number(newItem.unitPrice) || 0;
    
    if (!newItem.description.trim() || !newItem.unit.trim() || quantity <= 0 || unitPrice <= 0) {
      toast({
        title: "Error",
        description: "Todos los campos son obligatorios y deben ser válidos",
        variant: "destructive",
      });
      return;
    }

    const labor: CustomLabor = {
      id: `lab_${Date.now()}`,
      description: newItem.description.trim(),
      unit: newItem.unit.trim(),
      quantity: quantity,
      unitPrice: unitPrice,
      total: calculateTotal(quantity, unitPrice)
    };

    setEditedActivity(prev => ({
      ...prev,
      labor: [...prev.labor, labor]
    }));

    resetNewItem();
  };

  const addEquipment = () => {
    const quantity = Number(newItem.quantity) || 0;
    const unitPrice = Number(newItem.unitPrice) || 0;
    
    if (!newItem.description.trim() || !newItem.unit.trim() || quantity <= 0 || unitPrice <= 0) {
      toast({
        title: "Error",
        description: "Todos los campos son obligatorios y deben ser válidos",
        variant: "destructive",
      });
      return;
    }

    const equipment: CustomEquipment = {
      id: `eq_${Date.now()}`,
      description: newItem.description.trim(),
      unit: newItem.unit.trim(),
      quantity: quantity,
      unitPrice: unitPrice,
      total: calculateTotal(quantity, unitPrice)
    };

    setEditedActivity(prev => ({
      ...prev,
      equipment: [...prev.equipment, equipment]
    }));

    resetNewItem();
  };

  const removeMaterial = (id: string) => {
    setEditedActivity(prev => ({
      ...prev,
      materials: prev.materials.filter(m => m.id !== id)
    }));
  };

  const removeLabor = (id: string) => {
    setEditedActivity(prev => ({
      ...prev,
      labor: prev.labor.filter(l => l.id !== id)
    }));
  };

  const removeEquipment = (id: string) => {
    setEditedActivity(prev => ({
      ...prev,
      equipment: prev.equipment.filter(e => e.id !== id)
    }));
  };

  const updateMaterial = (id: string, updates: Partial<CustomMaterial>) => {
    setEditedActivity(prev => ({
      ...prev,
      materials: prev.materials.map(m => 
        m.id === id 
          ? { 
              ...m, 
              ...updates, 
              total: calculateTotal(
                updates.quantity ?? m.quantity, 
                updates.unitPrice ?? m.unitPrice
              ) 
            }
          : m
      )
    }));
  };

  const updateLabor = (id: string, updates: Partial<CustomLabor>) => {
    setEditedActivity(prev => ({
      ...prev,
      labor: prev.labor.map(l => 
        l.id === id 
          ? { 
              ...l, 
              ...updates, 
              total: calculateTotal(
                updates.quantity ?? l.quantity, 
                updates.unitPrice ?? l.unitPrice
              ) 
            }
          : l
      )
    }));
  };

  const updateEquipment = (id: string, updates: Partial<CustomEquipment>) => {
    setEditedActivity(prev => ({
      ...prev,
      equipment: prev.equipment.map(e => 
        e.id === id 
          ? { 
              ...e, 
              ...updates, 
              total: calculateTotal(
                updates.quantity ?? e.quantity, 
                updates.unitPrice ?? e.unitPrice
              ) 
            }
          : e
      )
    }));
  };

  const resetNewItem = () => {
    setNewItem({
      description: "",
      unit: "",
      quantity: 1,
      unitPrice: 1
    });
  };

  const handleSave = () => {
    if (!editedActivity.customName.trim()) {
      toast({
        title: "Error",
        description: "El nombre de la actividad es obligatorio",
        variant: "destructive",
      });
      return;
    }

    onSave({
      ...editedActivity,
      updatedAt: new Date().toISOString()
    });
  };

  const getTotalCost = () => {
    const materialsTotal = editedActivity.materials.reduce((sum, m) => sum + m.total, 0);
    const laborTotal = editedActivity.labor.reduce((sum, l) => sum + l.total, 0);
    const equipmentTotal = editedActivity.equipment.reduce((sum, e) => sum + e.total, 0);
    return materialsTotal + laborTotal + equipmentTotal;
  };

  return (
    <Dialog open={true} onOpenChange={() => onCancel()}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Editar Composición de Actividad</DialogTitle>
        </DialogHeader>

        <div className="space-y-6">
          {/* Activity Basic Info */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Información General</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <label className="text-sm font-medium">Nombre de la actividad</label>
                <Input
                  value={editedActivity.customName}
                  onChange={(e) => updateActivityName(e.target.value)}
                  placeholder="Nombre de la actividad"
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="text-sm font-medium">Unidad</label>
                  <Input
                    value={editedActivity.unit}
                    onChange={(e) => updateActivityUnit(e.target.value)}
                    placeholder="m2, m3, kg, etc."
                  />
                </div>
                <div className="flex items-end">
                  <div className="text-right">
                    <p className="text-sm text-gray-600">Costo total estimado</p>
                    <p className="text-xl font-bold text-primary">
                      {formatCurrency(getTotalCost())}
                    </p>
                  </div>
                </div>
              </div>
              <div>
                <label className="text-sm font-medium">Descripción</label>
                <Input
                  value={editedActivity.description || ""}
                  onChange={(e) => updateActivityDescription(e.target.value)}
                  placeholder="Descripción de la actividad"
                />
              </div>
            </CardContent>
          </Card>

          {/* Composition Editor */}
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList className="grid w-full grid-cols-3">
              <TabsTrigger value="materials" className="gap-2">
                <Package className="w-4 h-4" />
                Materiales ({editedActivity.materials.length})
              </TabsTrigger>
              <TabsTrigger value="labor" className="gap-2">
                <Users className="w-4 h-4" />
                Mano de Obra ({editedActivity.labor.length})
              </TabsTrigger>
              <TabsTrigger value="equipment" className="gap-2">
                <Wrench className="w-4 h-4" />
                Equipos ({editedActivity.equipment.length})
              </TabsTrigger>
            </TabsList>

            <TabsContent value="materials" className="space-y-4">
              <Card>
                <CardHeader>
                  <CardTitle className="text-lg flex items-center gap-2">
                    <Package className="w-5 h-5 text-blue-600" />
                    Materiales
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  {/* Add new material form */}
                  <div className="grid grid-cols-6 gap-2 items-end">
                    <div className="col-span-2">
                      <label className="text-xs font-medium">Descripción</label>
                      <Input
                        value={newItem.description}
                        onChange={(e) => setNewItem(prev => ({ ...prev, description: e.target.value }))}
                        placeholder="Descripción del material"
                        className="h-8"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-medium">Unidad</label>
                      <Input
                        value={newItem.unit}
                        onChange={(e) => setNewItem(prev => ({ ...prev, unit: e.target.value }))}
                        placeholder="kg, m3"
                        className="h-8"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-medium">Cantidad</label>
                      <Input
                        type="number"
                        step="0.01"
                        value={newItem.quantity}
                        onChange={(e) => setNewItem(prev => ({ ...prev, quantity: parseFloat(e.target.value) || 0 }))}
                        className="h-8"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-medium">Precio Unit.</label>
                      <Input
                        type="number"
                        step="0.01"
                        value={newItem.unitPrice}
                        onChange={(e) => setNewItem(prev => ({ ...prev, unitPrice: parseFloat(e.target.value) || 0 }))}
                        className="h-8"
                      />
                    </div>
                    <Button size="sm" onClick={addMaterial} className="h-8">
                      <Plus className="w-4 h-4" />
                    </Button>
                  </div>

                  {/* Materials list */}
                  <div className="space-y-2">
                    {editedActivity.materials.map((material) => (
                      <div key={material.id} className="flex items-center gap-2 p-3 bg-blue-50 rounded-lg">
                        <div className="flex-1 grid grid-cols-5 gap-2 text-sm">
                          <div>
                            <p className="font-medium">{material.description}</p>
                          </div>
                          <div className="text-center">
                            <p>{material.quantity} {material.unit}</p>
                          </div>
                          <div className="text-center">
                            <p>{formatCurrency(material.unitPrice)}</p>
                          </div>
                          <div className="text-center">
                            <p className="font-medium">{formatCurrency(material.total)}</p>
                          </div>
                          <div className="flex gap-1 justify-end">
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => setEditingItem({ type: 'material', id: material.id })}
                              className="h-6 w-6 p-0"
                            >
                              <Edit3 className="w-3 h-3" />
                            </Button>
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => removeMaterial(material.id)}
                              className="h-6 w-6 p-0"
                            >
                              <Trash2 className="w-3 h-3" />
                            </Button>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="labor" className="space-y-4">
              <Card>
                <CardHeader>
                  <CardTitle className="text-lg flex items-center gap-2">
                    <Users className="w-5 h-5 text-green-600" />
                    Mano de Obra
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  {/* Add new labor form */}
                  <div className="grid grid-cols-6 gap-2 items-end">
                    <div className="col-span-2">
                      <label className="text-xs font-medium">Descripción</label>
                      <Input
                        value={newItem.description}
                        onChange={(e) => setNewItem(prev => ({ ...prev, description: e.target.value }))}
                        placeholder="Descripción de la mano de obra"
                        className="h-8"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-medium">Unidad</label>
                      <Input
                        value={newItem.unit}
                        onChange={(e) => setNewItem(prev => ({ ...prev, unit: e.target.value }))}
                        placeholder="hr, día"
                        className="h-8"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-medium">Cantidad</label>
                      <Input
                        type="number"
                        step="0.01"
                        value={newItem.quantity}
                        onChange={(e) => setNewItem(prev => ({ ...prev, quantity: parseFloat(e.target.value) || 0 }))}
                        className="h-8"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-medium">Precio Unit.</label>
                      <Input
                        type="number"
                        step="0.01"
                        value={newItem.unitPrice}
                        onChange={(e) => setNewItem(prev => ({ ...prev, unitPrice: parseFloat(e.target.value) || 0 }))}
                        className="h-8"
                      />
                    </div>
                    <Button size="sm" onClick={addLabor} className="h-8">
                      <Plus className="w-4 h-4" />
                    </Button>
                  </div>

                  {/* Labor list */}
                  <div className="space-y-2">
                    {editedActivity.labor.map((labor) => (
                      <div key={labor.id} className="flex items-center gap-2 p-3 bg-green-50 rounded-lg">
                        <div className="flex-1 grid grid-cols-5 gap-2 text-sm">
                          <div>
                            <p className="font-medium">{labor.description}</p>
                          </div>
                          <div className="text-center">
                            <p>{labor.quantity} {labor.unit}</p>
                          </div>
                          <div className="text-center">
                            <p>{formatCurrency(labor.unitPrice)}</p>
                          </div>
                          <div className="text-center">
                            <p className="font-medium">{formatCurrency(labor.total)}</p>
                          </div>
                          <div className="flex gap-1 justify-end">
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => setEditingItem({ type: 'labor', id: labor.id })}
                              className="h-6 w-6 p-0"
                            >
                              <Edit3 className="w-3 h-3" />
                            </Button>
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => removeLabor(labor.id)}
                              className="h-6 w-6 p-0"
                            >
                              <Trash2 className="w-3 h-3" />
                            </Button>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="equipment" className="space-y-4">
              <Card>
                <CardHeader>
                  <CardTitle className="text-lg flex items-center gap-2">
                    <Wrench className="w-5 h-5 text-orange-600" />
                    Equipos y Herramientas
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  {/* Add new equipment form */}
                  <div className="grid grid-cols-6 gap-2 items-end">
                    <div className="col-span-2">
                      <label className="text-xs font-medium">Descripción</label>
                      <Input
                        value={newItem.description}
                        onChange={(e) => setNewItem(prev => ({ ...prev, description: e.target.value }))}
                        placeholder="Descripción del equipo"
                        className="h-8"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-medium">Unidad</label>
                      <Input
                        value={newItem.unit}
                        onChange={(e) => setNewItem(prev => ({ ...prev, unit: e.target.value }))}
                        placeholder="hr, día"
                        className="h-8"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-medium">Cantidad</label>
                      <Input
                        type="number"
                        step="0.01"
                        value={newItem.quantity}
                        onChange={(e) => setNewItem(prev => ({ ...prev, quantity: parseFloat(e.target.value) || 0 }))}
                        className="h-8"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-medium">Precio Unit.</label>
                      <Input
                        type="number"
                        step="0.01"
                        value={newItem.unitPrice}
                        onChange={(e) => setNewItem(prev => ({ ...prev, unitPrice: parseFloat(e.target.value) || 0 }))}
                        className="h-8"
                      />
                    </div>
                    <Button size="sm" onClick={addEquipment} className="h-8">
                      <Plus className="w-4 h-4" />
                    </Button>
                  </div>

                  {/* Equipment list */}
                  <div className="space-y-2">
                    {editedActivity.equipment.map((equipment) => (
                      <div key={equipment.id} className="flex items-center gap-2 p-3 bg-orange-50 rounded-lg">
                        <div className="flex-1 grid grid-cols-5 gap-2 text-sm">
                          <div>
                            <p className="font-medium">{equipment.description}</p>
                          </div>
                          <div className="text-center">
                            <p>{equipment.quantity} {equipment.unit}</p>
                          </div>
                          <div className="text-center">
                            <p>{formatCurrency(equipment.unitPrice)}</p>
                          </div>
                          <div className="text-center">
                            <p className="font-medium">{formatCurrency(equipment.total)}</p>
                          </div>
                          <div className="flex gap-1 justify-end">
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => setEditingItem({ type: 'equipment', id: equipment.id })}
                              className="h-6 w-6 p-0"
                            >
                              <Edit3 className="w-3 h-3" />
                            </Button>
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => removeEquipment(equipment.id)}
                              className="h-6 w-6 p-0"
                            >
                              <Trash2 className="w-3 h-3" />
                            </Button>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>

          {/* Action buttons */}
          <div className="flex gap-3 justify-end">
            <Button variant="outline" onClick={onCancel}>
              Cancelar
            </Button>
            <Button onClick={handleSave} className="gap-2">
              <Save className="w-4 h-4" />
              Guardar Actividad
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}