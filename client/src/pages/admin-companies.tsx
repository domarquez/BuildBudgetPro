import { useState } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import { queryClient } from "@/lib/queryClient";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { useToast } from "@/hooks/use-toast";
import { Search, Edit, Building2, Mail, Phone, MapPin, Globe, Image } from "lucide-react";

interface SupplierCompany {
  id: number;
  userId: number;
  companyName: string;
  businessType: string;
  address: string;
  phone: string;
  email: string;
  website: string;
  logo: string;
  speciality: string;
  description: string;
  isActive: boolean;
  isPremium: boolean;
  createdAt: string;
  updatedAt: string;
}

export default function AdminCompanies() {
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedType, setSelectedType] = useState<string>("all");
  const [editingCompany, setEditingCompany] = useState<SupplierCompany | null>(null);
  const [formData, setFormData] = useState<Partial<SupplierCompany>>({});
  const { toast } = useToast();

  // Fetch companies
  const { data: companies = [], isLoading } = useQuery<SupplierCompany[]>({
    queryKey: ["/api/admin/companies"],
  });

  // Update company mutation
  const updateCompanyMutation = useMutation({
    mutationFn: async (data: Partial<SupplierCompany> & { id: number }) => {
      const token = localStorage.getItem('auth_token');
      const response = await fetch(`/api/admin/companies/${data.id}`, {
        method: 'PUT',
        headers: { 
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify(data),
      });
      if (!response.ok) {
        throw new Error('Failed to update company');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/admin/companies"] });
      queryClient.invalidateQueries({ queryKey: ["/api/supplier-companies"] });
      toast({
        title: "Empresa actualizada",
        description: "La información de la empresa se actualizó correctamente.",
      });
      setEditingCompany(null);
      setFormData({});
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo actualizar la empresa.",
        variant: "destructive",
      });
    },
  });

  // Upload logo mutation
  const uploadLogoMutation = useMutation({
    mutationFn: async ({ companyId, file }: { companyId: number; file: File }) => {
      const token = localStorage.getItem('auth_token');
      const formData = new FormData();
      formData.append('logo', file);

      const response = await fetch(`/api/admin/companies/${companyId}/logo`, {
        method: 'POST',
        headers: { 
          'Authorization': `Bearer ${token}`
        },
        body: formData,
      });
      if (!response.ok) {
        throw new Error('Failed to upload logo');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/admin/companies"] });
      queryClient.invalidateQueries({ queryKey: ["/api/supplier-companies"] });
      toast({
        title: "Logo actualizado",
        description: "El logotipo se actualizó correctamente.",
      });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo actualizar el logotipo.",
        variant: "destructive",
      });
    },
  });

  const businessTypes = [
    "Construcción y Obras Civiles",
    "Materiales de Construcción",
    "Herramientas y Equipos",
    "Servicios Especializados",
    "Consultoría y Ingeniería",
    "Otro"
  ];

  const filteredCompanies = companies.filter((company) => {
    const matchesSearch = company.companyName.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         company.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         company.speciality.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = selectedType === "all" || company.businessType === selectedType;
    return matchesSearch && matchesType;
  });

  const handleEdit = (company: SupplierCompany) => {
    setEditingCompany(company);
    setFormData(company);
  };

  const handleSave = () => {
    if (!editingCompany || !formData.companyName) return;
    
    updateCompanyMutation.mutate({
      id: editingCompany.id,
      ...formData,
    });
  };

  const handleLogoUpload = (event: React.ChangeEvent<HTMLInputElement>, companyId: number) => {
    const file = event.target.files?.[0];
    if (file) {
      uploadLogoMutation.mutate({ companyId, file });
    }
  };

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
          <h1 className="text-3xl font-bold text-on-surface">Administración de Empresas</h1>
          <p className="text-on-surface/70 mt-2">
            Gestiona la información completa de todas las empresas proveedoras
          </p>
        </div>
      </div>

      {/* Filters */}
      <Card>
        <CardContent className="p-6">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-on-surface/50 w-4 h-4" />
                <Input
                  placeholder="Buscar empresas..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10"
                />
              </div>
            </div>
            <div className="w-full md:w-64">
              <Select value={selectedType} onValueChange={setSelectedType}>
                <SelectTrigger>
                  <SelectValue placeholder="Tipo de negocio" />
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
          </div>
        </CardContent>
      </Card>

      {/* Companies Table */}
      <Card>
        <CardHeader>
          <CardTitle>Empresas Registradas ({filteredCompanies.length})</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Logo</TableHead>
                  <TableHead>Empresa</TableHead>
                  <TableHead>Tipo</TableHead>
                  <TableHead>Especialidad</TableHead>
                  <TableHead>Contacto</TableHead>
                  <TableHead>Estado</TableHead>
                  <TableHead>Acciones</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredCompanies.map((company) => (
                  <TableRow key={company.id}>
                    <TableCell>
                      <div className="w-12 h-12 rounded-lg overflow-hidden bg-gray-100 flex items-center justify-center">
                        {company.logo ? (
                          <img 
                            src={company.logo} 
                            alt={company.companyName}
                            className="w-full h-full object-cover"
                          />
                        ) : (
                          <Building2 className="w-6 h-6 text-gray-400" />
                        )}
                      </div>
                    </TableCell>
                    <TableCell>
                      <div>
                        <div className="font-medium">{company.companyName}</div>
                        <div className="text-sm text-on-surface/60">{company.address}</div>
                      </div>
                    </TableCell>
                    <TableCell>
                      <Badge variant="outline">{company.businessType}</Badge>
                    </TableCell>
                    <TableCell>
                      <Badge variant="secondary">{company.speciality}</Badge>
                    </TableCell>
                    <TableCell>
                      <div className="space-y-1">
                        {company.email && (
                          <div className="flex items-center gap-1 text-sm">
                            <Mail className="w-3 h-3" />
                            {company.email}
                          </div>
                        )}
                        {company.phone && (
                          <div className="flex items-center gap-1 text-sm">
                            <Phone className="w-3 h-3" />
                            {company.phone}
                          </div>
                        )}
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="space-y-1">
                        <Badge variant={company.isActive ? "default" : "secondary"}>
                          {company.isActive ? "Activa" : "Inactiva"}
                        </Badge>
                        {company.isPremium && (
                          <Badge variant="default" className="bg-yellow-500">
                            Premium
                          </Badge>
                        )}
                      </div>
                    </TableCell>
                    <TableCell>
                      <Dialog>
                        <DialogTrigger asChild>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleEdit(company)}
                          >
                            <Edit className="w-4 h-4 mr-1" />
                            Editar
                          </Button>
                        </DialogTrigger>
                        <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
                          <DialogHeader>
                            <DialogTitle>Editar Empresa: {editingCompany?.companyName}</DialogTitle>
                          </DialogHeader>
                          {editingCompany && (
                            <div className="space-y-4">
                              <div className="grid grid-cols-2 gap-4">
                                <div>
                                  <Label htmlFor="companyName">Nombre de la Empresa</Label>
                                  <Input
                                    id="companyName"
                                    value={formData.companyName || ""}
                                    onChange={(e) => setFormData({ ...formData, companyName: e.target.value })}
                                  />
                                </div>
                                <div>
                                  <Label htmlFor="businessType">Tipo de Negocio</Label>
                                  <Select
                                    value={formData.businessType || ""}
                                    onValueChange={(value) => setFormData({ ...formData, businessType: value })}
                                  >
                                    <SelectTrigger>
                                      <SelectValue />
                                    </SelectTrigger>
                                    <SelectContent>
                                      {businessTypes.map((type) => (
                                        <SelectItem key={type} value={type}>
                                          {type}
                                        </SelectItem>
                                      ))}
                                    </SelectContent>
                                  </Select>
                                </div>
                              </div>

                              <div>
                                <Label htmlFor="speciality">Especialidad</Label>
                                <Input
                                  id="speciality"
                                  value={formData.speciality || ""}
                                  onChange={(e) => setFormData({ ...formData, speciality: e.target.value })}
                                />
                              </div>

                              <div>
                                <Label htmlFor="description">Descripción</Label>
                                <Textarea
                                  id="description"
                                  value={formData.description || ""}
                                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                                  rows={3}
                                />
                              </div>

                              <div>
                                <Label htmlFor="address">Dirección</Label>
                                <Textarea
                                  id="address"
                                  value={formData.address || ""}
                                  onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                                  rows={2}
                                />
                              </div>

                              <div className="grid grid-cols-2 gap-4">
                                <div>
                                  <Label htmlFor="phone">Teléfono</Label>
                                  <Input
                                    id="phone"
                                    value={formData.phone || ""}
                                    onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                                  />
                                </div>
                                <div>
                                  <Label htmlFor="email">Email</Label>
                                  <Input
                                    id="email"
                                    type="email"
                                    value={formData.email || ""}
                                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                                  />
                                </div>
                              </div>

                              <div>
                                <Label htmlFor="website">Sitio Web</Label>
                                <Input
                                  id="website"
                                  value={formData.website || ""}
                                  onChange={(e) => setFormData({ ...formData, website: e.target.value })}
                                />
                              </div>

                              <div>
                                <Label htmlFor="logo">Logotipo</Label>
                                <div className="flex items-center gap-4">
                                  {editingCompany.logo && (
                                    <img 
                                      src={editingCompany.logo} 
                                      alt="Logo actual"
                                      className="w-16 h-16 object-cover rounded-lg border"
                                    />
                                  )}
                                  <Input
                                    id="logo"
                                    type="file"
                                    accept="image/*"
                                    onChange={(e) => handleLogoUpload(e, editingCompany.id)}
                                    className="flex-1"
                                  />
                                </div>
                              </div>

                              <div className="grid grid-cols-2 gap-4">
                                <div className="flex items-center space-x-2">
                                  <input
                                    type="checkbox"
                                    id="isActive"
                                    checked={formData.isActive || false}
                                    onChange={(e) => setFormData({ ...formData, isActive: e.target.checked })}
                                    className="w-4 h-4"
                                  />
                                  <Label htmlFor="isActive">Empresa Activa</Label>
                                </div>
                                <div className="flex items-center space-x-2">
                                  <input
                                    type="checkbox"
                                    id="isPremium"
                                    checked={formData.isPremium || false}
                                    onChange={(e) => setFormData({ ...formData, isPremium: e.target.checked })}
                                    className="w-4 h-4"
                                  />
                                  <Label htmlFor="isPremium">Suscripción Premium</Label>
                                </div>
                              </div>

                              <div className="flex justify-end gap-2 pt-4">
                                <Button
                                  variant="outline"
                                  onClick={() => {
                                    setEditingCompany(null);
                                    setFormData({});
                                  }}
                                >
                                  Cancelar
                                </Button>
                                <Button
                                  onClick={handleSave}
                                  disabled={updateCompanyMutation.isPending}
                                >
                                  {updateCompanyMutation.isPending ? "Guardando..." : "Guardar Cambios"}
                                </Button>
                              </div>
                            </div>
                          )}
                        </DialogContent>
                      </Dialog>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}