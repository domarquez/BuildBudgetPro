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
  DialogTrigger,
} from "@/components/ui/dialog";
import { Skeleton } from "@/components/ui/skeleton";
import { useToast } from "@/hooks/use-toast";
import { 
  DollarSign, 
  Plus, 
  Edit, 
  Package,
  TrendingUp,
  Calendar
} from "lucide-react";
import { formatCurrency, formatRelativeTime } from "@/lib/utils";
import { apiRequest, queryClient } from "@/lib/queryClient";
import type { MaterialWithCategory, MaterialCategory } from "@shared/schema";

interface SupplierQuote {
  id: number;
  materialId: number;
  supplierId: number;
  price: number;
  validUntil: string;
  status: string;
  createdAt: string;
  material: MaterialWithCategory;
}

export default function SupplierPricing() {
  const [selectedCategory, setSelectedCategory] = useState<string>("all");
  const [showQuoteDialog, setShowQuoteDialog] = useState(false);
  const [selectedMaterial, setSelectedMaterial] = useState<MaterialWithCategory | null>(null);
  const [quotePrice, setQuotePrice] = useState("");
  const [validUntil, setValidUntil] = useState("");
  const { toast } = useToast();

  // Cargar categorías de materiales
  const { data: categories } = useQuery<MaterialCategory[]>({
    queryKey: ["/api/material-categories"],
  });

  // Cargar materiales
  const { data: materials, isLoading: materialsLoading } = useQuery<MaterialWithCategory[]>({
    queryKey: ["/api/materials", { categoryId: selectedCategory === "all" ? undefined : selectedCategory }],
  });

  // Cargar mis cotizaciones
  const { data: myQuotes, isLoading: quotesLoading } = useQuery<SupplierQuote[]>({
    queryKey: ["/api/supplier/quotes"],
  });

  // Crear cotización
  const createQuoteMutation = useMutation({
    mutationFn: async (quoteData: {
      materialId: number;
      price: number;
      validUntil: string;
    }) => {
      return apiRequest("POST", "/api/supplier/quotes", quoteData);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/supplier/quotes"] });
      setShowQuoteDialog(false);
      setSelectedMaterial(null);
      setQuotePrice("");
      setValidUntil("");
      toast({
        title: "Cotización creada",
        description: "Tu oferta de precio ha sido registrada exitosamente.",
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

  const handleCreateQuote = () => {
    if (!selectedMaterial || !quotePrice || !validUntil) {
      toast({
        title: "Campos requeridos",
        description: "Por favor completa todos los campos",
        variant: "destructive",
      });
      return;
    }

    createQuoteMutation.mutate({
      materialId: selectedMaterial.id,
      price: parseFloat(quotePrice),
      validUntil,
    });
  };

  const openQuoteDialog = (material: MaterialWithCategory) => {
    setSelectedMaterial(material);
    setQuotePrice("");
    setValidUntil("");
    setShowQuoteDialog(true);
  };

  const filteredMaterials = materials?.filter(material => 
    selectedCategory === "all" || material.categoryId.toString() === selectedCategory
  ) || [];

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center space-y-4 sm:space-y-0">
        <div>
          <h2 className="text-2xl font-bold text-on-surface">Mis Ofertas de Precios</h2>
          <p className="text-gray-600">Gestiona tus cotizaciones de materiales y herramientas</p>
        </div>
        <div className="flex items-center space-x-4">
          <Select value={selectedCategory} onValueChange={setSelectedCategory}>
            <SelectTrigger className="w-48">
              <SelectValue placeholder="Filtrar por categoría" />
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
      </div>

      {/* Estadísticas rápidas */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Cotizaciones Activas</p>
                <p className="text-2xl font-bold text-on-surface">
                  {myQuotes?.filter(q => q.status === 'active').length || 0}
                </p>
              </div>
              <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                <TrendingUp className="w-6 h-6 text-green-600" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Total Cotizaciones</p>
                <p className="text-2xl font-bold text-on-surface">
                  {myQuotes?.length || 0}
                </p>
              </div>
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <Package className="w-6 h-6 text-primary" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Próximas a Vencer</p>
                <p className="text-2xl font-bold text-on-surface">
                  {myQuotes?.filter(q => {
                    const validUntil = new Date(q.validUntil);
                    const thirtyDaysFromNow = new Date();
                    thirtyDaysFromNow.setDate(thirtyDaysFromNow.getDate() + 30);
                    return validUntil <= thirtyDaysFromNow;
                  }).length || 0}
                </p>
              </div>
              <div className="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center">
                <Calendar className="w-6 h-6 text-yellow-600" />
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Mis Cotizaciones */}
      <Card>
        <CardHeader>
          <CardTitle>Mis Cotizaciones Activas</CardTitle>
        </CardHeader>
        <CardContent>
          {quotesLoading ? (
            <div className="space-y-2">
              {Array.from({ length: 5 }).map((_, i) => (
                <Skeleton key={i} className="h-12 w-full" />
              ))}
            </div>
          ) : myQuotes && myQuotes.length > 0 ? (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Material</TableHead>
                  <TableHead>Categoría</TableHead>
                  <TableHead>Mi Precio</TableHead>
                  <TableHead>Precio Actual</TableHead>
                  <TableHead>Válido Hasta</TableHead>
                  <TableHead>Estado</TableHead>
                  <TableHead>Acciones</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {myQuotes.map((quote) => (
                  <TableRow key={quote.id}>
                    <TableCell className="font-medium">
                      {quote.material.name}
                    </TableCell>
                    <TableCell>
                      <Badge variant="outline">
                        {quote.material.category?.name}
                      </Badge>
                    </TableCell>
                    <TableCell className="font-semibold text-green-600">
                      {formatCurrency(quote.price)}
                    </TableCell>
                    <TableCell className="text-gray-600">
                      {formatCurrency(parseFloat(quote.material.price))}
                    </TableCell>
                    <TableCell>
                      {new Date(quote.validUntil).toLocaleDateString()}
                    </TableCell>
                    <TableCell>
                      <Badge variant={quote.status === 'active' ? 'default' : 'secondary'}>
                        {quote.status === 'active' ? 'Activa' : 'Inactiva'}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <Button variant="ghost" size="sm">
                        <Edit className="w-4 h-4" />
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          ) : (
            <div className="text-center py-8 text-gray-500">
              <DollarSign className="w-12 h-12 mx-auto mb-4 text-gray-300" />
              <p>No tienes cotizaciones activas</p>
              <p className="text-sm">Comienza creando ofertas para materiales</p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Lista de Materiales Disponibles */}
      <Card>
        <CardHeader>
          <CardTitle>Materiales Disponibles para Cotizar</CardTitle>
        </CardHeader>
        <CardContent>
          {materialsLoading ? (
            <div className="space-y-2">
              {Array.from({ length: 10 }).map((_, i) => (
                <Skeleton key={i} className="h-12 w-full" />
              ))}
            </div>
          ) : filteredMaterials.length > 0 ? (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Material</TableHead>
                  <TableHead>Categoría</TableHead>
                  <TableHead>Unidad</TableHead>
                  <TableHead>Precio Actual</TableHead>
                  <TableHead>Acciones</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredMaterials.slice(0, 20).map((material) => (
                  <TableRow key={material.id}>
                    <TableCell className="font-medium">
                      {material.name}
                    </TableCell>
                    <TableCell>
                      <Badge variant="outline">
                        {material.category?.name}
                      </Badge>
                    </TableCell>
                    <TableCell>{material.unit}</TableCell>
                    <TableCell className="font-semibold">
                      {formatCurrency(parseFloat(material.price))}
                    </TableCell>
                    <TableCell>
                      <Button 
                        variant="outline" 
                        size="sm"
                        onClick={() => openQuoteDialog(material)}
                      >
                        <Plus className="w-4 h-4 mr-2" />
                        Cotizar
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          ) : (
            <div className="text-center py-8 text-gray-500">
              <Package className="w-12 h-12 mx-auto mb-4 text-gray-300" />
              <p>No hay materiales disponibles</p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Dialog para crear cotización */}
      <Dialog open={showQuoteDialog} onOpenChange={setShowQuoteDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Crear Cotización</DialogTitle>
            <DialogDescription>
              Crea una oferta de precio para {selectedMaterial?.name}
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div>
              <Label htmlFor="price">Precio por {selectedMaterial?.unit}</Label>
              <Input
                id="price"
                type="number"
                step="0.01"
                value={quotePrice}
                onChange={(e) => setQuotePrice(e.target.value)}
                placeholder="0.00"
              />
              <p className="text-xs text-gray-500 mt-1">
                Precio actual: {selectedMaterial ? formatCurrency(parseFloat(selectedMaterial.price)) : ""}
              </p>
            </div>
            <div>
              <Label htmlFor="validUntil">Válido hasta</Label>
              <Input
                id="validUntil"
                type="date"
                value={validUntil}
                onChange={(e) => setValidUntil(e.target.value)}
                min={new Date().toISOString().split('T')[0]}
              />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setShowQuoteDialog(false)}>
              Cancelar
            </Button>
            <Button 
              onClick={handleCreateQuote}
              disabled={createQuoteMutation.isPending}
            >
              {createQuoteMutation.isPending ? "Creando..." : "Crear Cotización"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}