import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Skeleton } from "@/components/ui/skeleton";
import { 
  Store, 
  Star, 
  MapPin, 
  Phone,
  Globe,
  TrendingDown,
  Zap,
  Clock,
  Search
} from "lucide-react";

interface MaterialWithOffers {
  id: number;
  name: string;
  category: {
    id: number;
    name: string;
  };
  price: string;
  unit: string;
  offers: {
    id: number;
    price: string;
    supplier: {
      id: number;
      companyName: string;
      city: string;
      membershipType: string;
      rating: number;
      speciality?: string;
      phone?: string;
      website?: string;
    };
    validUntil: string;
    leadTimeDays: number;
    minimumQuantity: string;
  }[];
}

interface MaterialCategory {
  id: number;
  name: string;
}

// Función para convertir códigos de especialidad en etiquetas legibles
const getSpecialityLabel = (speciality: string): string => {
  const specialities: Record<string, string> = {
    acero: "Acero para Construcción",
    aluminio: "Aluminio",
    cemento: "Cemento y Hormigón",
    agua: "Agua y Saneamiento",
    electricos: "Materiales Eléctricos",
    ceramicos: "Cerámicos y Pisos",
    maderas: "Maderas",
    pinturas: "Pinturas y Acabados",
    plomeria: "Plomería y Gasfitería",
    prefabricados: "Elementos Prefabricados",
    herramientas: "Herramientas y Equipos",
    seguridad: "Seguridad Industrial",
    aislantes: "Materiales Aislantes",
    vidrios: "Vidrios y Cristales",
    general: "General/Varios"
  };
  return specialities[speciality] || speciality;
};

export default function Marketplace() {
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<string>("all");

  // Cargar categorías
  const { data: categories } = useQuery<MaterialCategory[]>({
    queryKey: ["/api/material-categories"],
  });

  // Cargar materiales con ofertas
  const { data: materialsWithOffers, isLoading } = useQuery<MaterialWithOffers[]>({
    queryKey: ["/api/marketplace/materials", { 
      category: selectedCategory === "all" ? undefined : selectedCategory,
      search: searchTerm || undefined 
    }],
  });

  const filteredMaterials = materialsWithOffers?.filter(material => 
    material.offers.length > 0 && 
    (searchTerm === "" || material.name.toLowerCase().includes(searchTerm.toLowerCase()))
  ) || [];

  const formatCurrency = (amount: string | number) => {
    const numAmount = typeof amount === 'string' ? parseFloat(amount) : amount;
    return new Intl.NumberFormat('es-BO', {
      style: 'currency',
      currency: 'BOB',
      minimumFractionDigits: 2,
    }).format(numAmount);
  };

  const getMembershipBadge = (membershipType: string) => {
    switch (membershipType) {
      case 'premium':
        return <Badge className="bg-yellow-500 text-white"><Zap className="w-3 h-3 mr-1" />Premium</Badge>;
      case 'pro':
        return <Badge className="bg-blue-500 text-white">Pro</Badge>;
      default:
        return <Badge variant="outline">Free</Badge>;
    }
  };

  const getSavingsPercentage = (originalPrice: string, offerPrice: string) => {
    const original = parseFloat(originalPrice);
    const offer = parseFloat(offerPrice);
    if (original > offer) {
      const savings = ((original - offer) / original) * 100;
      return Math.round(savings);
    }
    return 0;
  };

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex flex-col space-y-4">
        <div>
          <h2 className="text-2xl font-bold text-on-surface">Marketplace de Materiales</h2>
          <p className="text-gray-600">Encuentra las mejores ofertas de materiales de construcción</p>
        </div>

        {/* Filtros */}
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
            <Input
              placeholder="Buscar materiales..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10"
            />
          </div>
          <Select value={selectedCategory} onValueChange={setSelectedCategory}>
            <SelectTrigger className="w-full sm:w-64">
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
      </div>

      {/* Estadísticas rápidas */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Materiales con Ofertas</p>
                <p className="text-2xl font-bold text-on-surface">{filteredMaterials.length}</p>
              </div>
              <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                <Store className="w-6 h-6 text-green-600" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Empresas Activas</p>
                <p className="text-2xl font-bold text-on-surface">
                  {new Set(filteredMaterials.flatMap(m => m.offers.map(o => o.supplier.id))).size}
                </p>
              </div>
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <Store className="w-6 h-6 text-primary" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Ofertas Totales</p>
                <p className="text-2xl font-bold text-on-surface">
                  {filteredMaterials.reduce((total, material) => total + material.offers.length, 0)}
                </p>
              </div>
              <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                <TrendingDown className="w-6 h-6 text-purple-600" />
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Lista de materiales con ofertas */}
      <div className="space-y-6">
        {isLoading ? (
          <div className="space-y-4">
            {Array.from({ length: 5 }).map((_, i) => (
              <Skeleton key={i} className="h-48 w-full" />
            ))}
          </div>
        ) : filteredMaterials.length > 0 ? (
          filteredMaterials.map((material) => (
            <Card key={material.id} className="overflow-hidden">
              <CardHeader className="pb-4">
                <div className="flex justify-between items-start">
                  <div>
                    <CardTitle className="text-lg">{material.name}</CardTitle>
                    <div className="flex items-center gap-2 mt-1">
                      <Badge variant="outline">{material.category.name}</Badge>
                      <span className="text-sm text-gray-600">Precio base: {formatCurrency(material.price)}</span>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-sm text-gray-600">Unidad: {material.unit}</p>
                    <p className="text-sm font-medium text-green-600">
                      {material.offers.length} oferta{material.offers.length !== 1 ? 's' : ''} disponible{material.offers.length !== 1 ? 's' : ''}
                    </p>
                  </div>
                </div>
              </CardHeader>
              <CardContent className="pt-0">
                <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4">
                  {material.offers.slice(0, 6).map((offer) => {
                    const savings = getSavingsPercentage(material.price, offer.price);
                    return (
                      <div key={offer.id} className="border rounded-lg p-4 hover:shadow-md transition-shadow">
                        <div className="flex justify-between items-start mb-3">
                          <div className="flex flex-col gap-1">
                            <div className="flex items-center gap-2">
                              <Store className="w-4 h-4 text-gray-600" />
                              <span className="font-medium text-sm">{offer.supplier.companyName}</span>
                              {getMembershipBadge(offer.supplier.membershipType)}
                            </div>
                            {offer.supplier.speciality && (
                              <span className="text-xs text-gray-500 ml-6">{getSpecialityLabel(offer.supplier.speciality)}</span>
                            )}
                          </div>
                          {savings > 0 && (
                            <Badge className="bg-red-500 text-white text-xs">
                              -{savings}%
                            </Badge>
                          )}
                        </div>
                        
                        <div className="space-y-2">
                          <div className="flex justify-between items-center">
                            <span className="text-lg font-bold text-green-600">
                              {formatCurrency(offer.price)}
                            </span>
                            <div className="flex items-center gap-1 text-xs text-gray-500">
                              <Star className="w-3 h-3 fill-current" />
                              <span>{offer.supplier.rating.toFixed(1)}</span>
                            </div>
                          </div>
                          
                          <div className="flex items-center gap-1 text-xs text-gray-600">
                            <MapPin className="w-3 h-3" />
                            <span>{offer.supplier.city}</span>
                          </div>
                          
                          <div className="flex items-center gap-4 text-xs text-gray-600">
                            <div className="flex items-center gap-1">
                              <Clock className="w-3 h-3" />
                              <span>{offer.leadTimeDays} días</span>
                            </div>
                            <span>Min: {offer.minimumQuantity}</span>
                          </div>
                          
                          <div className="flex gap-2 mt-3">
                            {offer.supplier.phone && (
                              <Button variant="outline" size="sm" className="flex-1">
                                <Phone className="w-3 h-3 mr-1" />
                                Llamar
                              </Button>
                            )}
                            {offer.supplier.website && (
                              <Button variant="outline" size="sm" className="flex-1">
                                <Globe className="w-3 h-3 mr-1" />
                                Web
                              </Button>
                            )}
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
                
                {material.offers.length > 6 && (
                  <div className="mt-4 text-center">
                    <Button variant="outline" size="sm">
                      Ver todas las ofertas ({material.offers.length})
                    </Button>
                  </div>
                )}
              </CardContent>
            </Card>
          ))
        ) : (
          <Card>
            <CardContent className="py-12 text-center">
              <Store className="w-16 h-16 mx-auto mb-4 text-gray-300" />
              <h3 className="text-lg font-medium text-gray-900 mb-2">No hay ofertas disponibles</h3>
              <p className="text-gray-600">
                {searchTerm || selectedCategory !== "all" 
                  ? "No se encontraron ofertas para los filtros seleccionados."
                  : "Aún no hay empresas ofreciendo precios para materiales."}
              </p>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  );
}