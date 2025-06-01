import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { apiRequest } from "@/lib/queryClient";
import { useAuth } from "@/hooks/useAuth";
import { useToast } from "@/hooks/use-toast";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from "@/components/ui/alert-dialog";
import { Pencil, Trash2, Plus, Eye } from "lucide-react";

interface Activity {
  id: number;
  name: string;
  description?: string;
  unit: string;
  unitPrice: string;
  phaseId: number;
  phase?: {
    id: number;
    name: string;
    description: string;
  };
}

interface ConstructionPhase {
  id: number;
  name: string;
  description: string;
}

export default function AdminActivities() {
  const { user, isAuthenticated } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [editingActivity, setEditingActivity] = useState<Activity | null>(null);
  const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false);
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");

  // Redirect if not admin
  if (!isAuthenticated || user?.role !== "admin") {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-red-600">Acceso Denegado</h1>
          <p className="text-gray-600 mt-2">Solo los administradores pueden acceder a esta página.</p>
        </div>
      </div>
    );
  }

  const { data: activities = [], isLoading: activitiesLoading } = useQuery({
    queryKey: ["/api/activities"],
  });

  const { data: phases = [] } = useQuery({
    queryKey: ["/api/construction-phases"],
  });

  const createMutation = useMutation({
    mutationFn: async (data: any) => {
      return await apiRequest("POST", "/api/activities", data);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/activities"] });
      setIsCreateDialogOpen(false);
      toast({
        title: "Actividad creada",
        description: "La actividad se ha creado exitosamente.",
      });
    },
    onError: (error: any) => {
      toast({
        title: "Error",
        description: error.message || "Error al crear la actividad",
        variant: "destructive",
      });
    },
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, ...data }: any) => {
      return await apiRequest("PUT", `/api/activities/${id}`, data);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/activities"] });
      setIsEditDialogOpen(false);
      setEditingActivity(null);
      toast({
        title: "Actividad actualizada",
        description: "La actividad se ha actualizado exitosamente.",
      });
    },
    onError: (error: any) => {
      toast({
        title: "Error",
        description: error.message || "Error al actualizar la actividad",
        variant: "destructive",
      });
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      return await apiRequest("DELETE", `/api/activities/${id}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/activities"] });
      toast({
        title: "Actividad eliminada",
        description: "La actividad se ha eliminado exitosamente.",
      });
    },
    onError: (error: any) => {
      toast({
        title: "Error",
        description: error.message || "Error al eliminar la actividad",
        variant: "destructive",
      });
    },
  });

  const handleCreateSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const formData = new FormData(e.currentTarget);
    const data = {
      name: formData.get("name") as string,
      description: formData.get("description") as string,
      unit: formData.get("unit") as string,
      unitPrice: formData.get("unitPrice") as string,
      phaseId: Number(formData.get("phaseId")),
    };
    createMutation.mutate(data);
  };

  const handleEditSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (!editingActivity) return;
    
    const formData = new FormData(e.currentTarget);
    const data = {
      id: editingActivity.id,
      name: formData.get("name") as string,
      description: formData.get("description") as string,
      unit: formData.get("unit") as string,
      unitPrice: formData.get("unitPrice") as string,
      phaseId: Number(formData.get("phaseId")),
    };
    updateMutation.mutate(data);
  };

  const filteredActivities = activities.filter((activity: Activity) =>
    activity.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    activity.description?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  if (activitiesLoading) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="flex items-center justify-center min-h-[400px]">
          <div className="animate-spin w-8 h-8 border-4 border-primary border-t-transparent rounded-full" />
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-3xl font-bold">Administrar Actividades</h1>
          <p className="text-gray-600 mt-2">Gestiona las actividades APU del sistema</p>
        </div>
        
        <Dialog open={isCreateDialogOpen} onOpenChange={setIsCreateDialogOpen}>
          <DialogTrigger asChild>
            <Button>
              <Plus className="w-4 h-4 mr-2" />
              Nueva Actividad
            </Button>
          </DialogTrigger>
          <DialogContent className="max-w-2xl">
            <DialogHeader>
              <DialogTitle>Crear Nueva Actividad</DialogTitle>
            </DialogHeader>
            <form onSubmit={handleCreateSubmit} className="space-y-4">
              <div>
                <Label htmlFor="create-name">Nombre de la Actividad</Label>
                <Input id="create-name" name="name" required />
              </div>
              <div>
                <Label htmlFor="create-description">Descripción</Label>
                <Textarea id="create-description" name="description" />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="create-unit">Unidad</Label>
                  <Input id="create-unit" name="unit" placeholder="M2, M3, UND, etc." required />
                </div>
                <div>
                  <Label htmlFor="create-unitPrice">Precio Unitario (BOB)</Label>
                  <Input id="create-unitPrice" name="unitPrice" type="number" step="0.01" required />
                </div>
              </div>
              <div>
                <Label htmlFor="create-phaseId">Fase de Construcción</Label>
                <Select name="phaseId" required>
                  <SelectTrigger>
                    <SelectValue placeholder="Seleccionar fase" />
                  </SelectTrigger>
                  <SelectContent>
                    {phases.map((phase: ConstructionPhase) => (
                      <SelectItem key={phase.id} value={phase.id.toString()}>
                        {phase.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="flex justify-end space-x-2">
                <Button type="button" variant="outline" onClick={() => setIsCreateDialogOpen(false)}>
                  Cancelar
                </Button>
                <Button type="submit" disabled={createMutation.isPending}>
                  {createMutation.isPending ? "Creando..." : "Crear Actividad"}
                </Button>
              </div>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="mb-6">
        <Input
          placeholder="Buscar actividades por nombre o descripción..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="max-w-md"
        />
      </div>

      <div className="grid gap-4">
        {filteredActivities.map((activity: Activity) => (
          <Card key={activity.id}>
            <CardHeader>
              <div className="flex justify-between items-start">
                <div className="flex-1">
                  <CardTitle className="text-lg">{activity.name}</CardTitle>
                  {activity.description && (
                    <CardDescription className="mt-1">{activity.description}</CardDescription>
                  )}
                  <div className="flex items-center space-x-4 mt-2">
                    <Badge variant="secondary">{activity.phase?.name}</Badge>
                    <span className="text-sm text-gray-600">
                      Unidad: {activity.unit}
                    </span>
                    <span className="text-sm font-medium text-green-600">
                      {Number(activity.unitPrice).toFixed(2)} BOB
                    </span>
                  </div>
                </div>
                <div className="flex space-x-2">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => {
                      setEditingActivity(activity);
                      setIsEditDialogOpen(true);
                    }}
                  >
                    <Pencil className="w-4 h-4" />
                  </Button>
                  <AlertDialog>
                    <AlertDialogTrigger asChild>
                      <Button variant="outline" size="sm">
                        <Trash2 className="w-4 h-4" />
                      </Button>
                    </AlertDialogTrigger>
                    <AlertDialogContent>
                      <AlertDialogHeader>
                        <AlertDialogTitle>¿Eliminar actividad?</AlertDialogTitle>
                        <AlertDialogDescription>
                          Esta acción no se puede deshacer. La actividad "{activity.name}" será eliminada permanentemente.
                        </AlertDialogDescription>
                      </AlertDialogHeader>
                      <AlertDialogFooter>
                        <AlertDialogCancel>Cancelar</AlertDialogCancel>
                        <AlertDialogAction
                          onClick={() => deleteMutation.mutate(activity.id)}
                          className="bg-red-600 hover:bg-red-700"
                        >
                          Eliminar
                        </AlertDialogAction>
                      </AlertDialogFooter>
                    </AlertDialogContent>
                  </AlertDialog>
                </div>
              </div>
            </CardHeader>
          </Card>
        ))}
      </div>

      {editingActivity && (
        <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
          <DialogContent className="max-w-2xl">
            <DialogHeader>
              <DialogTitle>Editar Actividad</DialogTitle>
            </DialogHeader>
            <form onSubmit={handleEditSubmit} className="space-y-4">
              <div>
                <Label htmlFor="edit-name">Nombre de la Actividad</Label>
                <Input 
                  id="edit-name" 
                  name="name" 
                  defaultValue={editingActivity.name}
                  required 
                />
              </div>
              <div>
                <Label htmlFor="edit-description">Descripción</Label>
                <Textarea 
                  id="edit-description" 
                  name="description" 
                  defaultValue={editingActivity.description || ""}
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="edit-unit">Unidad</Label>
                  <Input 
                    id="edit-unit" 
                    name="unit" 
                    defaultValue={editingActivity.unit}
                    required 
                  />
                </div>
                <div>
                  <Label htmlFor="edit-unitPrice">Precio Unitario (BOB)</Label>
                  <Input 
                    id="edit-unitPrice" 
                    name="unitPrice" 
                    type="number" 
                    step="0.01"
                    defaultValue={editingActivity.unitPrice}
                    required 
                  />
                </div>
              </div>
              <div>
                <Label htmlFor="edit-phaseId">Fase de Construcción</Label>
                <Select name="phaseId" defaultValue={editingActivity.phaseId.toString()}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {phases.map((phase: ConstructionPhase) => (
                      <SelectItem key={phase.id} value={phase.id.toString()}>
                        {phase.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="flex justify-end space-x-2">
                <Button 
                  type="button" 
                  variant="outline" 
                  onClick={() => {
                    setIsEditDialogOpen(false);
                    setEditingActivity(null);
                  }}
                >
                  Cancelar
                </Button>
                <Button type="submit" disabled={updateMutation.isPending}>
                  {updateMutation.isPending ? "Actualizando..." : "Actualizar Actividad"}
                </Button>
              </div>
            </form>
          </DialogContent>
        </Dialog>
      )}

      {filteredActivities.length === 0 && searchTerm && (
        <div className="text-center py-8">
          <p className="text-gray-500">No se encontraron actividades que coincidan con "{searchTerm}"</p>
        </div>
      )}
    </div>
  );
}