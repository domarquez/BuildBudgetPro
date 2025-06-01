import { useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { useToast } from "@/hooks/use-toast";
import { apiRequest } from "@/lib/queryClient";
import { 
  Building2, 
  Phone, 
  Mail, 
  MapPin,
  Globe,
  Briefcase,
  Save
} from "lucide-react";

export default function SimpleImport() {
  const [extractedText, setExtractedText] = useState("");
  const [company, setCompany] = useState({
    name: "",
    address: "",
    phone: "",
    email: "",
    website: "",
    services: "",
    city: "La Paz",
    businessType: "General"
  });

  const { toast } = useToast();
  const queryClient = useQueryClient();

  const autoFillMutation = useMutation({
    mutationFn: async () => {
      if (!extractedText.trim()) return;

      const lines = extractedText.split('\n').filter(line => line.trim());
      const newCompany = { ...company };

      // Detectar nombre (primera línea significativa)
      if (!newCompany.name && lines.length > 0) {
        newCompany.name = lines[0].trim();
      }

      // Buscar información en todas las líneas
      for (const line of lines) {
        const cleanLine = line.trim();

        // Teléfono
        if (!newCompany.phone) {
          const phoneMatch = cleanLine.match(/(?:\+591|591)?\s*[2-9]\d{6,7}|Tel\.?\s*:?\s*[2-9][\d\-\s]{6,10}/i);
          if (phoneMatch) {
            newCompany.phone = phoneMatch[0].replace(/[^\d+]/g, '');
          }
        }

        // Email
        if (!newCompany.email) {
          const emailMatch = cleanLine.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/);
          if (emailMatch) {
            newCompany.email = emailMatch[0];
          }
        }

        // Website
        if (!newCompany.website) {
          const websiteMatch = cleanLine.match(/(www\.)[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}|[a-zA-Z0-9.-]+\.com\.bo/);
          if (websiteMatch) {
            newCompany.website = websiteMatch[0];
          }
        }

        // Dirección
        if (!newCompany.address && /(?:Av\.|Calle|Zona|Plaza)/i.test(cleanLine)) {
          newCompany.address = cleanLine;
        }

        // Ciudad
        const cities = ['La Paz', 'Santa Cruz', 'Cochabamba', 'Oruro', 'Potosí', 'Tarija', 'Sucre'];
        const cityFound = cities.find(city => cleanLine.includes(city));
        if (cityFound) {
          newCompany.city = cityFound;
        }

        // Servicios (líneas con palabras clave de negocio)
        const businessKeywords = ['materiales', 'construcción', 'venta', 'distribución', 'servicios', 'especialistas'];
        if (businessKeywords.some(keyword => cleanLine.toLowerCase().includes(keyword))) {
          if (newCompany.services && !newCompany.services.includes(cleanLine)) {
            newCompany.services += " | " + cleanLine;
          } else if (!newCompany.services) {
            newCompany.services = cleanLine;
          }
        }
      }

      // Detectar tipo de negocio
      const text = (newCompany.name + " " + newCompany.services).toLowerCase();
      if (text.includes('construcción') || text.includes('constructora')) {
        newCompany.businessType = 'Construcción';
      } else if (text.includes('ferretería') || text.includes('herramientas')) {
        newCompany.businessType = 'Ferretería';
      } else if (text.includes('materiales') || text.includes('cemento')) {
        newCompany.businessType = 'Materiales de Construcción';
      }

      setCompany(newCompany);
      return newCompany;
    },
    onSuccess: () => {
      toast({
        title: "Información extraída",
        description: "Los datos se completaron automáticamente. Revisa y ajusta si es necesario.",
      });
    }
  });

  const importMutation = useMutation({
    mutationFn: async () => {
      const companyData = {
        name: company.name,
        address: company.address,
        phone: company.phone,
        email: company.email,
        website: company.website,
        services: company.services,
        city: company.city,
        business_type: company.businessType
      };

      return apiRequest("POST", "/api/import-companies-bulk", {
        companies: [companyData]
      });
    },
    onSuccess: (result) => {
      queryClient.invalidateQueries({ queryKey: ["/api/supplier-companies"] });
      toast({
        title: "Empresa importada",
        description: `${result.imported} empresa agregada exitosamente`,
      });
      
      // Limpiar formulario
      setCompany({
        name: "",
        address: "",
        phone: "",
        email: "",
        website: "",
        services: "",
        city: "La Paz",
        businessType: "General"
      });
      setExtractedText("");
    },
    onError: (error) => {
      toast({
        title: "Error",
        description: "No se pudo importar la empresa",
        variant: "destructive",
      });
    }
  });

  return (
    <div className="container mx-auto p-6 space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Importación Simple de Empresa</h1>
        <p className="text-gray-600 mt-2">
          Importa una empresa a la vez con información completa
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Panel de texto */}
        <Card>
          <CardHeader>
            <CardTitle>1. Texto del Catálogo</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label htmlFor="company-text">Pega la información de UNA empresa</Label>
              <Textarea
                id="company-text"
                value={extractedText}
                onChange={(e) => setExtractedText(e.target.value)}
                placeholder="Ejemplo:

CONSTRUCTORA ABC S.R.L.
Av. América 1234, La Paz
Tel: 2-234-5678
contacto@abc.com.bo
www.abc.com.bo
Especialistas en construcción y materiales de calidad"
                className="min-h-[200px] text-sm"
              />
            </div>
            
            <Button 
              onClick={() => autoFillMutation.mutate()}
              disabled={!extractedText.trim() || autoFillMutation.isPending}
              className="w-full"
            >
              {autoFillMutation.isPending ? "Analizando..." : "2. Extraer Información"}
            </Button>
          </CardContent>
        </Card>

        {/* Panel de datos */}
        <Card>
          <CardHeader>
            <CardTitle>3. Datos de la Empresa</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label htmlFor="name">Nombre de la Empresa *</Label>
              <div className="relative">
                <Building2 className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  id="name"
                  value={company.name}
                  onChange={(e) => setCompany({...company, name: e.target.value})}
                  className="pl-10"
                  placeholder="Nombre comercial"
                />
              </div>
            </div>

            <div>
              <Label htmlFor="address">Dirección</Label>
              <div className="relative">
                <MapPin className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  id="address"
                  value={company.address}
                  onChange={(e) => setCompany({...company, address: e.target.value})}
                  className="pl-10"
                  placeholder="Dirección completa"
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <Label htmlFor="phone">Teléfono</Label>
                <div className="relative">
                  <Phone className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <Input
                    id="phone"
                    value={company.phone}
                    onChange={(e) => setCompany({...company, phone: e.target.value})}
                    className="pl-10"
                    placeholder="Número de teléfono"
                  />
                </div>
              </div>

              <div>
                <Label htmlFor="city">Ciudad</Label>
                <Input
                  id="city"
                  value={company.city}
                  onChange={(e) => setCompany({...company, city: e.target.value})}
                  placeholder="Ciudad"
                />
              </div>
            </div>

            <div>
              <Label htmlFor="email">Email</Label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  id="email"
                  value={company.email}
                  onChange={(e) => setCompany({...company, email: e.target.value})}
                  className="pl-10"
                  placeholder="Correo electrónico"
                />
              </div>
            </div>

            <div>
              <Label htmlFor="website">Sitio Web</Label>
              <div className="relative">
                <Globe className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  id="website"
                  value={company.website}
                  onChange={(e) => setCompany({...company, website: e.target.value})}
                  className="pl-10"
                  placeholder="www.empresa.com"
                />
              </div>
            </div>

            <div>
              <Label htmlFor="services">Servicios y Productos</Label>
              <div className="relative">
                <Briefcase className="absolute left-3 top-3 w-4 h-4 text-gray-400" />
                <Textarea
                  id="services"
                  value={company.services}
                  onChange={(e) => setCompany({...company, services: e.target.value})}
                  className="pl-10 min-h-[80px]"
                  placeholder="Descripción de productos y servicios que ofrece"
                />
              </div>
            </div>

            <Button 
              onClick={() => importMutation.mutate()}
              disabled={!company.name || importMutation.isPending}
              className="w-full"
              size="lg"
            >
              <Save className="w-4 h-4 mr-2" />
              {importMutation.isPending ? "Guardando..." : "4. Guardar Empresa"}
            </Button>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}