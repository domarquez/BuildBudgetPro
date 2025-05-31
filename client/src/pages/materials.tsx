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
  Palette
} from "lucide-react";
import { formatCurrency, formatRelativeTime, debounce } from "@/lib/utils";
import { queryClient } from "@/lib/queryClient";
import MaterialForm from "@/components/materials/material-form";
import type { MaterialWithCategory, MaterialCategory } from "@shared/schema";

export default function Materials() {
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<string>("all");
  const [showForm, setShowForm] = useState(false);
  const [editingMaterial, setEditingMaterial] = useState<MaterialWithCategory | null>(null);
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
  } = useQuery<MaterialWithCategory[]>({
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
                          {formatCurrency(material.price)}
                        </TableCell>
                        <TableCell className="text-gray-500">
                          {material.unit}
                        </TableCell>
                        <TableCell className="text-gray-500">
                          {formatRelativeTime(material.lastUpdated!)}
                        </TableCell>
                        <TableCell>
                          <div className="flex justify-end space-x-2">
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
    </div>
  );
}
