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
import { Search, Edit, Eye, MousePointer, Calendar, Building2, Plus, Image, Trash2 } from "lucide-react";

interface Advertisement {
  id: number;
  supplierId: number;
  title: string;
  content: string;
  imageUrl: string;
  targetUrl: string;
  startDate: string;
  endDate: string;
  isActive: boolean;
  viewCount: number;
  clickCount: number;
  createdAt: string;
  supplier?: {
    id: number;
    companyName: string;
  };
}

interface SupplierCompany {
  id: number;
  companyName: string;
  isActive: boolean;
}

export default function AdminAdvertisements() {
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedStatus, setSelectedStatus] = useState<string>("all");
  const [editingAd, setEditingAd] = useState<Advertisement | null>(null);
  const [formData, setFormData] = useState<Partial<Advertisement>>({});
  const [showCreateDialog, setShowCreateDialog] = useState(false);
  const { toast } = useToast();

  // Fetch advertisements
  const { data: advertisements = [], isLoading } = useQuery<Advertisement[]>({
    queryKey: ["/api/admin/advertisements"],
  });

  // Fetch companies for creating new ads
  const { data: companies = [] } = useQuery<SupplierCompany[]>({
    queryKey: ["/api/admin/companies"],
  });

  // Create advertisement mutation
  const createAdMutation = useMutation({
    mutationFn: async (data: Partial<Advertisement>) => {
      const token = localStorage.getItem('auth_token');
      const response = await fetch('/api/admin/advertisements', {
        method: 'POST',
        headers: { 
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify(data),
      });
      if (!response.ok) {
        throw new Error('Failed to create advertisement');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/admin/advertisements"] });
      toast({
        title: "Publicidad creada",
        description: "La publicidad se creó correctamente.",
      });
      setShowCreateDialog(false);
      setFormData({});
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo crear la publicidad.",
        variant: "destructive",
      });
    },
  });

  // Update advertisement mutation
  const updateAdMutation = useMutation({
    mutationFn: async (data: Partial<Advertisement> & { id: number }) => {
      const token = localStorage.getItem('auth_token');
      const response = await fetch(`/api/admin/advertisements/${data.id}`, {
        method: 'PUT',
        headers: { 
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify(data),
      });
      if (!response.ok) {
        throw new Error('Failed to update advertisement');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/admin/advertisements"] });
      toast({
        title: "Publicidad actualizada",
        description: "La publicidad se actualizó correctamente.",
      });
      setEditingAd(null);
      setFormData({});
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo actualizar la publicidad.",
        variant: "destructive",
      });
    },
  });

  // Delete advertisement mutation
  const deleteAdMutation = useMutation({
    mutationFn: async (id: number) => {
      const token = localStorage.getItem('auth_token');
      const response = await fetch(`/api/admin/advertisements/${id}`, {
        method: 'DELETE',
        headers: { 
          'Authorization': `Bearer ${token}`
        },
      });
      if (!response.ok) {
        throw new Error('Failed to delete advertisement');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/admin/advertisements"] });
      toast({
        title: "Publicidad eliminada",
        description: "La publicidad se eliminó correctamente.",
      });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo eliminar la publicidad.",
        variant: "destructive",
      });
    },
  });

  // Upload image mutation
  const uploadImageMutation = useMutation({
    mutationFn: async ({ file }: { file: File }) => {
      const token = localStorage.getItem('auth_token');
      const formData = new FormData();
      formData.append('image', file);

      const response = await fetch('/api/admin/advertisements/upload-image', {
        method: 'POST',
        headers: { 
          'Authorization': `Bearer ${token}`
        },
        body: formData,
      });
      if (!response.ok) {
        throw new Error('Failed to upload image');
      }
      return response.json();
    },
    onSuccess: (data) => {
      setFormData(prev => ({ ...prev, imageUrl: data.imagePath }));
      toast({
        title: "Imagen subida",
        description: "La imagen se subió correctamente.",
      });
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo subir la imagen.",
        variant: "destructive",
      });
    },
  });

  const filteredAdvertisements = advertisements.filter((ad) => {
    const matchesSearch = ad.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         ad.supplier?.companyName.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = selectedStatus === "all" || 
                         (selectedStatus === "active" && ad.isActive) ||
                         (selectedStatus === "inactive" && !ad.isActive);
    return matchesSearch && matchesStatus;
  });

  const handleEdit = (ad: Advertisement) => {
    setEditingAd(ad);
    setFormData({
      ...ad,
      startDate: ad.startDate ? new Date(ad.startDate).toISOString().split('T')[0] : '',
      endDate: ad.endDate ? new Date(ad.endDate).toISOString().split('T')[0] : '',
    });
  };

  const handleSave = () => {
    if (!editingAd || !formData.title) return;
    
    updateAdMutation.mutate({
      id: editingAd.id,
      ...formData,
    });
  };

  const handleCreate = () => {
    if (!formData.title || !formData.supplierId) return;
    
    createAdMutation.mutate(formData);
  };

  const handleImageUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      uploadImageMutation.mutate({ file });
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
          <h1 className="text-3xl font-bold text-on-surface">Administración de Publicidades</h1>
          <p className="text-on-surface/70 mt-2">
            Gestiona las publicidades de las empresas proveedoras
          </p>
        </div>
        <Dialog open={showCreateDialog} onOpenChange={setShowCreateDialog}>
          <DialogTrigger asChild>
            <Button>
              <Plus className="w-4 h-4 mr-2" />
              Nueva Publicidad
            </Button>
          </DialogTrigger>
          <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>Crear Nueva Publicidad</DialogTitle>
            </DialogHeader>
            <div className="space-y-4">
              <div>
                <Label htmlFor="supplier">Empresa</Label>
                <Select
                  value={formData.supplierId?.toString() || ""}
                  onValueChange={(value) => setFormData({ ...formData, supplierId: parseInt(value) })}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Seleccionar empresa" />
                  </SelectTrigger>
                  <SelectContent>
                    {companies.filter(c => c.isActive).map((company) => (
                      <SelectItem key={company.id} value={company.id.toString()}>
                        {company.companyName}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div>
                <Label htmlFor="title">Título</Label>
                <Input
                  id="title"
                  value={formData.title || ""}
                  onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                />
              </div>

              <div>
                <Label htmlFor="content">Contenido</Label>
                <Textarea
                  id="content"
                  value={formData.content || ""}
                  onChange={(e) => setFormData({ ...formData, content: e.target.value })}
                  rows={3}
                />
              </div>

              <div>
                <Label htmlFor="targetUrl">URL de Destino</Label>
                <Input
                  id="targetUrl"
                  value={formData.targetUrl || ""}
                  onChange={(e) => setFormData({ ...formData, targetUrl: e.target.value })}
                  placeholder="https://..."
                />
              </div>

              <div>
                <Label htmlFor="image">Imagen</Label>
                <div className="flex items-center gap-4">
                  {formData.imageUrl && (
                    <img 
                      src={formData.imageUrl} 
                      alt="Preview"
                      className="w-16 h-16 object-cover rounded-lg border"
                    />
                  )}
                  <Input
                    id="image"
                    type="file"
                    accept="image/*"
                    onChange={handleImageUpload}
                    className="flex-1"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="startDate">Fecha de Inicio</Label>
                  <Input
                    id="startDate"
                    type="date"
                    value={formData.startDate || ""}
                    onChange={(e) => setFormData({ ...formData, startDate: e.target.value })}
                  />
                </div>
                <div>
                  <Label htmlFor="endDate">Fecha de Fin</Label>
                  <Input
                    id="endDate"
                    type="date"
                    value={formData.endDate || ""}
                    onChange={(e) => setFormData({ ...formData, endDate: e.target.value })}
                  />
                </div>
              </div>

              <div className="flex items-center space-x-2">
                <input
                  type="checkbox"
                  id="isActive"
                  checked={formData.isActive || false}
                  onChange={(e) => setFormData({ ...formData, isActive: e.target.checked })}
                  className="w-4 h-4"
                />
                <Label htmlFor="isActive">Publicidad Activa</Label>
              </div>

              <div className="flex justify-end gap-2 pt-4">
                <Button
                  variant="outline"
                  onClick={() => {
                    setShowCreateDialog(false);
                    setFormData({});
                  }}
                >
                  Cancelar
                </Button>
                <Button
                  onClick={handleCreate}
                  disabled={createAdMutation.isPending}
                >
                  {createAdMutation.isPending ? "Creando..." : "Crear Publicidad"}
                </Button>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      {/* Filters */}
      <Card>
        <CardContent className="p-6">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-on-surface/50 w-4 h-4" />
                <Input
                  placeholder="Buscar publicidades..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10"
                />
              </div>
            </div>
            <div className="w-full md:w-64">
              <Select value={selectedStatus} onValueChange={setSelectedStatus}>
                <SelectTrigger>
                  <SelectValue placeholder="Estado" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todas</SelectItem>
                  <SelectItem value="active">Activas</SelectItem>
                  <SelectItem value="inactive">Inactivas</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Advertisements Table */}
      <Card>
        <CardHeader>
          <CardTitle>Publicidades ({filteredAdvertisements.length})</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Imagen</TableHead>
                  <TableHead>Título</TableHead>
                  <TableHead>Empresa</TableHead>
                  <TableHead>Estado</TableHead>
                  <TableHead>Estadísticas</TableHead>
                  <TableHead>Fechas</TableHead>
                  <TableHead>Acciones</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredAdvertisements.map((ad) => (
                  <TableRow key={ad.id}>
                    <TableCell>
                      <div className="w-16 h-16 rounded-lg overflow-hidden bg-gray-100 flex items-center justify-center">
                        {ad.imageUrl ? (
                          <img 
                            src={ad.imageUrl} 
                            alt={ad.title}
                            className="w-full h-full object-cover"
                          />
                        ) : (
                          <Image className="w-6 h-6 text-gray-400" />
                        )}
                      </div>
                    </TableCell>
                    <TableCell>
                      <div>
                        <div className="font-medium">{ad.title}</div>
                        <div className="text-sm text-on-surface/60 line-clamp-2">{ad.content}</div>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        <Building2 className="w-4 h-4" />
                        {ad.supplier?.companyName}
                      </div>
                    </TableCell>
                    <TableCell>
                      <Badge variant={ad.isActive ? "default" : "secondary"}>
                        {ad.isActive ? "Activa" : "Inactiva"}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <div className="space-y-1">
                        <div className="flex items-center gap-1 text-sm">
                          <Eye className="w-3 h-3" />
                          {ad.viewCount} vistas
                        </div>
                        <div className="flex items-center gap-1 text-sm">
                          <MousePointer className="w-3 h-3" />
                          {ad.clickCount} clics
                        </div>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="space-y-1 text-sm">
                        {ad.startDate && (
                          <div>Desde: {new Date(ad.startDate).toLocaleDateString()}</div>
                        )}
                        {ad.endDate && (
                          <div>Hasta: {new Date(ad.endDate).toLocaleDateString()}</div>
                        )}
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex gap-2">
                        <Dialog>
                          <DialogTrigger asChild>
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => handleEdit(ad)}
                            >
                              <Edit className="w-4 h-4" />
                            </Button>
                          </DialogTrigger>
                          <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
                            <DialogHeader>
                              <DialogTitle>Editar Publicidad: {editingAd?.title}</DialogTitle>
                            </DialogHeader>
                            {editingAd && (
                              <div className="space-y-4">
                                <div>
                                  <Label htmlFor="editTitle">Título</Label>
                                  <Input
                                    id="editTitle"
                                    value={formData.title || ""}
                                    onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                                  />
                                </div>

                                <div>
                                  <Label htmlFor="editContent">Contenido</Label>
                                  <Textarea
                                    id="editContent"
                                    value={formData.content || ""}
                                    onChange={(e) => setFormData({ ...formData, content: e.target.value })}
                                    rows={3}
                                  />
                                </div>

                                <div>
                                  <Label htmlFor="editTargetUrl">URL de Destino</Label>
                                  <Input
                                    id="editTargetUrl"
                                    value={formData.targetUrl || ""}
                                    onChange={(e) => setFormData({ ...formData, targetUrl: e.target.value })}
                                  />
                                </div>

                                <div>
                                  <Label htmlFor="editImage">Imagen</Label>
                                  <div className="flex items-center gap-4">
                                    {formData.imageUrl && (
                                      <img 
                                        src={formData.imageUrl} 
                                        alt="Preview"
                                        className="w-16 h-16 object-cover rounded-lg border"
                                      />
                                    )}
                                    <Input
                                      id="editImage"
                                      type="file"
                                      accept="image/*"
                                      onChange={handleImageUpload}
                                      className="flex-1"
                                    />
                                  </div>
                                </div>

                                <div className="grid grid-cols-2 gap-4">
                                  <div>
                                    <Label htmlFor="editStartDate">Fecha de Inicio</Label>
                                    <Input
                                      id="editStartDate"
                                      type="date"
                                      value={formData.startDate || ""}
                                      onChange={(e) => setFormData({ ...formData, startDate: e.target.value })}
                                    />
                                  </div>
                                  <div>
                                    <Label htmlFor="editEndDate">Fecha de Fin</Label>
                                    <Input
                                      id="editEndDate"
                                      type="date"
                                      value={formData.endDate || ""}
                                      onChange={(e) => setFormData({ ...formData, endDate: e.target.value })}
                                    />
                                  </div>
                                </div>

                                <div className="flex items-center space-x-2">
                                  <input
                                    type="checkbox"
                                    id="editIsActive"
                                    checked={formData.isActive || false}
                                    onChange={(e) => setFormData({ ...formData, isActive: e.target.checked })}
                                    className="w-4 h-4"
                                  />
                                  <Label htmlFor="editIsActive">Publicidad Activa</Label>
                                </div>

                                <div className="flex justify-end gap-2 pt-4">
                                  <Button
                                    variant="outline"
                                    onClick={() => {
                                      setEditingAd(null);
                                      setFormData({});
                                    }}
                                  >
                                    Cancelar
                                  </Button>
                                  <Button
                                    onClick={handleSave}
                                    disabled={updateAdMutation.isPending}
                                  >
                                    {updateAdMutation.isPending ? "Guardando..." : "Guardar Cambios"}
                                  </Button>
                                </div>
                              </div>
                            )}
                          </DialogContent>
                        </Dialog>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => deleteAdMutation.mutate(ad.id)}
                          disabled={deleteAdMutation.isPending}
                        >
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
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