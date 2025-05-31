import { useState } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import { Plus, Search, Wrench, Package, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Separator } from "@/components/ui/separator";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useToast } from "@/hooks/use-toast";
import { queryClient, apiRequest } from "@/lib/queryClient";
import type { ActivityWithPhase, Material, ActivityComposition, InsertActivityComposition } from "@shared/schema";
import { formatCurrency } from "@/lib/utils";

const compositionFormSchema = z.object({
  activityId: z.number(),
  materialId: z.number().optional(),
  description: z.string().min(1, "La descripción es requerida"),
  unit: z.string().min(1, "La unidad es requerida"),
  quantity: z.string().min(1, "La cantidad es requerida"),
  unitCost: z.string().min(1, "El costo unitario es requerido"),
  type: z.enum(["material", "labor"]),
});

type CompositionFormData = z.infer<typeof compositionFormSchema>;

export default function ActivityCompositions() {
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedActivityId, setSelectedActivityId] = useState<number | null>(null);
  const [dialogOpen, setDialogOpen] = useState(false);
  const { toast } = useToast();

  const { data: activities, isLoading: activitiesLoading } = useQuery<ActivityWithPhase[]>({
    queryKey: ["/api/activities"],
  });

  const { data: materials } = useQuery<Material[]>({
    queryKey: ["/api/materials"],
  });

  const { data: compositions, isLoading: compositionsLoading } = useQuery<ActivityComposition[]>({
    queryKey: ["/api/activity-compositions"],
    enabled: !!selectedActivityId,
  });

  const form = useForm<CompositionFormData>({
    resolver: zodResolver(compositionFormSchema),
    defaultValues: {
      type: "material",
      quantity: "1",
      unitCost: "0",
    },
  });

  const createComposition = useMutation({
    mutationFn: async (data: CompositionFormData) => {
      const compositionData: InsertActivityComposition = {
        activityId: data.activityId,
        materialId: data.type === "material" ? data.materialId : undefined,
        description: data.description,
        unit: data.unit,
        quantity: data.quantity,
        unitCost: data.unitCost,
        type: data.type,
      };
      return await apiRequest("/api/activity-compositions", "POST", compositionData);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/activity-compositions"] });
      setDialogOpen(false);
      form.reset();
      toast({
        title: "Composición agregada",
        description: "La composición se ha agregado correctamente.",
      });
    },
    onError: (error: Error) => {
      toast({
        title: "Error",
        description: error.message,
        variant: "destructive",
      });
    },
  });

  const deleteComposition = useMutation({
    mutationFn: async (id: number) => {
      return await apiRequest(`/api/activity-compositions/${id}`, "DELETE");
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/activity-compositions"] });
      toast({
        title: "Composición eliminada",
        description: "La composición se ha eliminado correctamente.",
      });
    },
  });

  const filteredActivities = activities?.filter(activity =>
    activity.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    activity.phase.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const selectedActivity = activities?.find(a => a.id === selectedActivityId);

  const onSubmit = (data: CompositionFormData) => {
    if (!selectedActivityId) return;
    
    createComposition.mutate({
      ...data,
      activityId: selectedActivityId,
    });
  };

  const handleMaterialSelect = (materialId: string) => {
    const material = materials?.find(m => m.id === Number(materialId));
    if (material) {
      form.setValue("description", material.description || "");
      form.setValue("unit", material.unit);
      form.setValue("unitCost", material.price);
    }
  };

  return (
    <div className="container mx-auto p-6">
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Composiciones de Actividades</h1>
          <p className="text-gray-600 mt-2">Define los materiales y mano de obra para cada actividad</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Lista de Actividades */}
        <Card>
          <CardHeader>
            <CardTitle>Actividades</CardTitle>
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
              <Input
                placeholder="Buscar actividades..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-10"
              />
            </div>
          </CardHeader>
          <CardContent>
            {activitiesLoading ? (
              <div className="space-y-3">
                {Array.from({ length: 5 }).map((_, i) => (
                  <Skeleton key={i} className="h-12 w-full" />
                ))}
              </div>
            ) : (
              <div className="space-y-2">
                {filteredActivities?.map((activity) => (
                  <div
                    key={activity.id}
                    className={`p-3 border rounded-lg cursor-pointer transition-colors ${
                      selectedActivityId === activity.id
                        ? "border-blue-500 bg-blue-50"
                        : "hover:bg-gray-50"
                    }`}
                    onClick={() => setSelectedActivityId(activity.id)}
                  >
                    <div className="font-medium">{activity.name}</div>
                    <div className="text-sm text-gray-600">{activity.phase.name}</div>
                    <Badge variant="outline" className="mt-1">
                      {activity.unit}
                    </Badge>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Composiciones de la Actividad Seleccionada */}
        <Card>
          <CardHeader>
            <div className="flex justify-between items-center">
              <CardTitle>
                {selectedActivity ? `Composición: ${selectedActivity.name}` : "Selecciona una actividad"}
              </CardTitle>
              {selectedActivity && (
                <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
                  <DialogTrigger asChild>
                    <Button>
                      <Plus className="h-4 w-4 mr-2" />
                      Agregar
                    </Button>
                  </DialogTrigger>
                  <DialogContent className="max-w-md">
                    <DialogHeader>
                      <DialogTitle>Nueva Composición</DialogTitle>
                    </DialogHeader>
                    <Form {...form}>
                      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
                        <FormField
                          control={form.control}
                          name="type"
                          render={({ field }) => (
                            <FormItem>
                              <FormLabel>Tipo</FormLabel>
                              <Select onValueChange={field.onChange} defaultValue={field.value}>
                                <FormControl>
                                  <SelectTrigger>
                                    <SelectValue />
                                  </SelectTrigger>
                                </FormControl>
                                <SelectContent>
                                  <SelectItem value="material">Material</SelectItem>
                                  <SelectItem value="labor">Mano de Obra</SelectItem>
                                </SelectContent>
                              </Select>
                            </FormItem>
                          )}
                        />

                        {form.watch("type") === "material" && (
                          <FormField
                            control={form.control}
                            name="materialId"
                            render={({ field }) => (
                              <FormItem>
                                <FormLabel>Material</FormLabel>
                                <Select onValueChange={(value) => {
                                  field.onChange(Number(value));
                                  handleMaterialSelect(value);
                                }}>
                                  <FormControl>
                                    <SelectTrigger>
                                      <SelectValue placeholder="Seleccionar material" />
                                    </SelectTrigger>
                                  </FormControl>
                                  <SelectContent>
                                    {materials?.map((material) => (
                                      <SelectItem key={material.id} value={material.id.toString()}>
                                        {material.description}
                                      </SelectItem>
                                    ))}
                                  </SelectContent>
                                </Select>
                              </FormItem>
                            )}
                          />
                        )}

                        <FormField
                          control={form.control}
                          name="description"
                          render={({ field }) => (
                            <FormItem>
                              <FormLabel>Descripción</FormLabel>
                              <FormControl>
                                <Input {...field} placeholder="Descripción del elemento" />
                              </FormControl>
                              <FormMessage />
                            </FormItem>
                          )}
                        />

                        <div className="grid grid-cols-2 gap-4">
                          <FormField
                            control={form.control}
                            name="quantity"
                            render={({ field }) => (
                              <FormItem>
                                <FormLabel>Cantidad</FormLabel>
                                <FormControl>
                                  <Input {...field} type="number" step="0.0001" />
                                </FormControl>
                                <FormMessage />
                              </FormItem>
                            )}
                          />

                          <FormField
                            control={form.control}
                            name="unit"
                            render={({ field }) => (
                              <FormItem>
                                <FormLabel>Unidad</FormLabel>
                                <FormControl>
                                  <Input {...field} />
                                </FormControl>
                                <FormMessage />
                              </FormItem>
                            )}
                          />
                        </div>

                        <FormField
                          control={form.control}
                          name="unitCost"
                          render={({ field }) => (
                            <FormItem>
                              <FormLabel>Costo Unitario (Bs)</FormLabel>
                              <FormControl>
                                <Input {...field} type="number" step="0.01" />
                              </FormControl>
                              <FormMessage />
                            </FormItem>
                          )}
                        />

                        <div className="flex justify-end space-x-2">
                          <Button type="button" variant="outline" onClick={() => setDialogOpen(false)}>
                            Cancelar
                          </Button>
                          <Button type="submit" disabled={createComposition.isPending}>
                            {createComposition.isPending ? "Guardando..." : "Guardar"}
                          </Button>
                        </div>
                      </form>
                    </Form>
                  </DialogContent>
                </Dialog>
              )}
            </div>
          </CardHeader>
          <CardContent>
            {!selectedActivity ? (
              <div className="text-center py-8 text-gray-500">
                Selecciona una actividad para ver su composición
              </div>
            ) : compositionsLoading ? (
              <div className="space-y-3">
                {Array.from({ length: 3 }).map((_, i) => (
                  <Skeleton key={i} className="h-16 w-full" />
                ))}
              </div>
            ) : (
              <div className="space-y-3">
                {compositions?.map((composition) => (
                  <div key={composition.id} className="p-3 border rounded-lg">
                    <div className="flex justify-between items-start">
                      <div className="flex-1">
                        <div className="flex items-center gap-2">
                          {composition.type === "material" ? (
                            <Package className="h-4 w-4 text-blue-600" />
                          ) : (
                            <Wrench className="h-4 w-4 text-green-600" />
                          )}
                          <span className="font-medium">{composition.description}</span>
                        </div>
                        <div className="text-sm text-gray-600 mt-1">
                          {composition.quantity} {composition.unit} × {formatCurrency(Number(composition.unitCost))}
                        </div>
                        <div className="text-sm font-medium text-gray-900">
                          Total: {formatCurrency(Number(composition.quantity) * Number(composition.unitCost))}
                        </div>
                      </div>
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => deleteComposition.mutate(composition.id)}
                        disabled={deleteComposition.isPending}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>
                  </div>
                ))}
                
                {compositions?.length === 0 && (
                  <div className="text-center py-8 text-gray-500">
                    No hay composiciones definidas para esta actividad
                  </div>
                )}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}