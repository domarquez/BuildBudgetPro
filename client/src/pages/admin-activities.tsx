import { useState } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { useToast } from "@/hooks/use-toast";
import { queryClient } from "@/lib/queryClient";
import { Search, Move, Save, RefreshCw, Settings } from "lucide-react";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";

interface Activity {
  id: number;
  name: string;
  phaseId: number;
  unit: string;
  unitPrice: number;
}

interface ConstructionPhase {
  id: number;
  name: string;
}

export default function AdminActivities() {
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedPhase, setSelectedPhase] = useState<string>("");
  const [editingActivity, setEditingActivity] = useState<Activity | null>(null);
  const [newPhaseId, setNewPhaseId] = useState("");
  const { toast } = useToast();

  // Fetch activities
  const { data: activities = [], isLoading: activitiesLoading } = useQuery({
    queryKey: ["/api/activities"],
  });

  // Fetch phases
  const { data: phases = [] } = useQuery<ConstructionPhase[]>({
    queryKey: ["/api/construction-phases"],
  });

  // Update activity phase mutation
  const updateActivityMutation = useMutation({
    mutationFn: async ({ activityId, phaseId }: { activityId: number; phaseId: number }) => {
      const response = await fetch(`/api/admin/activities/${activityId}/phase`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ phaseId }),
      });
      if (!response.ok) {
        throw new Error('Failed to update activity phase');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/activities"] });
      toast({
        title: "Actividad actualizada",
        description: "La fase de la actividad se actualizó correctamente.",
      });
      setEditingActivity(null);
      setNewPhaseId("");
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo actualizar la fase de la actividad.",
        variant: "destructive",
      });
    },
  });

  // Bulk move activities mutation
  const bulkMoveMutation = useMutation({
    mutationFn: async ({ fromPhaseId, toPhaseId, keyword }: { fromPhaseId: number; toPhaseId: number; keyword: string }) => {
      const response = await fetch('/api/admin/activities/bulk-move', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ fromPhaseId, toPhaseId, keyword }),
      });
      if (!response.ok) {
        throw new Error('Failed to bulk move activities');
      }
      return response.json();
    },
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ["/api/activities"] });
      toast({
        title: "Actividades movidas",
        description: `Se movieron ${data.count} actividades correctamente.`,
      });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudieron mover las actividades.",
        variant: "destructive",
      });
    },
  });

  // Create phase mapping for display
  const phaseMap = phases.reduce((acc, phase) => {
    acc[phase.id] = phase.name;
    return acc;
  }, {} as Record<number, string>);

  const filteredActivities = activities.filter((activity: Activity) => {
    const matchesSearch = activity.name.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesPhase = !selectedPhase || selectedPhase === "all" || activity.phaseId.toString() === selectedPhase;
    return matchesSearch && matchesPhase;
  });

  const handleEditPhase = (activity: Activity) => {
    setEditingActivity(activity);
    setNewPhaseId(activity.phaseId.toString());
  };

  const handleSavePhase = () => {
    if (!editingActivity || !newPhaseId) return;
    
    const phaseId = parseInt(newPhaseId);
    if (isNaN(phaseId)) {
      toast({
        title: "Error",
        description: "Por favor selecciona una fase válida.",
        variant: "destructive",
      });
      return;
    }

    updateActivityMutation.mutate({
      activityId: editingActivity.id,
      phaseId
    });
  };

  const getPhaseColor = (phaseId: number) => {
    const colors = {
      1: "bg-gray-100 text-gray-800",     // TRABAJOS PRELIMINARES
      2: "bg-orange-100 text-orange-800", // MOVIMIENTOS DE TIERRAS
      3: "bg-blue-100 text-blue-800",     // OBRA GRUESA
      4: "bg-green-100 text-green-800",   // OBRA FINA
      5: "bg-cyan-100 text-cyan-800",     // INSTALACIONES HIDROSANITARIAS
      6: "bg-yellow-100 text-yellow-800", // INSTALACIONES ELÉCTRICAS
      7: "bg-purple-100 text-purple-800", // TRABAJOS DE ACABADOS
      8: "bg-emerald-100 text-emerald-800", // JARDINES Y EXTERIORES
      9: "bg-indigo-100 text-indigo-800"    // VÍAS Y ACCESOS
    };
    return colors[phaseId] || "bg-gray-100 text-gray-800";
  };

  return (
    <div className="p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold">Gestión de Actividades</h1>
          <p className="text-gray-600 mt-2">
            Organiza las actividades por fases de construcción
          </p>
        </div>
        <Badge variant="outline" className="text-lg px-4 py-2">
          <Settings className="h-4 w-4 mr-2" />
          Administrador
        </Badge>
      </div>

      {/* Bulk Actions */}
      <Card>
        <CardHeader>
          <CardTitle>Acciones Masivas</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <label className="text-sm font-medium">Palabra clave</label>
              <Input placeholder="ej: baño, eléctrica..." />
            </div>
            <div>
              <label className="text-sm font-medium">Desde fase</label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="Seleccionar fase" />
                </SelectTrigger>
                <SelectContent>
                  {phases.map((phase) => (
                    <SelectItem key={phase.id} value={phase.id.toString()}>
                      {phase.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div>
              <label className="text-sm font-medium">Hacia fase</label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="Seleccionar fase" />
                </SelectTrigger>
                <SelectContent>
                  {phases.map((phase) => (
                    <SelectItem key={phase.id} value={phase.id.toString()}>
                      {phase.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="flex items-end">
              <Button 
                className="w-full"
                disabled={bulkMoveMutation.isPending}
              >
                {bulkMoveMutation.isPending && <RefreshCw className="h-4 w-4 mr-2 animate-spin" />}
                <Move className="h-4 w-4 mr-2" />
                Mover
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Filters */}
      <Card>
        <CardContent className="pt-6">
          <div className="flex gap-4 items-center">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
              <Input
                placeholder="Buscar actividades..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-10"
              />
            </div>
            <Select value={selectedPhase} onValueChange={setSelectedPhase}>
              <SelectTrigger className="w-64">
                <SelectValue placeholder="Todas las fases" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Todas las fases</SelectItem>
                {phases.map((phase) => (
                  <SelectItem key={phase.id} value={phase.id.toString()}>
                    {phase.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        </CardContent>
      </Card>

      {/* Activities Table */}
      <Card>
        <CardHeader>
          <CardTitle>Actividades ({filteredActivities.length})</CardTitle>
        </CardHeader>
        <CardContent>
          {activitiesLoading ? (
            <div className="flex items-center justify-center py-8">
              <RefreshCw className="h-8 w-8 animate-spin" />
            </div>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Actividad</TableHead>
                  <TableHead>Fase Actual</TableHead>
                  <TableHead>Unidad</TableHead>
                  <TableHead className="text-right">Precio Unitario</TableHead>
                  <TableHead className="text-center">Acciones</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredActivities.map((activity: Activity) => (
                  <TableRow key={activity.id}>
                    <TableCell>
                      <div className="font-medium">{activity.name}</div>
                    </TableCell>
                    <TableCell>
                      <Badge className={getPhaseColor(activity.phaseId)}>
                        {phaseMap[activity.phaseId] || 'Sin fase'}
                      </Badge>
                    </TableCell>
                    <TableCell>{activity.unit}</TableCell>
                    <TableCell className="text-right font-mono">
                      Bs. {typeof activity.unitPrice === 'number' ? activity.unitPrice.toFixed(2) : parseFloat(activity.unitPrice || '0').toFixed(2)}
                    </TableCell>
                    <TableCell className="text-center">
                      <Dialog>
                        <DialogTrigger asChild>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleEditPhase(activity)}
                          >
                            <Move className="h-4 w-4 mr-2" />
                            Cambiar Fase
                          </Button>
                        </DialogTrigger>
                        <DialogContent>
                          <DialogHeader>
                            <DialogTitle>Cambiar Fase de Actividad</DialogTitle>
                          </DialogHeader>
                          <div className="space-y-4">
                            <div>
                              <label className="text-sm font-medium">Actividad</label>
                              <p className="text-gray-600">{editingActivity?.name}</p>
                            </div>
                            <div>
                              <label className="text-sm font-medium">Fase Actual</label>
                              <p className="text-gray-600">{editingActivity && phaseMap[editingActivity.phaseId]}</p>
                            </div>
                            <div>
                              <label className="text-sm font-medium">Nueva Fase</label>
                              <Select value={newPhaseId} onValueChange={setNewPhaseId}>
                                <SelectTrigger>
                                  <SelectValue placeholder="Seleccionar nueva fase" />
                                </SelectTrigger>
                                <SelectContent>
                                  {phases.map((phase) => (
                                    <SelectItem key={phase.id} value={phase.id.toString()}>
                                      {phase.name}
                                    </SelectItem>
                                  ))}
                                </SelectContent>
                              </Select>
                            </div>
                            <div className="flex gap-2">
                              <Button
                                onClick={handleSavePhase}
                                disabled={updateActivityMutation.isPending}
                                className="flex-1"
                              >
                                {updateActivityMutation.isPending && (
                                  <RefreshCw className="h-4 w-4 mr-2 animate-spin" />
                                )}
                                <Save className="h-4 w-4 mr-2" />
                                Guardar
                              </Button>
                            </div>
                          </div>
                        </DialogContent>
                      </Dialog>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>
    </div>
  );
}