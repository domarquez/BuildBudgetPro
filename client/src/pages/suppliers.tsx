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
  }) || [];

  const cities = Array.from(new Set(suppliers?.map((s: any) => s.city).filter(Boolean) || []));
  const businessTypes = Array.from(new Set(suppliers?.map((s: any) => s.businessType).filter(Boolean) || []));
  const specialities = Array.from(new Set(suppliers?.map((s: any) => s.speciality).filter(Boolean) || []));

  if (isLoading) {
    return (
      <div className="container mx-auto py-8">
        <div className="animate-pulse space-y-4">
          <div className="h-8 bg-gray-200 rounded w-64"></div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[1, 2, 3, 4, 5, 6].map(i => (
              <div key={i} className="h-64 bg-gray-200 rounded"></div>
            ))}
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto py-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">
          Empresas Proveedoras
        </h1>
        <p className="text-lg text-gray-600">
          Encuentra proveedores de materiales de construcción con precios competitivos
        </p>
      </div>

      {/* Filters */}
      <div className="mb-8 space-y-4">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Input
            placeholder="Buscar empresas..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
          
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
              <div className="flex justify-between items-start">
                <div className="flex items-center gap-3 flex-1">
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
                        <Badge variant="secondary" className="bg-blue-100 text-blue-800">
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
                <div className="flex items-center gap-2">
                  <Star className="h-4 w-4 text-yellow-500" />
                  <span className="text-sm">
                    {supplier.rating || "0.0"} ({supplier.reviewCount || 0} reseñas)
                  </span>
                  {supplier.isVerified && (
                    <Badge variant="secondary" className="text-xs">
                      Verificada
                    </Badge>
                  )}
                </div>

                {/* Contact Options */}
                <div className="flex flex-wrap gap-2 pt-2">
                  {supplier.phone && (
                    <Button size="sm" variant="outline" asChild>
                      <a href={`tel:${supplier.phone}`}>
                        <Phone className="h-3 w-3 mr-1" />
                        Llamar
                      </a>
                    </Button>
                  )}
                  
                  {supplier.whatsapp && (
                    <Button size="sm" variant="outline" asChild>
                      <a 
                        href={`https://wa.me/${supplier.whatsapp.replace(/[^0-9]/g, '')}`}
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        <MessageCircle className="h-3 w-3 mr-1" />
                        WhatsApp
                      </a>
                    </Button>
                  )}

                  {supplier.website && (
                    <Button size="sm" variant="outline" asChild>
                      <a 
                        href={supplier.website.startsWith('http') ? supplier.website : `https://${supplier.website}`}
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        <Globe className="h-3 w-3 mr-1" />
                        Web
                      </a>
                    </Button>
                  )}

                  {supplier.facebook && (
                    <Button size="sm" variant="outline" asChild>
                      <a 
                        href={`https://facebook.com/${supplier.facebook}`}
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        <Facebook className="h-3 w-3 mr-1" />
                        Facebook
                      </a>
                    </Button>
                  )}
                </div>

                <div className="pt-2">
                  <Button asChild className="w-full">
                    <Link href={`/suppliers/${supplier.id}`}>
                      Ver Catálogo
                    </Link>
                  </Button>
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