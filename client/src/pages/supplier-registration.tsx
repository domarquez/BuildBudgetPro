import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { apiRequest } from "@/lib/queryClient";
import { useToast } from "@/hooks/use-toast";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Building2, Phone, Globe, Facebook, MessageCircle, MapPin, Upload } from "lucide-react";

const supplierCompanySchema = z.object({
  companyName: z.string().min(2, "Nombre de empresa es requerido"),
  businessType: z.string().optional(),
  speciality: z.string().optional(),
  description: z.string().optional(),
  address: z.string().optional(),
  city: z.string().optional(),
  phone: z.string().optional(),
  whatsapp: z.string().optional(),
  website: z.string().url("URL inválida").optional().or(z.literal("")),
  facebook: z.string().optional(),
  logoUrl: z.string().optional(),
});

type SupplierCompanyForm = z.infer<typeof supplierCompanySchema>;

export default function SupplierRegistration() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [isEditing, setIsEditing] = useState(false);
  const [logoFile, setLogoFile] = useState<File | null>(null);
  const [logoPreview, setLogoPreview] = useState<string | null>(null);

  // Get current user's supplier company
  const { data: company, isLoading } = useQuery({
    queryKey: ["/api/my-supplier-company"],
  });

  const form = useForm<SupplierCompanyForm>({
    resolver: zodResolver(supplierCompanySchema),
    defaultValues: {
      companyName: (company as any)?.companyName || "",
      businessType: (company as any)?.businessType || "",
      speciality: (company as any)?.speciality || "",
      description: (company as any)?.description || "",
      address: (company as any)?.address || "",
      city: (company as any)?.city || "",
      phone: (company as any)?.phone || "",
      whatsapp: (company as any)?.whatsapp || "",
      website: (company as any)?.website || "",
      facebook: (company as any)?.facebook || "",
      logoUrl: (company as any)?.logoUrl || "",
    },
  });

  // Reset form when company data loads
  useState(() => {
    if (company) {
      form.reset({
        companyName: (company as any).companyName || "",
        businessType: (company as any).businessType || "",
        speciality: (company as any).speciality || "",
        description: (company as any).description || "",
        address: (company as any).address || "",
        city: (company as any).city || "",
        phone: (company as any).phone || "",
        whatsapp: (company as any).whatsapp || "",
        website: (company as any).website || "",
        facebook: (company as any).facebook || "",
        logoUrl: (company as any).logoUrl || "",
      });
    }
  });

  const createMutation = useMutation({
    mutationFn: async (data: SupplierCompanyForm) => {
      return await apiRequest("POST", "/api/supplier-companies", data);
    },
    onSuccess: () => {
      toast({
        title: "Éxito",
        description: "Empresa proveedora registrada exitosamente",
      });
      queryClient.invalidateQueries({ queryKey: ["/api/my-supplier-company"] });
      setIsEditing(false);
    },
    onError: (error: any) => {
      toast({
        title: "Error",
        description: error.message || "Error al registrar empresa",
        variant: "destructive",
      });
    },
  });

  const updateMutation = useMutation({
    mutationFn: async (data: SupplierCompanyForm) => {
      return await apiRequest("PUT", `/api/supplier-companies/${(company as any).id}`, data);
    },
    onSuccess: () => {
      toast({
        title: "Éxito",
        description: "Empresa actualizada exitosamente",
      });
      queryClient.invalidateQueries({ queryKey: ["/api/my-supplier-company"] });
      setIsEditing(false);
    },
    onError: (error: any) => {
      toast({
        title: "Error",
        description: error.message || "Error al actualizar empresa",
        variant: "destructive",
      });
    },
  });

  // Handle logo upload
  const handleLogoUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    // Validate file size (5MB max)
    if (file.size > 5 * 1024 * 1024) {
      toast({
        title: "Error",
        description: "El archivo es demasiado grande. Máximo 5MB.",
        variant: "destructive",
      });
      return;
    }

    // Validate file type
    if (!file.type.startsWith('image/')) {
      toast({
        title: "Error",
        description: "Solo se permiten archivos de imagen.",
        variant: "destructive",
      });
      return;
    }

    setLogoFile(file);

    // Create preview
    const reader = new FileReader();
    reader.onload = (e) => {
      setLogoPreview(e.target?.result as string);
    };
    reader.readAsDataURL(file);
  };

  const onSubmit = async (data: SupplierCompanyForm) => {
    let logoUrl = (company as any)?.logoUrl;

    // Upload logo if a new file is selected
    if (logoFile) {
      const formData = new FormData();
      formData.append('logo', logoFile);

      try {
        const response = await fetch('/api/upload/logo', {
          method: 'POST',
          body: formData,
        });

        if (!response.ok) {
          throw new Error('Error al subir el logo');
        }

        const result = await response.json();
        logoUrl = result.logoUrl;
      } catch (error) {
        toast({
          title: "Error",
          description: "Error al subir el logo. Intenta de nuevo.",
          variant: "destructive",
        });
        return;
      }
    }

    const submissionData = {
      ...data,
      logoUrl
    };

    if (company) {
      updateMutation.mutate(submissionData);
    } else {
      createMutation.mutate(submissionData);
    }
  };

  if (isLoading) {
    return (
      <div className="container mx-auto py-8">
        <div className="animate-pulse space-y-4">
          <div className="h-8 bg-gray-200 rounded w-64"></div>
          <div className="h-64 bg-gray-200 rounded"></div>
        </div>
      </div>
    );
  }

  const isReadOnly = company && !isEditing;

  return (
    <div className="container mx-auto py-8">
      <div className="max-w-4xl mx-auto">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-4">
            {company ? "Mi Empresa Proveedora" : "Registro de Empresa Proveedora"}
          </h1>
          <p className="text-lg text-gray-600">
            {company 
              ? "Gestiona la información de tu empresa y conecta con arquitectos y constructores"
              : "Registra tu empresa para ofrecer materiales de construcción con precios competitivos"
            }
          </p>
        </div>

        <Card>
          <CardHeader>
            <div className="flex justify-between items-center">
              <div>
                <CardTitle className="flex items-center gap-2">
                  <Building2 className="h-5 w-5" />
                  Información de la Empresa
                </CardTitle>
                <CardDescription>
                  Completa los datos de tu empresa para que los clientes puedan contactarte
                </CardDescription>
              </div>
              {company && (
                <Button
                  variant={isEditing ? "outline" : "default"}
                  onClick={() => setIsEditing(!isEditing)}
                >
                  {isEditing ? "Cancelar" : "Editar"}
                </Button>
              )}
            </div>
          </CardHeader>
          <CardContent>
            <Form {...form}>
              <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <FormField
                    control={form.control}
                    name="companyName"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Nombre de la Empresa *</FormLabel>
                        <FormControl>
                          <Input 
                            placeholder="Ej: Materiales La Paz S.R.L." 
                            {...field} 
                            disabled={isReadOnly}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="businessType"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Tipo de Negocio</FormLabel>
                        <Select 
                          onValueChange={field.onChange} 
                          defaultValue={field.value}
                          disabled={isReadOnly}
                        >
                          <FormControl>
                            <SelectTrigger>
                              <SelectValue placeholder="Selecciona tipo de negocio" />
                            </SelectTrigger>
                          </FormControl>
                          <SelectContent>
                            <SelectItem value="wholesaler">Mayorista</SelectItem>
                            <SelectItem value="retailer">Minorista</SelectItem>
                            <SelectItem value="manufacturer">Fabricante</SelectItem>
                            <SelectItem value="distributor">Distribuidor</SelectItem>
                          </SelectContent>
                        </Select>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="speciality"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Rubro/Especialidad</FormLabel>
                        <Select 
                          onValueChange={field.onChange} 
                          defaultValue={field.value}
                          disabled={isReadOnly}
                        >
                          <FormControl>
                            <SelectTrigger>
                              <SelectValue placeholder="Selecciona tu especialidad" />
                            </SelectTrigger>
                          </FormControl>
                          <SelectContent>
                            <SelectItem value="acero">Acero para Construcción</SelectItem>
                            <SelectItem value="aluminio">Aluminio</SelectItem>
                            <SelectItem value="cemento">Cemento y Hormigón</SelectItem>
                            <SelectItem value="agua">Agua y Saneamiento</SelectItem>
                            <SelectItem value="electricos">Materiales Eléctricos</SelectItem>
                            <SelectItem value="ceramicos">Cerámicos y Pisos</SelectItem>
                            <SelectItem value="maderas">Maderas</SelectItem>
                            <SelectItem value="pinturas">Pinturas y Acabados</SelectItem>
                            <SelectItem value="plomeria">Plomería y Gasfitería</SelectItem>
                            <SelectItem value="prefabricados">Elementos Prefabricados</SelectItem>
                            <SelectItem value="herramientas">Herramientas y Equipos</SelectItem>
                            <SelectItem value="seguridad">Seguridad Industrial</SelectItem>
                            <SelectItem value="aislantes">Materiales Aislantes</SelectItem>
                            <SelectItem value="vidrios">Vidrios y Cristales</SelectItem>
                            <SelectItem value="general">General/Varios</SelectItem>
                          </SelectContent>
                        </Select>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <FormField
                  control={form.control}
                  name="description"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Descripción de la Empresa</FormLabel>
                      <FormControl>
                        <Textarea
                          placeholder="Describe tu empresa, productos principales y experiencia..."
                          className="min-h-[100px]"
                          {...field}
                          disabled={isReadOnly}
                        />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <FormField
                    control={form.control}
                    name="address"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className="flex items-center gap-2">
                          <MapPin className="h-4 w-4" />
                          Dirección
                        </FormLabel>
                        <FormControl>
                          <Input 
                            placeholder="Av. Principal #123, Zona Centro" 
                            {...field}
                            disabled={isReadOnly}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="city"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Ciudad</FormLabel>
                        <Select 
                          onValueChange={field.onChange} 
                          defaultValue={field.value}
                          disabled={isReadOnly}
                        >
                          <FormControl>
                            <SelectTrigger>
                              <SelectValue placeholder="Selecciona ciudad" />
                            </SelectTrigger>
                          </FormControl>
                          <SelectContent>
                            <SelectItem value="La Paz">La Paz</SelectItem>
                            <SelectItem value="Santa Cruz">Santa Cruz</SelectItem>
                            <SelectItem value="Cochabamba">Cochabamba</SelectItem>
                            <SelectItem value="Potosí">Potosí</SelectItem>
                            <SelectItem value="Oruro">Oruro</SelectItem>
                            <SelectItem value="Sucre">Sucre</SelectItem>
                            <SelectItem value="Tarija">Tarija</SelectItem>
                            <SelectItem value="Trinidad">Trinidad</SelectItem>
                            <SelectItem value="Cobija">Cobija</SelectItem>
                          </SelectContent>
                        </Select>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <FormField
                    control={form.control}
                    name="phone"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className="flex items-center gap-2">
                          <Phone className="h-4 w-4" />
                          Teléfono
                        </FormLabel>
                        <FormControl>
                          <Input 
                            placeholder="(591) 2-123456" 
                            {...field}
                            disabled={isReadOnly}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="whatsapp"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className="flex items-center gap-2">
                          <MessageCircle className="h-4 w-4" />
                          WhatsApp
                        </FormLabel>
                        <FormControl>
                          <Input 
                            placeholder="59170123456" 
                            {...field}
                            disabled={isReadOnly}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <FormField
                    control={form.control}
                    name="website"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className="flex items-center gap-2">
                          <Globe className="h-4 w-4" />
                          Sitio Web
                        </FormLabel>
                        <FormControl>
                          <Input 
                            placeholder="https://mi-empresa.com" 
                            {...field}
                            disabled={isReadOnly}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />

                  <FormField
                    control={form.control}
                    name="facebook"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel className="flex items-center gap-2">
                          <Facebook className="h-4 w-4" />
                          Facebook
                        </FormLabel>
                        <FormControl>
                          <Input 
                            placeholder="mi-empresa-materiales" 
                            {...field}
                            disabled={isReadOnly}
                          />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>

                {/* Logo Upload Section */}
                <div className="border-t pt-6">
                  <h3 className="text-lg font-medium mb-4 flex items-center gap-2">
                    <Upload className="h-5 w-5" />
                    Logotipo de la Empresa
                  </h3>
                  
                  <div className="space-y-4">
                    {(logoPreview || (company as any)?.logoUrl) && (
                      <div className="flex items-center gap-4">
                        <img 
                          src={logoPreview || (company as any).logoUrl} 
                          alt={logoPreview ? "Vista previa" : "Logo actual"}
                          className="w-20 h-20 object-cover rounded-lg border"
                        />
                        <div>
                          <p className="text-sm text-gray-600">
                            {logoPreview ? "Vista previa" : "Logo actual"}
                          </p>
                          <p className="text-xs text-gray-400">
                            {logoPreview ? "Archivo seleccionado para subir" : "Sube una nueva imagen para reemplazarlo"}
                          </p>
                          {logoPreview && (
                            <Button
                              type="button"
                              variant="outline"
                              size="sm"
                              onClick={() => {
                                setLogoPreview(null);
                                setLogoFile(null);
                              }}
                              className="mt-2"
                            >
                              Cancelar
                            </Button>
                          )}
                        </div>
                      </div>
                    )}
                    
                    {!isReadOnly && (
                      <div className="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center">
                        <input
                          type="file"
                          accept="image/*"
                          onChange={handleLogoUpload}
                          className="hidden"
                          id="logo-upload"
                        />
                        <label htmlFor="logo-upload" className="cursor-pointer">
                          <Upload className="h-8 w-8 mx-auto text-gray-400 mb-2" />
                          <p className="text-sm text-gray-600">
                            Haz clic para subir tu logotipo
                          </p>
                          <p className="text-xs text-gray-400 mt-1">
                            PNG, JPG hasta 5MB
                          </p>
                        </label>
                      </div>
                    )}
                  </div>
                </div>

                {(!company || isEditing) && (
                  <div className="flex justify-end space-x-4">
                    <Button
                      type="submit"
                      disabled={createMutation.isPending || updateMutation.isPending}
                      className="min-w-32"
                    >
                      {createMutation.isPending || updateMutation.isPending ? (
                        "Guardando..."
                      ) : company ? (
                        "Actualizar Empresa"
                      ) : (
                        "Registrar Empresa"
                      )}
                    </Button>
                  </div>
                )}
              </form>
            </Form>
          </CardContent>
        </Card>

        {company && (
          <div className="mt-8">
            <Card>
              <CardHeader>
                <CardTitle>Estado de la Empresa</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <div className="text-center p-4 bg-blue-50 rounded-lg">
                    <h3 className="font-semibold text-blue-900">Membresía</h3>
                    <p className="text-blue-600 capitalize">{company.membershipType}</p>
                  </div>
                  <div className="text-center p-4 bg-green-50 rounded-lg">
                    <h3 className="font-semibold text-green-900">Estado</h3>
                    <p className="text-green-600">
                      {company.isVerified ? "Verificada" : "Pendiente"}
                    </p>
                  </div>
                  <div className="text-center p-4 bg-yellow-50 rounded-lg">
                    <h3 className="font-semibold text-yellow-900">Rating</h3>
                    <p className="text-yellow-600">{company.rating || "0.0"} / 5.0</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        )}
      </div>
    </div>
  );
}