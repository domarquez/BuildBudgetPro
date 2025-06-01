import { useState } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { useToast } from "@/hooks/use-toast";
import { apiRequest, queryClient } from "@/lib/queryClient";
import { Plus, Edit, Trash2, MapPin } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";

interface CityPriceFactor {
  id: number;
  city: string;
  country: string;
  materialsFormatted: string;
  laborFormatted: string;
  equipmentFormatted: string;
  transportFormatted: string;
  description: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

interface CityFactorFormData {
  city: string;
  country: string;
  materialsFormatted: string;
  laborFormatted: string;
  equipmentFormatted: string;
  transportFormatted: string;
  description: string;
}

export default function CityFactors() {
  const { toast } = useToast();
  const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false);
  const [editingFactor, setEditingFactor] = useState<CityPriceFactor | null>(null);
  const [formData, setFormData] = useState<CityFactorFormData>({
    city: "",
    country: "Bolivia",
    materialsFormatted: "1.00",
    laborFormatted: "1.00",
    equipmentFormatted: "1.00",
    transportFormatted: "1.00",
    description: "",
  });

  const { data: factors = [], isLoading } = useQuery({
    queryKey: ["/api/city-price-factors"],
  });

  const createMutation = useMutation({
    mutationFn: async (data: CityFactorFormData) => {
      const { materialsFormatted, laborFormatted, equipmentFormatted, transportFormatted, ...rest } = data;
      const payload = {
        ...rest,
        materialsFactor: parseFloat(materialsFormatted),
        laborFactor: parseFloat(laborFormatted),
        equipmentFactor: parseFloat(equipmentFormatted),
        transportFactor: parseFloat(transportFormatted),
      };
      return apiRequest("/api/city-price-factors", "POST", payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/city-price-factors"] });
      setIsCreateDialogOpen(false);
      resetForm();
      toast({
        title: "Factor de precios creado",
        description: "El factor de precios por ciudad se ha creado exitosamente.",
      });
    },
    onError: (error) => {
      toast({
        title: "Error",
        description: "No se pudo crear el factor de precios.",
        variant: "destructive",
      });
    },
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, data }: { id: number; data: CityFactorFormData }) => {
      const payload = {
        ...data,
        materialsFactor: parseFloat(data.materialsFormatted),
        laborFactor: parseFloat(data.laborFormatted),
        equipmentFactor: parseFloat(data.equipmentFormatted),
        transportFactor: parseFloat(data.transportFormatted),
      };
      delete payload.materialsFormatted;
      delete payload.laborFormatted;
      delete payload.equipmentFormatted;
      delete payload.transportFormatted;
      return apiRequest(`/api/city-price-factors/${id}`, "PATCH", payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/city-price-factors"] });
      setEditingFactor(null);
      resetForm();
      toast({
        title: "Factor de precios actualizado",
        description: "El factor de precios por ciudad se ha actualizado exitosamente.",
      });
    },
    onError: (error) => {
      toast({
        title: "Error",
        description: "No se pudo actualizar el factor de precios.",
        variant: "destructive",
      });
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      return apiRequest(`/api/city-price-factors/${id}`, "DELETE");
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/city-price-factors"] });
      toast({
        title: "Factor de precios eliminado",
        description: "El factor de precios por ciudad se ha eliminado exitosamente.",
      });
    },
    onError: (error) => {
      toast({
        title: "Error",
        description: "No se pudo eliminar el factor de precios.",
        variant: "destructive",
      });
    },
  });

  const resetForm = () => {
    setFormData({
      city: "",
      country: "Bolivia",
      materialsFormatted: "1.00",
      laborFormatted: "1.00",
      equipmentFormatted: "1.00",
      transportFormatted: "1.00",
      description: "",
    });
  };

  const handleEdit = (factor: CityPriceFactor) => {
    setEditingFactor(factor);
    setFormData({
      city: factor.city,
      country: factor.country,
      materialsFormatted: factor.materialsFormatted,
      laborFormatted: factor.laborFormatted,
      equipmentFormatted: factor.equipmentFormatted,
      transportFormatted: factor.transportFormatted,
      description: factor.description,
    });
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (editingFactor) {
      updateMutation.mutate({ id: editingFactor.id, data: formData });
    } else {
      createMutation.mutate(formData);
    }
  };

  const getFactorColor = (factor: string) => {
    const value = parseFloat(factor);
    if (value > 1.1) return "bg-red-100 text-red-800";
    if (value < 0.95) return "bg-green-100 text-green-800";
    return "bg-blue-100 text-blue-800";
  };

  if (isLoading) {
    return (
      <div className="container mx-auto p-6">
        <div className="flex items-center justify-center h-64">
          <div className="text-lg">Cargando factores de precios...</div>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto p-6">
      <div className="flex justify-between items-center mb-6">
        <div>
          <h1 className="text-3xl font-bold">Factores de Precios por Ciudad</h1>
          <p className="text-muted-foreground mt-2">
            Gestiona los factores de ajuste de precios según la ubicación geográfica
          </p>
        </div>
        
        <Dialog open={isCreateDialogOpen} onOpenChange={setIsCreateDialogOpen}>
          <DialogTrigger asChild>
            <Button onClick={resetForm}>
              <Plus className="h-4 w-4 mr-2" />
              Nuevo Factor
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[600px]">
            <DialogHeader>
              <DialogTitle>Crear Factor de Precios</DialogTitle>
              <DialogDescription>
                Define los factores de ajuste de precios para una nueva ciudad
              </DialogDescription>
            </DialogHeader>
            <form onSubmit={handleSubmit}>
              <div className="grid gap-4 py-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label htmlFor="city">Ciudad</Label>
                    <Input
                      id="city"
                      value={formData.city}
                      onChange={(e) => setFormData({ ...formData, city: e.target.value })}
                      placeholder="Nombre de la ciudad"
                      required
                    />
                  </div>
                  <div>
                    <Label htmlFor="country">País</Label>
                    <Input
                      id="country"
                      value={formData.country}
                      onChange={(e) => setFormData({ ...formData, country: e.target.value })}
                      placeholder="País"
                      required
                    />
                  </div>
                </div>
                
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label htmlFor="materialsFormatted">Factor Materiales</Label>
                    <Input
                      id="materialsFormatted"
                      type="number"
                      step="0.01"
                      min="0.1"
                      max="5.0"
                      value={formData.materialsFormatted}
                      onChange={(e) => setFormData({ ...formData, materialsFormatted: e.target.value })}
                      placeholder="1.00"
                      required
                    />
                  </div>
                  <div>
                    <Label htmlFor="laborFormatted">Factor Mano de Obra</Label>
                    <Input
                      id="laborFormatted"
                      type="number"
                      step="0.01"
                      min="0.1"
                      max="5.0"
                      value={formData.laborFormatted}
                      onChange={(e) => setFormData({ ...formData, laborFormatted: e.target.value })}
                      placeholder="1.00"
                      required
                    />
                  </div>
                </div>
                
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label htmlFor="equipmentFormatted">Factor Equipos</Label>
                    <Input
                      id="equipmentFormatted"
                      type="number"
                      step="0.01"
                      min="0.1"
                      max="5.0"
                      value={formData.equipmentFormatted}
                      onChange={(e) => setFormData({ ...formData, equipmentFormatted: e.target.value })}
                      placeholder="1.00"
                      required
                    />
                  </div>
                  <div>
                    <Label htmlFor="transportFormatted">Factor Transporte</Label>
                    <Input
                      id="transportFormatted"
                      type="number"
                      step="0.01"
                      min="0.1"
                      max="5.0"
                      value={formData.transportFormatted}
                      onChange={(e) => setFormData({ ...formData, transportFormatted: e.target.value })}
                      placeholder="1.00"
                      required
                    />
                  </div>
                </div>
                
                <div>
                  <Label htmlFor="description">Descripción</Label>
                  <Textarea
                    id="description"
                    value={formData.description}
                    onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                    placeholder="Descripción de los factores aplicados..."
                    rows={3}
                  />
                </div>
              </div>
              <DialogFooter>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => {
                    setIsCreateDialogOpen(false);
                    resetForm();
                  }}
                >
                  Cancelar
                </Button>
                <Button type="submit" disabled={createMutation.isPending}>
                  {createMutation.isPending ? "Creando..." : "Crear Factor"}
                </Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="grid gap-6">
        {factors.map((factor: CityPriceFactor) => (
          <Card key={factor.id}>
            <CardHeader>
              <div className="flex justify-between items-start">
                <div className="flex items-center gap-2">
                  <MapPin className="h-5 w-5 text-muted-foreground" />
                  <CardTitle>{factor.city}, {factor.country}</CardTitle>
                </div>
                <div className="flex gap-2">
                  <Dialog 
                    open={editingFactor?.id === factor.id} 
                    onOpenChange={(open) => {
                      if (!open) {
                        setEditingFactor(null);
                        resetForm();
                      }
                    }}
                  >
                    <DialogTrigger asChild>
                      <Button variant="outline" size="sm" onClick={() => handleEdit(factor)}>
                        <Edit className="h-4 w-4" />
                      </Button>
                    </DialogTrigger>
                    <DialogContent className="sm:max-w-[600px]">
                      <DialogHeader>
                        <DialogTitle>Editar Factor de Precios</DialogTitle>
                        <DialogDescription>
                          Modifica los factores de ajuste para {factor.city}
                        </DialogDescription>
                      </DialogHeader>
                      <form onSubmit={handleSubmit}>
                        <div className="grid gap-4 py-4">
                          <div className="grid grid-cols-2 gap-4">
                            <div>
                              <Label htmlFor="edit-city">Ciudad</Label>
                              <Input
                                id="edit-city"
                                value={formData.city}
                                onChange={(e) => setFormData({ ...formData, city: e.target.value })}
                                required
                              />
                            </div>
                            <div>
                              <Label htmlFor="edit-country">País</Label>
                              <Input
                                id="edit-country"
                                value={formData.country}
                                onChange={(e) => setFormData({ ...formData, country: e.target.value })}
                                required
                              />
                            </div>
                          </div>
                          
                          <div className="grid grid-cols-2 gap-4">
                            <div>
                              <Label htmlFor="edit-materials">Factor Materiales</Label>
                              <Input
                                id="edit-materials"
                                type="number"
                                step="0.01"
                                min="0.1"
                                max="5.0"
                                value={formData.materialsFormatted}
                                onChange={(e) => setFormData({ ...formData, materialsFormatted: e.target.value })}
                                required
                              />
                            </div>
                            <div>
                              <Label htmlFor="edit-labor">Factor Mano de Obra</Label>
                              <Input
                                id="edit-labor"
                                type="number"
                                step="0.01"
                                min="0.1"
                                max="5.0"
                                value={formData.laborFormatted}
                                onChange={(e) => setFormData({ ...formData, laborFormatted: e.target.value })}
                                required
                              />
                            </div>
                          </div>
                          
                          <div className="grid grid-cols-2 gap-4">
                            <div>
                              <Label htmlFor="edit-equipment">Factor Equipos</Label>
                              <Input
                                id="edit-equipment"
                                type="number"
                                step="0.01"
                                min="0.1"
                                max="5.0"
                                value={formData.equipmentFormatted}
                                onChange={(e) => setFormData({ ...formData, equipmentFormatted: e.target.value })}
                                required
                              />
                            </div>
                            <div>
                              <Label htmlFor="edit-transport">Factor Transporte</Label>
                              <Input
                                id="edit-transport"
                                type="number"
                                step="0.01"
                                min="0.1"
                                max="5.0"
                                value={formData.transportFormatted}
                                onChange={(e) => setFormData({ ...formData, transportFormatted: e.target.value })}
                                required
                              />
                            </div>
                          </div>
                          
                          <div>
                            <Label htmlFor="edit-description">Descripción</Label>
                            <Textarea
                              id="edit-description"
                              value={formData.description}
                              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                              rows={3}
                            />
                          </div>
                        </div>
                        <DialogFooter>
                          <Button
                            type="button"
                            variant="outline"
                            onClick={() => {
                              setEditingFactor(null);
                              resetForm();
                            }}
                          >
                            Cancelar
                          </Button>
                          <Button type="submit" disabled={updateMutation.isPending}>
                            {updateMutation.isPending ? "Actualizando..." : "Actualizar"}
                          </Button>
                        </DialogFooter>
                      </form>
                    </DialogContent>
                  </Dialog>

                  <AlertDialog>
                    <AlertDialogTrigger asChild>
                      <Button variant="outline" size="sm">
                        <Trash2 className="h-4 w-4 text-red-500" />
                      </Button>
                    </AlertDialogTrigger>
                    <AlertDialogContent>
                      <AlertDialogHeader>
                        <AlertDialogTitle>¿Eliminar factor de precios?</AlertDialogTitle>
                        <AlertDialogDescription>
                          Esta acción eliminará el factor de precios para {factor.city}. 
                          Esta acción no se puede deshacer.
                        </AlertDialogDescription>
                      </AlertDialogHeader>
                      <AlertDialogFooter>
                        <AlertDialogCancel>Cancelar</AlertDialogCancel>
                        <AlertDialogAction
                          onClick={() => deleteMutation.mutate(factor.id)}
                          className="bg-red-600 hover:bg-red-700"
                        >
                          Eliminar
                        </AlertDialogAction>
                      </AlertDialogFooter>
                    </AlertDialogContent>
                  </AlertDialog>
                </div>
              </div>
              <CardDescription>{factor.description}</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div className="text-center">
                  <div className="text-sm text-muted-foreground mb-1">Materiales</div>
                  <Badge className={getFactorColor(factor.materialsFormatted)}>
                    {factor.materialsFormatted}
                  </Badge>
                </div>
                <div className="text-center">
                  <div className="text-sm text-muted-foreground mb-1">Mano de Obra</div>
                  <Badge className={getFactorColor(factor.laborFormatted)}>
                    {factor.laborFormatted}
                  </Badge>
                </div>
                <div className="text-center">
                  <div className="text-sm text-muted-foreground mb-1">Equipos</div>
                  <Badge className={getFactorColor(factor.equipmentFormatted)}>
                    {factor.equipmentFormatted}
                  </Badge>
                </div>
                <div className="text-center">
                  <div className="text-sm text-muted-foreground mb-1">Transporte</div>
                  <Badge className={getFactorColor(factor.transportFormatted)}>
                    {factor.transportFormatted}
                  </Badge>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {factors.length === 0 && (
        <Card>
          <CardContent className="text-center py-12">
            <MapPin className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
            <h3 className="text-lg font-medium mb-2">No hay factores de precios configurados</h3>
            <p className="text-muted-foreground mb-4">
              Crea el primer factor de precios para comenzar a gestionar ajustes por ubicación
            </p>
            <Button onClick={() => setIsCreateDialogOpen(true)}>
              <Plus className="h-4 w-4 mr-2" />
              Crear Factor
            </Button>
          </CardContent>
        </Card>
      )}
    </div>
  );
}