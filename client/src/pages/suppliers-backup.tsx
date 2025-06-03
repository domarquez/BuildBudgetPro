import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Link } from "wouter";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Building2, Phone, MessageCircle, Globe, Facebook, MapPin, Star, Crown } from "lucide-react";

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

export default function Suppliers() {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterCity, setFilterCity] = useState("");
  const [filterType, setFilterType] = useState("");
  const [filterSpeciality, setFilterSpeciality] = useState("");

  const { data: suppliers = [], isLoading } = useQuery({
    queryKey: ["/api/supplier-companies"],
  });

  const filteredSuppliers = suppliers.filter((supplier: any) => {
    const matchesSearch = supplier.companyName.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         supplier.description?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCity = !filterCity || supplier.city === filterCity;
    const matchesType = !filterType || supplier.businessType === filterType;
    const matchesSpeciality = !filterSpeciality || supplier.speciality === filterSpeciality;
    
    return matchesSearch && matchesCity && matchesType && matchesSpeciality;
  });

  // Get unique values for filters
  const cities = [...new Set(suppliers.map((s: any) => s.city).filter(Boolean))];
  const businessTypes = [...new Set(suppliers.map((s: any) => s.businessType).filter(Boolean))];
  const specialities = [...new Set(suppliers.map((s: any) => s.speciality).filter(Boolean))];

  if (isLoading) {
    return (
      <div className="p-6">
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin w-8 h-8 border-4 border-primary border-t-transparent rounded-full" />
        </div>
      </div>
    );
  }

  return (
    <div className="p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-on-surface">Empresas Proveedoras</h1>
          <p className="text-on-surface/70 mt-2">
            Encuentra empresas especializadas en materiales de construcción
          </p>
        </div>
        <Link href="/supplier-registration">
          <Button>
            <Building2 className="w-4 h-4 mr-2" />
            Registrar Empresa
          </Button>
        </Link>
      </div>

      {/* Filters */}
      <div className="bg-white p-4 rounded-lg shadow-sm border">
        <div className="flex flex-wrap gap-4 items-end">
          <div className="flex-1 min-w-[200px]">
            <Input
              placeholder="Buscar empresas..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>

          <select
            className="px-3 py-2 border border-gray-300 rounded-md"
            value={filterCity}
            onChange={(e) => setFilterCity(e.target.value)}
          >
            <option value="">Todas las ciudades</option>
            {cities.map(city => (
              <option key={city} value={city}>{city}</option>
            ))}
          </select>

          <select
            className="px-3 py-2 border border-gray-300 rounded-md"
            value={filterType}
            onChange={(e) => setFilterType(e.target.value)}
          >
            <option value="">Todos los tipos</option>
            {businessTypes.map(type => (
              <option key={type} value={type}>
                {type === 'wholesaler' ? 'Mayorista' :
                 type === 'retailer' ? 'Minorista' :
                 type === 'manufacturer' ? 'Fabricante' :
                 type === 'distributor' ? 'Distribuidor' : type}
              </option>
            ))}
          </select>

          <select
            className="px-3 py-2 border border-gray-300 rounded-md"
            value={filterSpeciality}
            onChange={(e) => setFilterSpeciality(e.target.value)}
          >
            <option value="">Todas las especialidades</option>
            {specialities.map(speciality => (
              <option key={speciality} value={speciality}>
                {getSpecialityLabel(speciality)}
              </option>
            ))}
          </select>

          <div className="text-sm text-gray-600 flex items-center">
            {filteredSuppliers.length} empresas encontradas
          </div>
        </div>
      </div>

      {/* Suppliers Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {filteredSuppliers.map((supplier: any) => (
          <Card key={supplier.id} className="hover:shadow-lg transition-shadow">
            <CardHeader>
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-lg overflow-hidden bg-gray-100 flex items-center justify-center flex-shrink-0">
                  {supplier.logoUrl ? (
                    <img 
                      src={supplier.logoUrl} 
                      alt={supplier.companyName}
                      className="w-full h-full object-cover"
                    />
                  ) : (
                    <Building2 className="w-6 h-6 text-gray-400" />
                  )}
                </div>
                <div className="flex-1">
                  <CardTitle className="flex items-center gap-2">
                    {supplier.companyName}
                    {supplier.membershipType === 'premium' && (
                      <Crown className="h-4 w-4 text-yellow-500" />
                    )}
                  </CardTitle>
                </div>
              </div>
              <CardDescription className="mt-2">
                <div className="flex flex-wrap gap-2 mb-2">
                  {supplier.businessType && (
                    <Badge variant="outline">
                      {supplier.businessType === 'wholesaler' ? 'Mayorista' :
                       supplier.businessType === 'retailer' ? 'Minorista' :
                       supplier.businessType === 'manufacturer' ? 'Fabricante' :
                       supplier.businessType === 'distributor' ? 'Distribuidor' : supplier.businessType}
                    </Badge>
                  )}
                  {supplier.speciality && (
                    <Badge variant="secondary">
                      {getSpecialityLabel(supplier.speciality)}
                    </Badge>
                  )}
                </div>
                {supplier.description && (
                  <p className="text-sm text-gray-600 mt-2 line-clamp-3">
                    {supplier.description}
                  </p>
                )}
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {/* Location */}
                {supplier.city && (
                  <div className="flex items-center gap-2 text-sm text-gray-600">
                    <MapPin className="h-4 w-4" />
                    {supplier.city}
                    {supplier.address && `, ${supplier.address}`}
                  </div>
                )}

                {/* Rating */}
                {supplier.rating && parseFloat(supplier.rating) > 0 && (
                  <div className="flex items-center gap-2 text-sm">
                    <Star className="h-4 w-4 text-yellow-500" />
                    <span className="font-medium">{parseFloat(supplier.rating).toFixed(1)}</span>
                    <span className="text-gray-500">
                      ({supplier.reviewCount} reseñas)
                    </span>
                  </div>
                )}

                {/* Contact buttons */}
                <div className="flex gap-2 pt-2">
                  {supplier.phone && (
                    <Button size="sm" variant="outline" className="flex-1">
                      <Phone className="h-3 w-3 mr-1" />
                      Llamar
                    </Button>
                  )}
                  {supplier.whatsapp && (
                    <Button size="sm" variant="outline" className="flex-1">
                      <MessageCircle className="h-3 w-3 mr-1" />
                      WhatsApp
                    </Button>
                  )}
                </div>

                {/* Website and social */}
                <div className="flex gap-2">
                  {supplier.website && (
                    <Button size="sm" variant="ghost" className="flex-1">
                      <Globe className="h-3 w-3 mr-1" />
                      Web
                    </Button>
                  )}
                  {supplier.facebook && (
                    <Button size="sm" variant="ghost" className="flex-1">
                      <Facebook className="h-3 w-3 mr-1" />
                      Facebook
                    </Button>
                  )}
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {filteredSuppliers.length === 0 && (
        <div className="text-center py-12">
          <Building2 className="h-12 w-12 text-gray-400 mx-auto mb-4" />
          <h3 className="text-lg font-semibold text-gray-900 mb-2">
            No se encontraron empresas
          </h3>
          <p className="text-gray-600">
            Intenta ajustar los filtros de búsqueda para encontrar más resultados
          </p>
        </div>
      )}
    </div>
  );
}