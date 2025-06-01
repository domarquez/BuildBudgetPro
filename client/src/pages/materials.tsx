import { useState } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
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
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Skeleton } from "@/components/ui/skeleton";
import { useToast } from "@/hooks/use-toast";
import { 
  Search, 
  Plus, 
  Upload, 
  Edit, 
  Trash2, 
  Package,
  Hammer,
  Palette,
  User,
  RotateCcw,
  AlertCircle
} from "lucide-react";
import { formatCurrency, formatRelativeTime, debounce } from "@/lib/utils";
import { queryClient } from "@/lib/queryClient";
import MaterialForm from "@/components/materials/material-form";
import type { MaterialWithCategory, MaterialWithCustomPrice, MaterialCategory } from "@shared/schema";

export default function Materials() {
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<string>("all");
  const [showForm, setShowForm] = useState(false);
  const [editingMaterial, setEditingMaterial] = useState<MaterialWithCategory | null>(null);
  const [customizingMaterial, setCustomizingMaterial] = useState<MaterialWithCustomPrice | null>(null);
  const [newCustomPrice, setNewCustomPrice] = useState("");
  const { toast } = useToast();

  // Debounced search
  const debouncedSearch = debounce((query: string) => {
    refetchMaterials();
  }, 300);

  const { data: categories, isLoading: categoriesLoading } = useQuery<MaterialCategory[]>({
    queryKey: ["/api/material-categories"],
  });

  const { 
    data: materials, 
    isLoading: materialsLoading,
    refetch: refetchMaterials 
  } = useQuery<MaterialWithCustomPrice[]>({
    queryKey: [
      "/api/materials", 
      { 
        search: searchQuery.length > 0 ? searchQuery : undefined,
        categoryId: selectedCategory && selectedCategory !== "all" ? selectedCategory : undefined 
      }
    ],
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      const response = await fetch(`/api/materials/${id}`, {
        method: 'DELETE',
      });
      if (!response.ok) {
        throw new Error('Failed to delete material');
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/materials"] });
      toast({
        title: "Material eliminado",
        description: "El material ha sido eliminado correctamente.",
      });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo eliminar el material.",
        variant: "destructive",
      });
    },
  });

  const customPriceMutation = useMutation({
    mutationFn: async ({ materialId, customPrice, reason }: { materialId: number, customPrice: number, reason?: string }) => {
      const response = await fetch(`/api/materials/${materialId}/custom-price`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ customPrice, reason }),
      });
      if (!response.ok) {
        throw new Error('Failed to save custom price');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/materials"] });
      toast({
        title: "Precio personalizado guardado",
        description: "Tu precio personalizado ha sido guardado. Solo tu lo verás en tus proyectos.",
      });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo guardar el precio personalizado.",
        variant: "destructive",
      });
    },
  });

  const removeCustomPriceMutation = useMutation({
    mutationFn: async (materialId: number) => {
      const response = await fetch(`/api/materials/${materialId}/custom-price`, {
        method: 'DELETE',
      });
      if (!response.ok) {
        throw new Error('Failed to remove custom price');
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/materials"] });
      toast({
        title: "Precio restaurado",
        description: "Se ha restaurado el precio original del sistema.",
      });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo restaurar el precio original.",
        variant: "destructive",
      });
    },
  });

  const handleSearch = (value: string) => {
    setSearchQuery(value);
    debouncedSearch(value);
  };

  const handleCategoryChange = (value: string) => {
    setSelectedCategory(value);
    refetchMaterials();
  };

  const handleEdit = (material: MaterialWithCategory) => {
    setEditingMaterial(material);
    setShowForm(true);
  };

  const handleDelete = (id: number) => {
    if (confirm("¿Está seguro de que desea eliminar este material?")) {
      deleteMutation.mutate(id);
    }
  };

  const handleFormClose = () => {
    setShowForm(false);
    setEditingMaterial(null);
  };

  // Import materials mutation
  const importMutation = useMutation({
    mutationFn: async () => {
      return await fetch('/api/import-materials', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
      }).then(res => res.json());
    },
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ["/api/materials"] });
      queryClient.invalidateQueries({ queryKey: ["/api/statistics"] });
      toast({
        title: "Importación completada",
        description: `Se importaron ${data.totalInserted} materiales correctamente.`,
      });
    },
    onError: () => {
      toast({
        title: "Error en importación",
        description: "No se pudieron importar los materiales.",
        variant: "destructive",
      });
    },
  });

  const handleImport = () => {
    if (confirm("¿Está seguro de que desea importar todos los materiales del archivo SQL? Esto puede tomar varios minutos.")) {
      importMutation.mutate();
    }
  };

  const handleCustomizePrice = (material: MaterialWithCustomPrice) => {
    setCustomizingMaterial(material);
    setNewCustomPrice(material.price.toString());
  };

  const handleSaveCustomPrice = () => {
    if (customizingMaterial && newCustomPrice) {
      const price = parseFloat(newCustomPrice);
      if (price > 0) {
        customPriceMutation.mutate({
          materialId: customizingMaterial.id,
          customPrice: price,
          reason: "Precio personalizado por el usuario"
        });
        setCustomizingMaterial(null);
        setNewCustomPrice("");
      }
    }
  };

  const handleRestorePrice = (materialId: number) => {
    if (confirm("¿Está seguro de que desea restaurar el precio original del sistema?")) {
      removeCustomPriceMutation.mutate(materialId);
    }
  };

  const getIconForCategory = (categoryName: string) => {
    if (categoryName.toLowerCase().includes('pintura')) return Palette;
    if (categoryName.toLowerCase().includes('acero') || categoryName.toLowerCase().includes('hierro')) return Hammer;
    return Package;
  };

  return (
    <div className="p-6 space-y-6">
      {/* Materials Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center space-y-4 sm:space-y-0">
        <div>
          <h2 className="text-2xl font-bold text-on-surface">Gestión de Materiales</h2>
          <p className="text-gray-600">Administrar materiales y precios</p>
        </div>
        <div className="flex space-x-3">
          <Button
            variant="outline"
            className="bg-secondary text-white hover:bg-secondary-variant"
            onClick={handleImport}
            disabled={importMutation.isPending}
          >
            <Upload className="w-4 h-4 mr-2" />
            {importMutation.isPending ? 'Importando...' : 'Importar Archivo SQL'}
          </Button>
          <Button
            onClick={() => setShowForm(true)}
            className="bg-primary text-white hover:bg-primary-variant"
          >
            <Plus className="w-4 h-4 mr-2" />
            Agregar Material
          </Button>
        </div>
      </div>

      {/* Custom Pricing Warning */}
      <div className="bg-amber-50 dark:bg-amber-950 border border-amber-200 dark:border-amber-800 rounded-lg p-4">
        <div className="flex items-start space-x-3">
          <AlertCircle className="w-5 h-5 text-amber-600 dark:text-amber-400 mt-0.5 flex-shrink-0" />
          <div>
            <h3 className="text-sm font-medium text-amber-800 dark:text-amber-200">
              Precios Personalizados
            </h3>
            <p className="text-sm text-amber-700 dark:text-amber-300 mt-1">
              Los precios que modifiques aquí son privados y solo los verás en tus proyectos. 
              Otros usuarios seguirán viendo los precios originales del sistema. 
              Los materiales con precios personalizados aparecen marcados con <User className="w-4 h-4 inline mx-1" />.
            </p>
          </div>
        </div>
      </div>

      {/* Search and Filters */}
      <Card className="shadow-material">
        <CardContent className="p-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <Label htmlFor="search" className="block text-sm font-medium text-gray-700 mb-2">
                Buscar Material
              </Label>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                <Input
                  id="search"
                  type="text"
                  placeholder="Nombre del material..."
                  value={searchQuery}
                  onChange={(e) => handleSearch(e.target.value)}
                  className="pl-10"
                />
              </div>
            </div>
            <div>
              <Label className="block text-sm font-medium text-gray-700 mb-2">
                Categoría
              </Label>
              <Select value={selectedCategory} onValueChange={handleCategoryChange}>
                <SelectTrigger>
                  <SelectValue placeholder="Todas las categorías" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todas las categorías</SelectItem>
                  {categories?.map((category) => (
                    <SelectItem key={category.id} value={category.id.toString()}>
                      {category.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="flex items-end">
              <Button
                onClick={() => refetchMaterials()}
                className="w-full bg-primary text-white hover:bg-primary-variant"
              >
                Buscar
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Materials Table */}
      <Card className="shadow-material overflow-hidden">
        <CardHeader className="border-b border-gray-200">
          <CardTitle className="text-lg font-semibold text-on-surface">
            Lista de Materiales
          </CardTitle>
        </CardHeader>
        <CardContent className="p-0">
          <div className="overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Material</TableHead>
                  <TableHead>Categoría</TableHead>
                  <TableHead>Precio Unitario</TableHead>
                  <TableHead>Unidad</TableHead>
                  <TableHead>Última Actualización</TableHead>
                  <TableHead className="text-right">Acciones</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {materialsLoading ? (
                  <>
                    {Array.from({ length: 5 }).map((_, i) => (
                      <TableRow key={i}>
                        <TableCell>
                          <div className="flex items-center space-x-3">
                            <Skeleton className="w-8 h-8 rounded-lg" />
                            <div>
                              <Skeleton className="h-4 w-32 mb-1" />
                              <Skeleton className="h-3 w-20" />
                            </div>
                          </div>
                        </TableCell>
                        <TableCell><Skeleton className="h-4 w-24" /></TableCell>
                        <TableCell><Skeleton className="h-4 w-16" /></TableCell>
                        <TableCell><Skeleton className="h-4 w-12" /></TableCell>
                        <TableCell><Skeleton className="h-4 w-20" /></TableCell>
                        <TableCell>
                          <div className="flex justify-end space-x-2">
                            <Skeleton className="w-8 h-8 rounded" />
                            <Skeleton className="w-8 h-8 rounded" />
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </>
                ) : materials?.length ? (
                  materials.map((material) => {
                    const IconComponent = getIconForCategory(material.category.name);
                    return (
                      <TableRow key={material.id} className="hover:bg-gray-50">
                        <TableCell>
                          <div className="flex items-center space-x-3">
                            <div className="w-8 h-8 bg-gray-200 rounded-lg flex items-center justify-center">
                              <IconComponent className="w-4 h-4 text-gray-600" />
                            </div>
                            <div>
                              <div className="text-sm font-medium text-gray-900">
                                {material.name}
                              </div>
                              {material.description && (
                                <div className="text-sm text-gray-500">
                                  {material.description}
                                </div>
                              )}
                            </div>
                          </div>
                        </TableCell>
                        <TableCell>
                          <Badge variant="secondary">
                            {material.category.name}
                          </Badge>
                        </TableCell>
                        <TableCell className="font-semibold">
                          <div className="flex items-center space-x-2">
                            <span className={material.hasCustomPrice ? "line-through text-gray-400" : ""}>
                              {formatCurrency(material.price)}
                            </span>
                            {material.hasCustomPrice && material.customPrice && (
                              <>
                                <span className="text-blue-600 font-bold">
                                  {formatCurrency(Number(material.customPrice.customPrice))}
                                </span>
                                <User className="w-4 h-4 text-blue-600" />
                              </>
                            )}
                          </div>
                        </TableCell>
                        <TableCell className="text-gray-500">
                          {material.unit}
                        </TableCell>
                        <TableCell className="text-gray-500">
                          {formatRelativeTime(material.lastUpdated!)}
                        </TableCell>
                        <TableCell>
                          <div className="flex justify-end space-x-2">
                            {material.hasCustomPrice ? (
                              <Button
                                variant="ghost"
                                size="icon"
                                onClick={() => handleRestorePrice(material.id)}
                                className="text-orange-600 hover:text-orange-900"
                                disabled={removeCustomPriceMutation.isPending}
                                title="Restaurar precio original"
                              >
                                <RotateCcw className="w-4 h-4" />
                              </Button>
                            ) : (
                              <Button
                                variant="ghost"
                                size="icon"
                                onClick={() => handleCustomizePrice(material)}
                                className="text-blue-600 hover:text-blue-900"
                                title="Personalizar precio"
                              >
                                <User className="w-4 h-4" />
                              </Button>
                            )}
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleEdit(material)}
                              className="text-primary hover:text-primary-variant"
                            >
                              <Edit className="w-4 h-4" />
                            </Button>
                            <Button
                              variant="ghost"
                              size="icon"
                              onClick={() => handleDelete(material.id)}
                              className="text-red-600 hover:text-red-900"
                              disabled={deleteMutation.isPending}
                            >
                              <Trash2 className="w-4 h-4" />
                            </Button>
                          </div>
                        </TableCell>
                      </TableRow>
                    );
                  })
                ) : (
                  <TableRow>
                    <TableCell colSpan={6} className="text-center py-8 text-gray-500">
                      <Package className="w-12 h-12 mx-auto mb-4 text-gray-300" />
                      <p>No se encontraron materiales</p>
                      <p className="text-sm">Intente ajustar los filtros de búsqueda</p>
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>

      {/* Material Form Modal */}
      {showForm && (
        <MaterialForm
          material={editingMaterial}
          categories={categories || []}
          onClose={handleFormClose}
        />
      )}

      {/* Custom Price Modal */}
      <Dialog open={!!customizingMaterial} onOpenChange={() => setCustomizingMaterial(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Personalizar Precio</DialogTitle>
            <DialogDescription>
              Modifica el precio de "{customizingMaterial?.name}". Este cambio será privado y solo lo verás en tus proyectos.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div>
              <Label>Precio actual del sistema:</Label>
              <p className="text-lg font-semibold text-gray-600">
                {customizingMaterial && formatCurrency(customizingMaterial.price)}
              </p>
            </div>
            <div>
              <Label htmlFor="custom-price">Tu precio personalizado (Bs):</Label>
              <Input
                id="custom-price"
                type="number"
                step="0.01"
                min="0"
                value={newCustomPrice}
                onChange={(e) => setNewCustomPrice(e.target.value)}
                placeholder="0.00"
              />
            </div>
            <div className="bg-blue-50 dark:bg-blue-950 border border-blue-200 dark:border-blue-800 rounded-lg p-3">
              <div className="flex items-start space-x-2">
                <User className="w-4 h-4 text-blue-600 dark:text-blue-400 mt-0.5 flex-shrink-0" />
                <p className="text-sm text-blue-700 dark:text-blue-300">
                  Este precio personalizado solo será visible para ti y se aplicará únicamente en tus proyectos. 
                  Otros usuarios seguirán viendo el precio original del sistema.
                </p>
              </div>
            </div>
          </div>
          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => setCustomizingMaterial(null)}
            >
              Cancelar
            </Button>
            <Button
              onClick={handleSaveCustomPrice}
              disabled={!newCustomPrice || parseFloat(newCustomPrice) <= 0 || customPriceMutation.isPending}
            >
              {customPriceMutation.isPending ? "Guardando..." : "Guardar Precio"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
