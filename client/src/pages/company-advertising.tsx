import { useState } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { useToast } from "@/hooks/use-toast";
import { 
  Plus, 
  Eye,
  MousePointer,
  Calendar,
  Upload,
  Trash2,
  Edit,
  Camera,
  Crown
} from "lucide-react";
import { formatCurrency, formatRelativeTime } from "@/lib/utils";
import { queryClient, apiRequest } from "@/lib/queryClient";
import type { CompanyAdvertisement } from "@shared/schema";

export default function CompanyAdvertising() {
  const [showForm, setShowForm] = useState(false);
  const [editingAd, setEditingAd] = useState<CompanyAdvertisement | null>(null);
  const { toast } = useToast();

  // Form state
  const [formData, setFormData] = useState({
    title: "",
    description: "",
    imageUrl: "",
    linkUrl: "",
    adType: "banner",
    startDate: "",
    endDate: "",
  });

  const [uploadingImage, setUploadingImage] = useState(false);
  const [selectedFile, setSelectedFile] = useState<File | null>(null);

  const { data: advertisements, isLoading } = useQuery<CompanyAdvertisement[]>({
    queryKey: ["/api/advertisements"],
  });

  const createMutation = useMutation({
    mutationFn: async (data: typeof formData) => {
      return await apiRequest("POST", "/api/advertisements", data);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/advertisements"] });
      toast({
        title: "Publicidad creada",
        description: "Tu anuncio ha sido creado exitosamente.",
      });
      setShowForm(false);
      resetForm();
    },
    onError: () => {
      toast({
        title: "Error",
        description: "No se pudo crear la publicidad.",
        variant: "destructive",
      });
    },
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: number) => {
      return await apiRequest("DELETE", `/api/advertisements/${id}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/advertisements"] });
      toast({
        title: "Publicidad eliminada",
        description: "El anuncio ha sido eliminado correctamente.",
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

  const uploadImageMutation = useMutation({
    mutationFn: async (file: File) => {
      const formData = new FormData();
      formData.append('image', file);
      
      // Get the correct auth token
      const token = localStorage.getItem('auth_token');
      
      const response = await fetch('/api/upload-advertisement-image', {
        method: 'POST',
        body: formData,
        headers: {
          'Authorization': `Bearer ${token}`
        },
        credentials: 'include'
      });
      
      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.message || 'Error uploading image');
      }
      
      return response.json();
    },
    onSuccess: (data) => {
      setFormData(prev => ({ ...prev, imageUrl: data.imageUrl }));
      setSelectedFile(null);
      toast({
        title: "Imagen subida",
        description: "La imagen ha sido procesada y optimizada exitosamente.",
      });
    },
    onError: (error: Error) => {
      toast({
        title: "Error",
        description: error.message || "No se pudo subir la imagen.",
        variant: "destructive",
      });
    },
  });

  const resetForm = () => {
    setFormData({
      title: "",
      description: "",
      imageUrl: "",
      linkUrl: "",
      adType: "banner",
      startDate: "",
      endDate: "",
    });
    setEditingAd(null);
    setSelectedFile(null);
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    createMutation.mutate(formData);
  };

  const handleEdit = (ad: CompanyAdvertisement) => {
    setEditingAd(ad);
    setFormData({
      title: ad.title,
      description: ad.description || "",
      imageUrl: ad.imageUrl,
      linkUrl: ad.linkUrl || "",
      adType: ad.adType,
      startDate: ad.startDate ? new Date(ad.startDate).toISOString().split('T')[0] : "",
      endDate: ad.endDate ? new Date(ad.endDate).toISOString().split('T')[0] : "",
    });
    setShowForm(true);
  };

  const handleDelete = (id: number) => {
    if (confirm("¿Está seguro de que desea eliminar esta publicidad?")) {
      deleteMutation.mutate(id);
    }
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      if (file.size > 5 * 1024 * 1024) {
        toast({
          title: "Error",
          description: "La imagen no puede superar los 5MB.",
          variant: "destructive",
        });
        return;
      }
      
      if (!file.type.startsWith('image/')) {
        toast({
          title: "Error",
          description: "Solo se permiten archivos de imagen.",
          variant: "destructive",
        });
        return;
      }
      
      setSelectedFile(file);
    }
  };

  const handleUploadImage = () => {
    if (selectedFile) {
      uploadImageMutation.mutate(selectedFile);
    }
  };

  const getAdTypeLabel = (type: string) => {
    switch (type) {
      case "banner": return "Banner";
      case "featured": return "Destacado";
      case "popup": return "Emergente";
      default: return "Banner";
    }
  };

  const getAdTypeBadgeColor = (type: string) => {
    switch (type) {
      case "banner": return "secondary";
      case "featured": return "default";
      case "popup": return "destructive";
      default: return "secondary";
    }
  };

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center space-y-4 sm:space-y-0">
        <div>
          <h2 className="text-2xl font-bold text-on-surface">Gestión de Publicidad</h2>
          <p className="text-gray-600">Administra los anuncios de tu empresa</p>
        </div>
        <Button
          onClick={() => setShowForm(true)}
          className="bg-primary text-white hover:bg-primary-variant"
        >
          <Plus className="w-4 h-4 mr-2" />
          Crear Publicidad
        </Button>
      </div>

      {/* Plan Premium Notice */}
      <div className="bg-gradient-to-r from-amber-50 to-orange-50 dark:from-amber-950 dark:to-orange-950 border border-amber-200 dark:border-amber-800 rounded-lg p-6">
        <div className="flex items-start space-x-4">
          <Crown className="w-8 h-8 text-amber-600 dark:text-amber-400 flex-shrink-0 mt-1" />
          <div className="flex-1">
            <h3 className="text-lg font-semibold text-amber-800 dark:text-amber-200 mb-2">
              🚀 Publicidad Premium Próximamente
            </h3>
            <p className="text-amber-700 dark:text-amber-300 mb-4">
              Pronto lanzaremos nuestro sistema de publicidad premium que permitirá a tu empresa:
            </p>
            <ul className="text-sm text-amber-700 dark:text-amber-300 space-y-1 mb-4">
              <li>• Aparecer en la vista pública de MICA</li>
              <li>• Promocionar productos específicos con imágenes</li>
              <li>• Obtener estadísticas detalladas de visualizaciones</li>
              <li>• Posicionamiento prioritario en búsquedas</li>
              <li>• Enlaces directos a tu sitio web o WhatsApp</li>
            </ul>
            <div className="flex space-x-3">
              <Button size="sm" className="bg-amber-600 hover:bg-amber-700 text-white">
                Notificarme del Lanzamiento
              </Button>
              <Button size="sm" variant="outline">
                Ver Planes de Precios
              </Button>
            </div>
          </div>
        </div>
      </div>

      {/* Current Advertisements */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <Camera className="w-5 h-5" />
            <span>Mis Publicidades</span>
          </CardTitle>
        </CardHeader>
        <CardContent>
          {isLoading ? (
            <div className="flex items-center justify-center py-8">
              <div className="animate-spin w-8 h-8 border-4 border-primary border-t-transparent rounded-full" />
            </div>
          ) : advertisements && advertisements.length > 0 ? (
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Publicidad</TableHead>
                    <TableHead>Tipo</TableHead>
                    <TableHead>Estado</TableHead>
                    <TableHead>Estadísticas</TableHead>
                    <TableHead>Fechas</TableHead>
                    <TableHead className="text-right">Acciones</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {advertisements.map((ad) => (
                    <TableRow key={ad.id}>
                      <TableCell>
                        <div className="flex items-center space-x-3">
                          {ad.imageUrl && (
                            <img 
                              src={ad.imageUrl} 
                              alt={ad.title}
                              className="w-12 h-12 object-cover rounded-lg"
                            />
                          )}
                          <div>
                            <div className="font-medium">{ad.title}</div>
                            {ad.description && (
                              <div className="text-sm text-gray-500 line-clamp-1">
                                {ad.description}
                              </div>
                            )}
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <Badge variant={getAdTypeBadgeColor(ad.adType)}>
                          {getAdTypeLabel(ad.adType)}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <Badge variant={ad.isActive ? "default" : "secondary"}>
                          {ad.isActive ? "Activo" : "Inactivo"}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <div className="flex items-center space-x-4 text-sm">
                          <div className="flex items-center space-x-1">
                            <Eye className="w-4 h-4 text-gray-400" />
                            <span>{ad.viewCount}</span>
                          </div>
                          <div className="flex items-center space-x-1">
                            <MousePointer className="w-4 h-4 text-gray-400" />
                            <span>{ad.clickCount}</span>
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="text-sm">
                          <div>Inicio: {ad.startDate ? new Date(ad.startDate).toLocaleDateString() : "No definido"}</div>
                          {ad.endDate && (
                            <div className="text-gray-500">Fin: {new Date(ad.endDate).toLocaleDateString()}</div>
                          )}
                        </div>
                      </TableCell>
                      <TableCell>
                        <div className="flex justify-end space-x-2">
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => handleEdit(ad)}
                            className="text-primary hover:text-primary-variant"
                          >
                            <Edit className="w-4 h-4" />
                          </Button>
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => handleDelete(ad.id)}
                            className="text-red-600 hover:text-red-900"
                            disabled={deleteMutation.isPending}
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
          ) : (
            <div className="text-center py-8 text-gray-500">
              <Camera className="w-12 h-12 mx-auto mb-4 text-gray-300" />
              <p>No tienes publicidades creadas</p>
              <p className="text-sm">Crea tu primera publicidad para aparecer en MICA</p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Create/Edit Advertisement Modal */}
      <Dialog open={showForm} onOpenChange={setShowForm}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>
              {editingAd ? "Editar Publicidad" : "Crear Nueva Publicidad"}
            </DialogTitle>
            <DialogDescription>
              Crea un anuncio para promocionar tu empresa en MICA. Los usuarios podrán ver tu publicidad en la vista pública.
            </DialogDescription>
          </DialogHeader>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="md:col-span-2">
                <Label htmlFor="title">Título del Anuncio *</Label>
                <Input
                  id="title"
                  value={formData.title}
                  onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                  placeholder="Ej: Oferta Especial en Cemento Portland"
                  required
                />
              </div>
              
              <div className="md:col-span-2">
                <Label htmlFor="description">Descripción</Label>
                <Textarea
                  id="description"
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  placeholder="Describe tu oferta o producto..."
                  rows={3}
                />
              </div>

              <div className="md:col-span-2">
                <Label htmlFor="imageUrl">Imagen del Anuncio *</Label>
                
                {/* File Upload Section */}
                <div className="space-y-4">
                  <div className="border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg p-6">
                    <div className="text-center">
                      <Upload className="mx-auto h-12 w-12 text-gray-400" />
                      <div className="mt-4">
                        <Label htmlFor="file-upload" className="cursor-pointer">
                          <span className="mt-2 block text-sm font-medium text-gray-900 dark:text-gray-100">
                            Sube una imagen
                          </span>
                          <span className="text-xs text-gray-500">
                            JPG, PNG hasta 5MB (se redimensionará automáticamente a 400x400px)
                          </span>
                        </Label>
                        <Input
                          id="file-upload"
                          type="file"
                          className="hidden"
                          accept="image/*"
                          onChange={handleFileChange}
                        />
                      </div>
                    </div>
                  </div>

                  {selectedFile && (
                    <div className="flex items-center justify-between p-3 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
                      <div className="flex items-center space-x-3">
                        <Camera className="w-5 h-5 text-blue-600" />
                        <div>
                          <p className="text-sm font-medium">{selectedFile.name}</p>
                          <p className="text-xs text-gray-500">
                            {(selectedFile.size / (1024 * 1024)).toFixed(2)} MB
                          </p>
                        </div>
                      </div>
                      <Button
                        type="button"
                        size="sm"
                        onClick={handleUploadImage}
                        disabled={uploadImageMutation.isPending}
                        className="bg-blue-600 hover:bg-blue-700"
                      >
                        {uploadImageMutation.isPending ? "Procesando..." : "Subir"}
                      </Button>
                    </div>
                  )}

                  {/* Alternative URL Input */}
                  <div className="relative">
                    <div className="absolute inset-0 flex items-center">
                      <span className="w-full border-t border-gray-300 dark:border-gray-600" />
                    </div>
                    <div className="relative flex justify-center text-xs uppercase">
                      <span className="bg-white dark:bg-gray-900 px-2 text-gray-500">O usa una URL</span>
                    </div>
                  </div>

                  <Input
                    id="imageUrl"
                    type="url"
                    value={formData.imageUrl}
                    onChange={(e) => setFormData({ ...formData, imageUrl: e.target.value })}
                    placeholder="https://ejemplo.com/imagen.jpg"
                  />
                </div>
              </div>

              <div>
                <Label htmlFor="linkUrl">Enlace (Opcional)</Label>
                <Input
                  id="linkUrl"
                  type="url"
                  value={formData.linkUrl}
                  onChange={(e) => setFormData({ ...formData, linkUrl: e.target.value })}
                  placeholder="https://tu-sitio-web.com o https://wa.me/59176543210"
                />
              </div>

              <div>
                <Label htmlFor="adType">Tipo de Anuncio</Label>
                <Select value={formData.adType} onValueChange={(value) => setFormData({ ...formData, adType: value })}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="banner">Banner</SelectItem>
                    <SelectItem value="featured">Destacado</SelectItem>
                    <SelectItem value="popup">Emergente</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div>
                <Label htmlFor="startDate">Fecha de Inicio</Label>
                <Input
                  id="startDate"
                  type="date"
                  value={formData.startDate}
                  onChange={(e) => setFormData({ ...formData, startDate: e.target.value })}
                />
              </div>

              <div>
                <Label htmlFor="endDate">Fecha de Fin (Opcional)</Label>
                <Input
                  id="endDate"
                  type="date"
                  value={formData.endDate}
                  onChange={(e) => setFormData({ ...formData, endDate: e.target.value })}
                />
              </div>
            </div>

            {formData.imageUrl && (
              <div>
                <Label>Vista Previa</Label>
                <div className="border rounded-lg p-4 bg-gray-50 dark:bg-gray-800">
                  <img 
                    src={formData.imageUrl} 
                    alt="Vista previa"
                    className="w-full h-32 object-cover rounded-lg mb-2"
                    onError={(e) => {
                      e.currentTarget.style.display = 'none';
                    }}
                  />
                  <h4 className="font-semibold">{formData.title || "Título del anuncio"}</h4>
                  <p className="text-sm text-gray-600">{formData.description || "Descripción del anuncio"}</p>
                </div>
              </div>
            )}
          </form>
          <DialogFooter>
            <Button
              type="button"
              variant="outline"
              onClick={() => {
                setShowForm(false);
                resetForm();
              }}
            >
              Cancelar
            </Button>
            <Button
              type="submit"
              onClick={handleSubmit}
              disabled={createMutation.isPending || !formData.title || !formData.imageUrl}
            >
              {createMutation.isPending ? "Guardando..." : editingAd ? "Actualizar" : "Crear Publicidad"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}