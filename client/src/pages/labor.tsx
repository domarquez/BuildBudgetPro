import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { apiRequest } from "@/lib/queryClient";
import { useAuth } from "@/hooks/useAuth";
import { useToast } from "@/hooks/use-toast";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Users, Star, Clock, Pencil, Check, X } from "lucide-react";

interface LaborCategory {
  id: number;
  name: string;
  description: string;
  unit: string;
  hourlyRate: string;
  skillLevel: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export default function Labor() {
  const { user } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editingRate, setEditingRate] = useState("");

  const { data: laborCategories = [], isLoading } = useQuery<LaborCategory[]>({
    queryKey: ["/api/labor-categories"],
  });

  const updateMutation = useMutation({
    mutationFn: async ({ id, hourlyRate }: { id: number; hourlyRate: string }) => {
      return await apiRequest("PUT", `/api/labor-categories/${id}`, { hourlyRate });
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/labor-categories"] });
      setEditingId(null);
      setEditingRate("");
      toast({
        title: "Tarifa actualizada",
        description: "La tarifa horaria se ha actualizado correctamente.",
      });
    },
    onError: (error: any) => {
      toast({
        title: "Error",
        description: error.message || "Error al actualizar la tarifa",
        variant: "destructive",
      });
    },
  });

  const handleEdit = (labor: LaborCategory) => {
    setEditingId(labor.id);
    setEditingRate(labor.hourlyRate);
  };

  const handleSave = () => {
    if (editingId && editingRate) {
      updateMutation.mutate({ id: editingId, hourlyRate: editingRate });
    }
  };

  const handleCancel = () => {
    setEditingId(null);
    setEditingRate("");
  };

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin w-8 h-8 border-4 border-primary border-t-transparent rounded-full" />
      </div>
    );
  }

  const formatPrice = (price: string) => {
    return new Intl.NumberFormat('es-BO', {
      style: 'currency',
      currency: 'BOB',
      minimumFractionDigits: 2
    }).format(parseFloat(price));
  };

  const getSkillBadgeVariant = (skillLevel: string) => {
    switch (skillLevel) {
      case 'specialist':
        return 'destructive';
      case 'skilled':
        return 'secondary';
      case 'basic':
        return 'outline';
      default:
        return 'outline';
    }
  };

  const getSkillLabel = (skillLevel: string) => {
    switch (skillLevel) {
      case 'specialist':
        return 'Especialista';
      case 'skilled':
        return 'Calificado';
      case 'basic':
        return 'Básico';
      default:
        return skillLevel;
    }
  };

  const getLaborIcon = (name: string) => {
    const lowerName = name.toLowerCase();
    if (lowerName.includes('especialista') || lowerName.includes('plomero') || lowerName.includes('electricista')) {
      return '👨‍🔧';
    } else if (lowerName.includes('albañil') || lowerName.includes('encofrador') || lowerName.includes('armador')) {
      return '👷‍♂️';
    } else if (lowerName.includes('carpintero')) {
      return '👨‍🔨';
    } else {
      return '👷';
    }
  };

  const specialists = laborCategories.filter(labor => labor.skillLevel === 'specialist');
  const skilled = laborCategories.filter(labor => labor.skillLevel === 'skilled');
  const basic = laborCategories.filter(labor => labor.skillLevel === 'basic');

  const averageRate = laborCategories.length > 0 
    ? laborCategories.reduce((sum, labor) => sum + parseFloat(labor.hourlyRate), 0) / laborCategories.length
    : 0;

  return (
    <div className="container mx-auto py-8 px-4">
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-4">
          <Users className="h-8 w-8 text-primary" />
          <div>
            <h1 className="text-3xl font-bold">Mano de Obra</h1>
            <p className="text-muted-foreground">
              Categorías de mano de obra con tarifas horarias para construcción en Bolivia
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Total Categorías</p>
                  <p className="text-2xl font-bold">{laborCategories.length}</p>
                </div>
                <Users className="h-4 w-4 text-muted-foreground" />
              </div>
            </CardContent>
          </Card>
          
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Especialistas</p>
                  <p className="text-2xl font-bold">{specialists.length}</p>
                </div>
                <Star className="h-4 w-4 text-muted-foreground" />
              </div>
            </CardContent>
          </Card>
          
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Calificados</p>
                  <p className="text-2xl font-bold">{skilled.length}</p>
                </div>
                <Clock className="h-4 w-4 text-muted-foreground" />
              </div>
            </CardContent>
          </Card>
          
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Tarifa Promedio</p>
                  <p className="text-2xl font-bold">{formatPrice(averageRate.toString())}</p>
                </div>
                <Clock className="h-4 w-4 text-muted-foreground" />
              </div>
            </CardContent>
          </Card>
        </div>
      </div>

      <div className="space-y-8">
        {/* Especialistas */}
        {specialists.length > 0 && (
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                👨‍🔧 Especialistas
                <Badge variant="destructive">{specialists.length}</Badge>
              </CardTitle>
              <CardDescription>
                Mano de obra altamente especializada con certificaciones específicas
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Categoría</TableHead>
                    <TableHead>Descripción</TableHead>
                    <TableHead>Nivel</TableHead>
                    <TableHead>Unidad</TableHead>
                    <TableHead className="text-right">Tarifa Horaria</TableHead>
                    {user?.role === "admin" && <TableHead className="text-right">Acciones</TableHead>}
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {specialists.map((labor) => (
                    <TableRow key={labor.id}>
                      <TableCell className="font-medium">
                        <div className="flex items-center gap-2">
                          <span className="text-lg">{getLaborIcon(labor.name)}</span>
                          {labor.name}
                        </div>
                      </TableCell>
                      <TableCell className="text-muted-foreground">{labor.description}</TableCell>
                      <TableCell>
                        <Badge variant={getSkillBadgeVariant(labor.skillLevel)}>
                          {getSkillLabel(labor.skillLevel)}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline">{labor.unit}</Badge>
                      </TableCell>
                      <TableCell className="text-right font-semibold text-red-600">
                        {editingId === labor.id ? (
                          <div className="flex items-center gap-2 justify-end">
                            <Input
                              type="number"
                              step="0.01"
                              value={editingRate}
                              onChange={(e) => setEditingRate(e.target.value)}
                              className="w-24 h-8"
                            />
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={handleSave}
                              disabled={updateMutation.isPending}
                            >
                              <Check className="w-4 h-4" />
                            </Button>
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={handleCancel}
                            >
                              <X className="w-4 h-4" />
                            </Button>
                          </div>
                        ) : (
                          formatPrice(labor.hourlyRate)
                        )}
                      </TableCell>
                      {user?.role === "admin" && (
                        <TableCell className="text-right">
                          {editingId !== labor.id && (
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => handleEdit(labor)}
                            >
                              <Pencil className="w-4 h-4" />
                            </Button>
                          )}
                        </TableCell>
                      )}
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        )}

        {/* Calificados */}
        {skilled.length > 0 && (
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                👷‍♂️ Mano de Obra Calificada
                <Badge variant="secondary">{skilled.length}</Badge>
              </CardTitle>
              <CardDescription>
                Trabajadores con experiencia y habilidades técnicas comprobadas
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Categoría</TableHead>
                    <TableHead>Descripción</TableHead>
                    <TableHead>Nivel</TableHead>
                    <TableHead>Unidad</TableHead>
                    <TableHead className="text-right">Tarifa Horaria</TableHead>
                    {user?.role === "admin" && <TableHead className="text-right">Acciones</TableHead>}
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {skilled.map((labor) => (
                    <TableRow key={labor.id}>
                      <TableCell className="font-medium">
                        <div className="flex items-center gap-2">
                          <span className="text-lg">{getLaborIcon(labor.name)}</span>
                          {labor.name}
                        </div>
                      </TableCell>
                      <TableCell className="text-muted-foreground">{labor.description}</TableCell>
                      <TableCell>
                        <Badge variant={getSkillBadgeVariant(labor.skillLevel)}>
                          {getSkillLabel(labor.skillLevel)}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline">{labor.unit}</Badge>
                      </TableCell>
                      <TableCell className="text-right font-semibold text-orange-600">
                        {editingId === labor.id ? (
                          <div className="flex items-center gap-2 justify-end">
                            <Input
                              type="number"
                              step="0.01"
                              value={editingRate}
                              onChange={(e) => setEditingRate(e.target.value)}
                              className="w-24 h-8"
                            />
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={handleSave}
                              disabled={updateMutation.isPending}
                            >
                              <Check className="w-4 h-4" />
                            </Button>
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={handleCancel}
                            >
                              <X className="w-4 h-4" />
                            </Button>
                          </div>
                        ) : (
                          formatPrice(labor.hourlyRate)
                        )}
                      </TableCell>
                      {user?.role === "admin" && (
                        <TableCell className="text-right">
                          {editingId !== labor.id && (
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => handleEdit(labor)}
                            >
                              <Pencil className="w-4 h-4" />
                            </Button>
                          )}
                        </TableCell>
                      )}
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        )}

        {/* Básicos */}
        {basic.length > 0 && (
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                👷 Mano de Obra Básica
                <Badge variant="outline">{basic.length}</Badge>
              </CardTitle>
              <CardDescription>
                Trabajadores de apoyo y tareas generales de construcción
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Categoría</TableHead>
                    <TableHead>Descripción</TableHead>
                    <TableHead>Nivel</TableHead>
                    <TableHead>Unidad</TableHead>
                    <TableHead className="text-right">Tarifa Horaria</TableHead>
                    {user?.role === "admin" && <TableHead className="text-right">Acciones</TableHead>}
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {basic.map((labor) => (
                    <TableRow key={labor.id}>
                      <TableCell className="font-medium">
                        <div className="flex items-center gap-2">
                          <span className="text-lg">{getLaborIcon(labor.name)}</span>
                          {labor.name}
                        </div>
                      </TableCell>
                      <TableCell className="text-muted-foreground">{labor.description}</TableCell>
                      <TableCell>
                        <Badge variant={getSkillBadgeVariant(labor.skillLevel)}>
                          {getSkillLabel(labor.skillLevel)}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <Badge variant="outline">{labor.unit}</Badge>
                      </TableCell>
                      <TableCell className="text-right font-semibold text-green-600">
                        {editingId === labor.id ? (
                          <div className="flex items-center gap-2 justify-end">
                            <Input
                              type="number"
                              step="0.01"
                              value={editingRate}
                              onChange={(e) => setEditingRate(e.target.value)}
                              className="w-24 h-8"
                            />
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={handleSave}
                              disabled={updateMutation.isPending}
                            >
                              <Check className="w-4 h-4" />
                            </Button>
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={handleCancel}
                            >
                              <X className="w-4 h-4" />
                            </Button>
                          </div>
                        ) : (
                          formatPrice(labor.hourlyRate)
                        )}
                      </TableCell>
                      {user?.role === "admin" && (
                        <TableCell className="text-right">
                          {editingId !== labor.id && (
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => handleEdit(labor)}
                            >
                              <Pencil className="w-4 h-4" />
                            </Button>
                          )}
                        </TableCell>
                      )}
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  );
}