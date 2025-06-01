import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { useToast } from "@/hooks/use-toast";
import { apiRequest } from "@/lib/queryClient";
import { 
  Building2, 
  Search, 
  Phone, 
  MapPin, 
  Edit, 
  Trash2, 
  CheckCircle, 
  XCircle,
  Filter,
  Users
} from "lucide-react";
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

interface SupplierCompany {
  id: number;
  company_name: string;
  business_type: string;
  address: string;
  city: string;
  phone: string;
  whatsapp: string;
  website: string;
  is_active: boolean;
  is_verified: boolean;
  rating: number;
  review_count: number;
  created_at: string;
  speciality: string;
}

export default function ManageSuppliers() {
  const [searchTerm, setSearchTerm] = useState("");
  const [businessTypeFilter, setBusinessTypeFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");
  const { toast } = useToast();
  const queryClient = useQueryClient();

  // Obtener todas las empresas
  const { data: suppliers = [], isLoading } = useQuery({
    queryKey: ["/api/admin/supplier-companies"],
    retry: false,
  });

  // Mutación para actualizar estado de empresa
  const updateSupplierMutation = useMutation({
    mutationFn: async ({ id, updates }: { id: number; updates: any }) => {
      return apiRequest("PATCH", `/api/admin/supplier-companies/${id}`, updates);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/admin/supplier-companies"] });
      toast({
        title: "Empresa actualizada",
        description: "Los cambios se guardaron correctamente",
      });
    },
    onError: (error) => {
      toast({
        title: "Error",
        description: "No se pudo actualizar la empresa",
        variant: "destructive",
      });
    },
  });

  // Mutación para eliminar empresa
  const deleteSupplierMutation = useMutation({
    mutationFn: async (id: number) => {
      return apiRequest("DELETE", `/api/admin/supplier-companies/${id}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/admin/supplier-companies"] });
      toast({
        title: "Empresa eliminada",
        description: "La empresa se eliminó correctamente",
      });
    },
    onError: (error) => {
      toast({
        title: "Error",
        description: "No se pudo eliminar la empresa",
        variant: "destructive",
      });
    },
  });

  // Filtrar empresas
  const filteredSuppliers = suppliers.filter((supplier: SupplierCompany) => {
    const matchesSearch = 
      supplier.company_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      supplier.address?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      supplier.phone?.includes(searchTerm);
    
    const matchesBusinessType = 
      businessTypeFilter === "all" || supplier.business_type === businessTypeFilter;
    
    const matchesStatus = 
      statusFilter === "all" || 
      (statusFilter === "active" && supplier.is_active) ||
      (statusFilter === "inactive" && !supplier.is_active) ||
      (statusFilter === "verified" && supplier.is_verified) ||
      (statusFilter === "unverified" && !supplier.is_verified);

    return matchesSearch && matchesBusinessType && matchesStatus;
  });

  // Obtener tipos de negocio únicos
  const businessTypes = [...new Set(suppliers.map((s: SupplierCompany) => s.business_type))];

  const toggleActive = (id: number, currentStatus: boolean) => {
    updateSupplierMutation.mutate({
      id,
      updates: { is_active: !currentStatus }
    });
  };

  const toggleVerified = (id: number, currentStatus: boolean) => {
    updateSupplierMutation.mutate({
      id,
      updates: { is_verified: !currentStatus }
    });
  };

  const deleteSupplier = (id: number) => {
    if (confirm("¿Estás seguro de que quieres eliminar esta empresa?")) {
      deleteSupplierMutation.mutate(id);
    }
  };

  if (isLoading) {
    return (
      <div className="container mx-auto p-6">
        <div className="animate-pulse space-y-4">
          <div className="h-8 bg-gray-200 rounded w-1/4"></div>
          <div className="h-64 bg-gray-200 rounded"></div>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold">Gestión de Empresas Proveedoras</h1>
          <p className="text-gray-600 mt-2">
            Total: {suppliers.length} empresas | Mostrando: {filteredSuppliers.length}
          </p>
        </div>
        <div className="flex items-center space-x-2">
          <Users className="w-5 h-5 text-blue-600" />
          <span className="text-sm font-medium">
            {suppliers.filter((s: SupplierCompany) => s.is_active).length} activas
          </span>
        </div>
      </div>

      {/* Filtros */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <Filter className="w-5 h-5" />
            <span>Filtros de Búsqueda</span>
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
              <label className="block text-sm font-medium mb-2">Buscar</label>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  placeholder="Nombre, dirección o teléfono..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium mb-2">Tipo de Negocio</label>
              <Select value={businessTypeFilter} onValueChange={setBusinessTypeFilter}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todos los tipos</SelectItem>
                  {businessTypes.map((type) => (
                    <SelectItem key={type} value={type}>
                      {type}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div>
              <label className="block text-sm font-medium mb-2">Estado</label>
              <Select value={statusFilter} onValueChange={setStatusFilter}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todos</SelectItem>
                  <SelectItem value="active">Activas</SelectItem>
                  <SelectItem value="inactive">Inactivas</SelectItem>
                  <SelectItem value="verified">Verificadas</SelectItem>
                  <SelectItem value="unverified">No verificadas</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="flex items-end">
              <Button 
                variant="outline" 
                onClick={() => {
                  setSearchTerm("");
                  setBusinessTypeFilter("all");
                  setStatusFilter("all");
                }}
                className="w-full"
              >
                Limpiar Filtros
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Tabla de empresas */}
      <Card>
        <CardHeader>
          <CardTitle>Lista de Empresas</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Empresa</TableHead>
                  <TableHead>Tipo de Negocio</TableHead>
                  <TableHead>Contacto</TableHead>
                  <TableHead>Ubicación</TableHead>
                  <TableHead>Estado</TableHead>
                  <TableHead>Fecha</TableHead>
                  <TableHead>Acciones</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredSuppliers.map((supplier: SupplierCompany) => (
                  <TableRow key={supplier.id}>
                    <TableCell>
                      <div className="space-y-1">
                        <div className="font-medium">{supplier.company_name}</div>
                        {supplier.speciality && (
                          <Badge variant="secondary" className="text-xs">
                            {supplier.speciality}
                          </Badge>
                        )}
                      </div>
                    </TableCell>
                    
                    <TableCell>
                      <Badge variant="outline">{supplier.business_type}</Badge>
                    </TableCell>
                    
                    <TableCell>
                      <div className="space-y-1 text-sm">
                        {supplier.phone && (
                          <div className="flex items-center space-x-1">
                            <Phone className="w-3 h-3" />
                            <span>{supplier.phone}</span>
                          </div>
                        )}
                        {supplier.website && (
                          <div className="text-blue-600 truncate max-w-32">
                            {supplier.website}
                          </div>
                        )}
                      </div>
                    </TableCell>
                    
                    <TableCell>
                      <div className="text-sm">
                        {supplier.address && (
                          <div className="flex items-start space-x-1">
                            <MapPin className="w-3 h-3 mt-0.5 flex-shrink-0" />
                            <span className="truncate max-w-48">{supplier.address}</span>
                          </div>
                        )}
                        {supplier.city && (
                          <div className="text-gray-500 mt-1">{supplier.city}</div>
                        )}
                      </div>
                    </TableCell>
                    
                    <TableCell>
                      <div className="space-y-1">
                        <div className="flex items-center space-x-2">
                          {supplier.is_active ? (
                            <Badge className="bg-green-100 text-green-800">Activa</Badge>
                          ) : (
                            <Badge variant="secondary">Inactiva</Badge>
                          )}
                        </div>
                        <div className="flex items-center space-x-2">
                          {supplier.is_verified ? (
                            <Badge className="bg-blue-100 text-blue-800">Verificada</Badge>
                          ) : (
                            <Badge variant="outline">No verificada</Badge>
                          )}
                        </div>
                      </div>
                    </TableCell>
                    
                    <TableCell>
                      <div className="text-xs text-gray-500">
                        {new Date(supplier.created_at).toLocaleDateString('es-BO')}
                      </div>
                    </TableCell>
                    
                    <TableCell>
                      <div className="flex items-center space-x-1">
                        <Button
                          size="sm"
                          variant="ghost"
                          onClick={() => toggleActive(supplier.id, supplier.is_active)}
                          disabled={updateSupplierMutation.isPending}
                        >
                          {supplier.is_active ? (
                            <XCircle className="w-4 h-4 text-red-600" />
                          ) : (
                            <CheckCircle className="w-4 h-4 text-green-600" />
                          )}
                        </Button>
                        
                        <Button
                          size="sm"
                          variant="ghost"
                          onClick={() => toggleVerified(supplier.id, supplier.is_verified)}
                          disabled={updateSupplierMutation.isPending}
                        >
                          <Edit className="w-4 h-4 text-blue-600" />
                        </Button>
                        
                        <Button
                          size="sm"
                          variant="ghost"
                          onClick={() => deleteSupplier(supplier.id)}
                          disabled={deleteSupplierMutation.isPending}
                        >
                          <Trash2 className="w-4 h-4 text-red-600" />
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
          
          {filteredSuppliers.length === 0 && (
            <div className="text-center py-8 text-gray-500">
              <Building2 className="mx-auto w-12 h-12 mb-4 opacity-50" />
              <p>No se encontraron empresas con los filtros aplicados</p>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}