import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Badge } from "@/components/ui/badge";
import { 
  Plus, 
  Edit3, 
  Save, 
  X, 
  Trash2, 
  Package, 
  Users, 
  Wrench,
  Copy,
  Settings
} from "lucide-react";
import { formatCurrency } from "@/lib/utils";
import { useToast } from "@/hooks/use-toast";
import { apiRequest } from "@/lib/queryClient";

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

interface CustomActivityManagerProps {
  onActivitySelect?: (activity: CustomActivity) => void;
}

export default function CustomActivityManager({ onActivitySelect }: CustomActivityManagerProps) {
  const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false);
  const [editingActivity, setEditingActivity] = useState<CustomActivity | null>(null);
  const [newActivityName, setNewActivityName] = useState("");
  const [newActivityUnit, setNewActivityUnit] = useState("");
  const [newActivityDescription, setNewActivityDescription] = useState("");
  const { toast } = useToast();
  const queryClient = useQueryClient();

  // Load custom activities from localStorage for demo
  const getCustomActivities = (): CustomActivity[] => {
    return JSON.parse(localStorage.getItem('userCustomActivities') || '[]');
  };

  const saveCustomActivities = (activities: CustomActivity[]) => {
    localStorage.setItem('userCustomActivities', JSON.stringify(activities));
  };

  const createCustomActivity = useMutation({
    mutationFn: async (activityData: Omit<CustomActivity, 'id' | 'createdAt' | 'updatedAt'>) => {
      const activities = getCustomActivities();
      const newActivity: CustomActivity = {
        ...activityData,
        id: `custom_${Date.now()}`,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      };
      
      activities.push(newActivity);
      saveCustomActivities(activities);
      return newActivity;
    },
    onSuccess: () => {
      toast({
        title: "Actividad creada",
        description: "Tu actividad personalizada se ha creado exitosamente",
      });
      setIsCreateDialogOpen(false);
      resetForm();
      queryClient.invalidateQueries({ queryKey: ['customActivities'] });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo crear la actividad personalizada",
        variant: "destructive",
      });
    },
  });

  const updateCustomActivity = useMutation({
    mutationFn: async (activityData: CustomActivity) => {
      const activities = getCustomActivities();
      const index = activities.findIndex(a => a.id === activityData.id);
      
      if (index >= 0) {
        activities[index] = { ...activityData, updatedAt: new Date().toISOString() };
        saveCustomActivities(activities);
        return activities[index];
      }
      throw new Error('Activity not found');
    },
    onSuccess: () => {
      toast({
        title: "Actividad actualizada",
        description: "Tu actividad personalizada se ha actualizado exitosamente",
      });
      setEditingActivity(null);
      // Force a re-render by updating the component state
      window.location.reload();
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo actualizar la actividad personalizada",
        variant: "destructive",
      });
    },
  });

  const deleteCustomActivity = useMutation({
    mutationFn: async (activityId: string) => {
      const activities = getCustomActivities();
      const filtered = activities.filter(a => a.id !== activityId);
      saveCustomActivities(filtered);
      return activityId;
    },
    onSuccess: () => {
      toast({
        title: "Actividad eliminada",
        description: "La actividad personalizada se ha eliminado",
      });
      queryClient.invalidateQueries({ queryKey: ['customActivities'] });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo eliminar la actividad",
        variant: "destructive",
      });
    },
  });

  const resetForm = () => {
    setNewActivityName("");
    setNewActivityUnit("");
    setNewActivityDescription("");
  };

  const handleCreateActivity = () => {
    if (!newActivityName.trim() || !newActivityUnit.trim()) {
      toast({
        title: "Error",
        description: "El nombre y la unidad son obligatorios",
        variant: "destructive",
      });
      return;
    }

    createCustomActivity.mutate({
      customName: newActivityName.trim(),
      unit: newActivityUnit.trim(),
      description: newActivityDescription.trim(),
      materials: [],
      labor: [],
      equipment: []
    });
  };

  const copyFromExistingActivity = async (activityId: number, activityName: string) => {
    try {
      // Fetch composition from existing activity
      const response = await apiRequest("GET", `/api/activities/${activityId}/composition`);
      const composition = await response.json();
      
      const customActivity: Omit<CustomActivity, 'id' | 'createdAt' | 'updatedAt'> = {
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
        })) || []
      };

      createCustomActivity.mutate(customActivity);
    } catch (error) {
      toast({
        title: "Error",
        description: "No se pudo copiar la actividad",
        variant: "destructive",
      });
    }
  };

  const customActivities = getCustomActivities();

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-xl font-semibold">Actividades Personalizadas</h2>
        <Dialog open={isCreateDialogOpen} onOpenChange={setIsCreateDialogOpen}>
          <DialogTrigger asChild>
            <Button className="gap-2">
              <Plus className="w-4 h-4" />
              Nueva Actividad
            </Button>
          </DialogTrigger>
          <DialogContent className="max-w-md">
            <DialogHeader>
              <DialogTitle>Crear Actividad Personalizada</DialogTitle>
            </DialogHeader>
            <div className="space-y-4">
              <div>
                <label className="text-sm font-medium">Nombre de la actividad</label>
                <Input
                  value={newActivityName}
                  onChange={(e) => setNewActivityName(e.target.value)}
                  placeholder="Ej: Excavación personalizada"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Unidad</label>
                <Input
                  value={newActivityUnit}
                  onChange={(e) => setNewActivityUnit(e.target.value)}
                  placeholder="Ej: m3, m2, kg"
                />
              </div>
              <div>
                <label className="text-sm font-medium">Descripción (opcional)</label>
                <Input
                  value={newActivityDescription}
                  onChange={(e) => setNewActivityDescription(e.target.value)}
                  placeholder="Descripción de la actividad"
                />
              </div>
              <div className="flex gap-2">
                <Button 
                  onClick={handleCreateActivity}
                  disabled={createCustomActivity.isPending}
                  className="flex-1"
                >
                  {createCustomActivity.isPending ? "Creando..." : "Crear"}
                </Button>
                <Button 
                  variant="outline" 
                  onClick={() => setIsCreateDialogOpen(false)}
                  className="flex-1"
                >
                  Cancelar
                </Button>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      {customActivities.length === 0 ? (
        <Card>
          <CardContent className="text-center py-8">
            <Settings className="w-12 h-12 text-gray-400 mx-auto mb-4" />
            <p className="text-gray-600 mb-4">
              Aún no tienes actividades personalizadas
            </p>
            <p className="text-sm text-gray-500 mb-4">
              Crea actividades nuevas o copia actividades existentes para personalizarlas
            </p>
          </CardContent>
        </Card>
      ) : (
        <div className="grid gap-4">
          {customActivities.map((activity) => (
            <Card key={activity.id} className="hover:shadow-md transition-shadow">
              <CardHeader>
                <div className="flex items-center justify-between">
                  <div>
                    <CardTitle className="text-lg">{activity.customName}</CardTitle>
                    {activity.originalName && (
                      <p className="text-sm text-gray-600">
                        Basada en: {activity.originalName}
                      </p>
                    )}
                  </div>
                  <div className="flex items-center gap-2">
                    <Badge variant="outline">{activity.unit}</Badge>
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => setEditingActivity(activity)}
                    >
                      <Edit3 className="w-4 h-4" />
                    </Button>
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => deleteCustomActivity.mutate(activity.id)}
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </div>
                </div>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-3 gap-4 text-sm">
                  <div className="flex items-center gap-2">
                    <Package className="w-4 h-4 text-blue-600" />
                    <span>{activity.materials.length} Materiales</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Users className="w-4 h-4 text-green-600" />
                    <span>{activity.labor.length} Mano de obra</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Wrench className="w-4 h-4 text-orange-600" />
                    <span>{activity.equipment.length} Equipos</span>
                  </div>
                </div>
                {activity.description && (
                  <p className="text-sm text-gray-600 mt-3">{activity.description}</p>
                )}
                <div className="flex gap-2 mt-4">
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => onActivitySelect?.(activity)}
                  >
                    Usar en Presupuesto
                  </Button>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => setEditingActivity(activity)}
                  >
                    Editar Composición
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <div className="text-center">
        <p className="text-sm text-gray-600 mb-2">
          ¿Quieres personalizar una actividad existente?
        </p>
        <p className="text-xs text-gray-500">
          Ve a cualquier presupuesto, expande una actividad y haz clic en "Copiar y Personalizar"
        </p>
      </div>
    </div>
  );
}