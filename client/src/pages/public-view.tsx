import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { ContactForm } from "@/components/contact-form";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Skeleton } from "@/components/ui/skeleton";
import { 
  Search, 
  Package,
  Store,
  MapPin,
  Phone,
  Globe,
  Crown,
  Eye,
  X,
  AlertCircle,
  Users,
  Building2,
  Calculator,
  Truck,
  TrendingUp,
  Combine,
  BarChart3,
  Mail
} from "lucide-react";
import { formatCurrency, formatNumber } from "@/lib/utils";
import type { Material, MaterialCategory, SupplierCompany, AdvertisementWithSupplier } from "@shared/schema";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

interface Statistics {
  totalMaterials: number;
  totalActivities: number;
  activeBudgets: number;
  totalProjectValue: number;
  totalUsers: number;
  totalSuppliers: number;
  totalProjects: number;
}

interface GrowthData {
  month: string;
  users: number;
  projects: number;
  budgets: number;
  suppliers: number;
}

export default function PublicView() {
  const [activeTab, setActiveTab] = useState<"materials" | "suppliers">("materials");
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<string>("all");
  const [showAd, setShowAd] = useState(true);

  // Consultas públicas sin autenticación
  const { data: materials, isLoading: materialsLoading } = useQuery<Material[]>({
    queryKey: ["/api/public/materials"],
  });

  const { data: categories, isLoading: categoriesLoading } = useQuery<MaterialCategory[]>({
    queryKey: ["/api/public/material-categories"],
  });

  const { data: suppliers, isLoading: suppliersLoading } = useQuery<SupplierCompany[]>({
    queryKey: ["/api/public/suppliers"],
  });

  const { data: stats, isLoading: statsLoading } = useQuery<Statistics>({
    queryKey: ["/api/statistics"],
  });

  const { data: growthData, isLoading: growthLoading } = useQuery<GrowthData[]>({
    queryKey: ["/api/growth-data"],
  });

  // Publicidad dual lado a lado
  const { data: advertisements, refetch: refetchAds } = useQuery<AdvertisementWithSupplier[]>({
    queryKey: ["/api/public/dual-advertisements"],
    refetchInterval: 30000, // Cambiar cada 30 segundos
  });

  const handleAdClick = async (ad: AdvertisementWithSupplier) => {
    // Registrar clic
    await fetch(`/api/advertisements/${ad.id}/click`, {
      method: 'POST'
    });
    
    // Abrir enlace si existe
    if (ad.linkUrl) {
      window.open(ad.linkUrl, '_blank');
    } else if (ad.supplier.email) {
      window.open(`mailto:${ad.supplier.email}`, '_blank');
    }
  };

  const handleCloseAds = () => {
    setShowAd(false);
    setTimeout(() => {
      setShowAd(true);
      refetchAds();
    }, 10000); // Mostrar nuevas publicidades después de 10 segundos
  };

  const filteredMaterials = materials?.filter(material => {
    const matchesSearch = material.name.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = selectedCategory === "all" || material.categoryId.toString() === selectedCategory;
    return matchesSearch && matchesCategory;
  }).slice(0, 20) || []; // Limitar a 20 para usuarios no registrados

  const filteredSuppliers = suppliers?.filter(supplier =>
    supplier.companyName.toLowerCase().includes(searchQuery.toLowerCase()) ||
    supplier.speciality?.toLowerCase().includes(searchQuery.toLowerCase())
  ) || [];

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      {/* Header Público */}
      <div className="bg-white dark:bg-gray-800 shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
                MICAA - Cómputos y Presupuestos
              </h1>
              <p className="text-gray-600 dark:text-gray-400">
                Explora materiales y proveedores de construcción en Bolivia
              </p>
            </div>
            <div className="flex space-x-3">
              <ContactForm 
                triggerText="Contacto"
                triggerVariant="outline"
                className="flex items-center space-x-2"
              />
              <Button variant="outline" onClick={() => window.location.href = "/login"}>
                Iniciar Sesión
              </Button>
              <Button onClick={() => window.location.href = "/register"}>
                Registrarse
              </Button>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
        {/* Publicidad Dual - Lado a Lado - Primero */}
        {advertisements && advertisements.length > 0 && showAd && (
          <div className="relative">
            <Button
              variant="ghost"
              size="icon"
              className="absolute top-2 right-2 z-10 h-6 w-6 rounded-full bg-black/20 hover:bg-black/40 text-white"
              onClick={handleCloseAds}
            >
              <X className="w-3 h-3" />
            </Button>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {advertisements.slice(0, 2).map((ad, index) => (
                <Card key={ad.id} className="relative overflow-hidden border-2 border-blue-200 dark:border-blue-800 bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-blue-950 dark:to-indigo-950">
                  <CardContent className="p-0">
                    <div 
                      className="cursor-pointer group"
                      onClick={() => handleAdClick(ad)}
                    >
                      {/* Imagen rectangular con mayor altura */}
                      <div className="relative h-64 w-full overflow-hidden">
                        <img 
                          src={ad.imageUrl} 
                          alt={ad.title}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                        />
                        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />
                        
                        {/* Información superpuesta en la imagen */}
                        <div className="absolute bottom-0 left-0 right-0 p-3 text-white">
                          <h3 className="font-bold text-lg mb-1 drop-shadow-lg line-clamp-1">
                            {ad.title}
                          </h3>
                          <p className="text-blue-200 text-xs font-medium drop-shadow">
                            {ad.supplier.companyName}
                          </p>
                        </div>
                      </div>
                      
                      {/* Información inferior compacta */}
                      <div className="p-3 bg-white dark:bg-gray-800">
                        {ad.description && (
                          <p className="text-gray-700 dark:text-gray-300 text-xs mb-2 line-clamp-2">
                            {ad.description}
                          </p>
                        )}
                        <div className="flex items-center justify-between">
                          <div className="flex items-center space-x-2 text-xs">
                            <div className="flex items-center space-x-1 text-gray-600 dark:text-gray-400">
                              <Eye className="w-3 h-3" />
                              <span>{ad.viewCount}</span>
                            </div>
                            <Badge variant="secondary" className="text-xs px-1 py-0">
                              {ad.adType === "featured" ? "★" : "↗"}
                            </Badge>
                          </div>
                          <div className="text-xs text-blue-600 dark:text-blue-400 font-medium">
                            {ad.supplier.city}
                          </div>
                        </div>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        )}

        {/* Métricas Compactas del Sistema */}
        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-7 gap-3">
          <Card className="shadow-material">
            <CardContent className="p-4">
              <div className="flex flex-col items-center text-center">
                <Users className="w-6 h-6 text-primary mb-2" />
                {statsLoading ? (
                  <Skeleton className="h-6 w-12 mb-1" />
                ) : (
                  <p className="text-xl font-bold text-on-surface">
                    {formatNumber(stats?.totalUsers || 0)}
                  </p>
                )}
                <p className="text-xs text-gray-600">Usuarios</p>
                <p className="text-xs text-green-600 mt-1">Registrados</p>
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-material">
            <CardContent className="p-4">
              <div className="flex flex-col items-center text-center">
                <Calculator className="w-6 h-6 text-green-600 mb-2" />
                {statsLoading ? (
                  <Skeleton className="h-6 w-12 mb-1" />
                ) : (
                  <p className="text-xl font-bold text-on-surface">
                    {formatNumber(stats?.activeBudgets || 0)}
                  </p>
                )}
                <p className="text-xs text-gray-600">Presupuestos</p>
                <p className="text-xs text-green-600 mt-1">Creados</p>
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-material">
            <CardContent className="p-4">
              <div className="flex flex-col items-center text-center">
                <Building2 className="w-6 h-6 text-orange-600 mb-2" />
                {statsLoading ? (
                  <Skeleton className="h-6 w-12 mb-1" />
                ) : (
                  <p className="text-xl font-bold text-on-surface">
                    {formatNumber(stats?.totalProjects || 0)}
                  </p>
                )}
                <p className="text-xs text-gray-600">Proyectos</p>
                <p className="text-xs text-green-600 mt-1">En desarrollo</p>
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-material">
            <CardContent className="p-4">
              <div className="flex flex-col items-center text-center">
                <Truck className="w-6 h-6 text-purple-600 mb-2" />
                {statsLoading ? (
                  <Skeleton className="h-6 w-12 mb-1" />
                ) : (
                  <p className="text-xl font-bold text-on-surface">
                    {formatNumber(stats?.totalSuppliers || 0)}
                  </p>
                )}
                <p className="text-xs text-gray-600">Proveedores</p>
                <p className="text-xs text-green-600 mt-1">Activos</p>
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-material">
            <CardContent className="p-4">
              <div className="flex flex-col items-center text-center">
                <Package className="w-6 h-6 text-blue-600 mb-2" />
                {statsLoading ? (
                  <Skeleton className="h-6 w-12 mb-1" />
                ) : (
                  <p className="text-xl font-bold text-on-surface">
                    {formatNumber(stats?.totalMaterials || 0)}
                  </p>
                )}
                <p className="text-xs text-gray-600">Materiales</p>
                <p className="text-xs text-green-600 mt-1">Disponibles</p>
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-material">
            <CardContent className="p-4">
              <div className="flex flex-col items-center text-center">
                <Combine className="w-6 h-6 text-teal-600 mb-2" />
                {statsLoading ? (
                  <Skeleton className="h-6 w-12 mb-1" />
                ) : (
                  <p className="text-xl font-bold text-on-surface">
                    {formatNumber(stats?.totalActivities || 0)}
                  </p>
                )}
                <p className="text-xs text-gray-600">Actividades</p>
                <p className="text-xs text-green-600 mt-1">Registradas</p>
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-material">
            <CardContent className="p-4">
              <div className="flex flex-col items-center text-center">
                <TrendingUp className="w-6 h-6 text-yellow-600 mb-2" />
                {statsLoading ? (
                  <Skeleton className="h-6 w-16 mb-1" />
                ) : (
                  <p className="text-sm font-bold text-on-surface">
                    {formatCurrency(stats?.totalProjectValue || 0).replace(' Bs', '')} Bs
                  </p>
                )}
                <p className="text-xs text-gray-600">Valor Total</p>
                <p className="text-xs text-green-600 mt-1">Acumulado</p>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Growth Chart */}
        <Card className="shadow-material">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <BarChart3 className="w-5 h-5" />
              Crecimiento del Sistema (Últimos 6 Meses)
            </CardTitle>
          </CardHeader>
          <CardContent>
            {growthLoading ? (
              <div className="h-64 flex items-center justify-center">
                <div className="animate-spin w-8 h-8 border-4 border-primary border-t-transparent rounded-full" />
              </div>
            ) : (
              <div className="h-64">
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={growthData || []}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="month" />
                    <YAxis />
                    <Tooltip />
                    <Legend />
                    <Line 
                      type="monotone" 
                      dataKey="users" 
                      stroke="#3B82F6" 
                      strokeWidth={2}
                      name="Usuarios"
                    />
                    <Line 
                      type="monotone" 
                      dataKey="projects" 
                      stroke="#F97316" 
                      strokeWidth={2}
                      name="Proyectos"
                    />
                    <Line 
                      type="monotone" 
                      dataKey="budgets" 
                      stroke="#10B981" 
                      strokeWidth={2}
                      name="Presupuestos"
                    />
                    <Line 
                      type="monotone" 
                      dataKey="suppliers" 
                      stroke="#8B5CF6" 
                      strokeWidth={2}
                      name="Proveedores"
                    />
                  </LineChart>
                </ResponsiveContainer>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Navegación por pestañas */}
        <div className="flex space-x-1 bg-gray-100 dark:bg-gray-800 p-1 rounded-lg">
          <Button
            variant={activeTab === "materials" ? "default" : "ghost"}
            onClick={() => setActiveTab("materials")}
            className="flex-1"
          >
            <Package className="w-4 h-4 mr-2" />
            Materiales
          </Button>
          <Button
            variant={activeTab === "suppliers" ? "default" : "ghost"}
            onClick={() => setActiveTab("suppliers")}
            className="flex-1"
          >
            <Store className="w-4 h-4 mr-2" />
            Proveedores
          </Button>
        </div>

        {/* Búsqueda y Filtros */}
        <Card>
          <CardContent className="p-4">
            <div className="space-y-4">
              {/* Barra de búsqueda */}
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                <Input
                  type="text"
                  placeholder={`Buscar ${activeTab === "materials" ? "materiales" : "proveedores"}...`}
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10"
                />
              </div>

              {/* Filtros por categoría (solo para materiales) */}
              {activeTab === "materials" && categories && (
                <div>
                  <label className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2 block">
                    Filtrar por categoría:
                  </label>
                  <div className="flex flex-wrap gap-2">
                    <button
                      onClick={() => setSelectedCategory("all")}
                      className={`px-3 py-1 rounded-full text-sm transition-colors ${
                        selectedCategory === "all"
                          ? "bg-primary text-white"
                          : "bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-300 dark:hover:bg-gray-600"
                      }`}
                    >
                      Todas las categorías
                    </button>
                    {categories.map((category) => (
                      <button
                        key={category.id}
                        onClick={() => setSelectedCategory(category.id.toString())}
                        className={`px-3 py-1 rounded-full text-sm transition-colors ${
                          selectedCategory === category.id.toString()
                            ? "bg-primary text-white"
                            : "bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-300 dark:hover:bg-gray-600"
                        }`}
                      >
                        {category.name}
                      </button>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </CardContent>
        </Card>

        {/* Contenido según pestaña activa */}
        {activeTab === "materials" && (
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center space-x-2">
                <Package className="w-5 h-5" />
                <span>Materiales de Construcción</span>
                <Badge variant="secondary">Vista Limitada</Badge>
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="overflow-x-auto">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Material</TableHead>
                      <TableHead>Precio Unitario</TableHead>
                      <TableHead>Unidad</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {materialsLoading ? (
                      Array.from({ length: 5 }).map((_, i) => (
                        <TableRow key={i}>
                          <TableCell><Skeleton className="h-4 w-32" /></TableCell>
                          <TableCell><Skeleton className="h-4 w-16" /></TableCell>
                          <TableCell><Skeleton className="h-4 w-12" /></TableCell>
                        </TableRow>
                      ))
                    ) : filteredMaterials.length > 0 ? (
                      filteredMaterials.map((material) => (
                        <TableRow key={material.id}>
                          <TableCell className="font-medium">
                            {material.name}
                          </TableCell>
                          <TableCell className="font-semibold text-green-600">
                            {formatCurrency(material.price)}
                          </TableCell>
                          <TableCell className="text-gray-500">
                            {material.unit}
                          </TableCell>
                        </TableRow>
                      ))
                    ) : (
                      <TableRow>
                        <TableCell colSpan={3} className="text-center py-8 text-gray-500">
                          No se encontraron materiales
                        </TableCell>
                      </TableRow>
                    )}
                  </TableBody>
                </Table>
              </div>
              {filteredMaterials.length >= 20 && (
                <div className="mt-4 text-center">
                  <div className="inline-flex items-center space-x-2 text-amber-600 dark:text-amber-400 bg-amber-50 dark:bg-amber-950 px-4 py-2 rounded-lg">
                    <AlertCircle className="w-4 h-4" />
                    <span className="text-sm">
                      Mostrando primeros 20 resultados. Regístrate para ver todos los materiales.
                    </span>
                  </div>
                </div>
              )}
            </CardContent>
          </Card>
        )}

        {activeTab === "suppliers" && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {suppliersLoading ? (
              Array.from({ length: 6 }).map((_, i) => (
                <Card key={i}>
                  <CardContent className="p-6">
                    <Skeleton className="h-6 w-3/4 mb-2" />
                    <Skeleton className="h-4 w-1/2 mb-4" />
                    <Skeleton className="h-4 w-full mb-2" />
                    <Skeleton className="h-4 w-2/3" />
                  </CardContent>
                </Card>
              ))
            ) : filteredSuppliers.length > 0 ? (
              filteredSuppliers.map((supplier) => (
                <Card key={supplier.id} className="hover:shadow-lg transition-shadow">
                  <CardContent className="p-6">
                    <div className="flex items-start justify-between mb-3">
                      <h3 className="font-semibold text-lg text-gray-900 dark:text-white">
                        {supplier.companyName}
                      </h3>
                      {supplier.membershipType === "premium" && (
                        <Crown className="w-5 h-5 text-yellow-500" />
                      )}
                    </div>
                    
                    {supplier.speciality && (
                      <Badge variant="secondary" className="mb-3">
                        {supplier.speciality}
                      </Badge>
                    )}
                    
                    <div className="space-y-2 text-sm text-gray-600 dark:text-gray-400">
                      {supplier.city && (
                        <div className="flex items-center space-x-2">
                          <MapPin className="w-4 h-4" />
                          <span>{supplier.city}</span>
                        </div>
                      )}
                      {supplier.phone && (
                        <div className="flex items-center space-x-2">
                          <Phone className="w-4 h-4" />
                          <span>{supplier.phone}</span>
                        </div>
                      )}
                      {supplier.website && (
                        <div className="flex items-center space-x-2">
                          <Globe className="w-4 h-4" />
                          <a 
                            href={supplier.website}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="text-blue-600 hover:underline"
                          >
                            Sitio web
                          </a>
                        </div>
                      )}
                    </div>
                    
                    {supplier.description && (
                      <p className="text-sm text-gray-600 dark:text-gray-400 mt-3 line-clamp-2">
                        {supplier.description}
                      </p>
                    )}
                    
                    <div className="flex items-center justify-between mt-4">
                      <div className="flex items-center space-x-1">
                        <span className="text-yellow-500">★</span>
                        <span className="text-sm font-medium">
                          {Number(supplier.rating).toFixed(1)}
                        </span>
                        <span className="text-sm text-gray-500">
                          ({supplier.reviewCount})
                        </span>
                      </div>
                      {supplier.isVerified && (
                        <Badge variant="outline" className="text-green-600 border-green-200">
                          Verificado
                        </Badge>
                      )}
                    </div>
                  </CardContent>
                </Card>
              ))
            ) : (
              <div className="col-span-full text-center py-8 text-gray-500">
                <Store className="w-12 h-12 mx-auto mb-4 text-gray-300" />
                <p>No se encontraron proveedores</p>
              </div>
            )}
          </div>
        )}

        {/* Aviso de Plan Premium - Movido al final */}
        <div className="bg-gradient-to-r from-amber-50 to-orange-50 dark:from-amber-950 dark:to-orange-950 border border-amber-200 dark:border-amber-800 rounded-lg p-6 mt-8">
          <div className="flex items-start space-x-4">
            <Crown className="w-8 h-8 text-amber-600 dark:text-amber-400 flex-shrink-0 mt-1" />
            <div className="flex-1">
              <h3 className="text-lg font-semibold text-amber-800 dark:text-amber-200 mb-2">
                🚀 Funcionalidades Completas Próximamente de Pago
              </h3>
              <p className="text-amber-700 dark:text-amber-300 mb-4">
                Actualmente puedes explorar materiales y proveedores de forma gratuita. 
                Pronto lanzaremos nuestro plan premium con funcionalidades completas:
              </p>
              <ul className="text-sm text-amber-700 dark:text-amber-300 space-y-1 mb-4">
                <li>• Creación ilimitada de proyectos y presupuestos</li>
                <li>• Precios personalizados y cálculos APU completos</li>
                <li>• Generación de PDFs profesionales</li>
                <li>• Acceso a toda la base de datos de materiales</li>
                <li>• Herramientas avanzadas para constructores</li>
              </ul>
              <div className="flex space-x-3">
                <Button size="sm" className="bg-amber-600 hover:bg-amber-700 text-white">
                  Notificarme del Lanzamiento
                </Button>
                <Button size="sm" variant="outline" onClick={() => window.location.href = "/register"}>
                  Registrarse Gratis Ahora
                </Button>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Footer de Contacto */}
      <footer className="bg-gray-800 dark:bg-gray-900 text-white py-8 mt-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h3 className="text-xl font-semibold mb-4">¿Tienes consultas o sugerencias?</h3>
            <ContactForm 
              triggerText="Envíanos un mensaje con tus consultas o sugerencias"
              triggerVariant="outline"
              className="bg-transparent border-white text-white hover:bg-white hover:text-gray-800 flex items-center space-x-3 mx-auto text-base px-6 py-3"
            />
            <p className="text-gray-400 mt-4 text-sm">Sistema interno de mensajería MICAA</p>
            <div className="mt-6 pt-6 border-t border-gray-700">
              <p className="text-gray-500 text-sm">© 2025 MICAA. Sistema de Cómputos y Presupuestos para Bolivia.</p>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}