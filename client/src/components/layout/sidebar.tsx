import { Link, useLocation } from "wouter";
import { useAuth } from "@/hooks/useAuth";
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarHeader,
} from "@/components/ui/sidebar";
import {
  PanelsTopLeft,
  Package,
  Combine,
  Calculator,
  BarChart3,
  Settings,
  Shield,
  Construction,
  DollarSign,
  MapPin,
  Building2,
  Store,
  Wrench,
  Users,
  Camera,
  Upload,
  Globe,
} from "lucide-react";

const menuItems = [
  {
    title: "Panel Principal",
    url: "/dashboard",
    icon: PanelsTopLeft,
  },
  {
    title: "Materiales",
    url: "/materials",
    icon: Package,
  },
  {
    title: "Actividades",
    url: "/activities",
    icon: Combine,
  },
  {
    title: "Herramientas",
    url: "/tools",
    icon: Wrench,
  },
  {
    title: "Mano de Obra",
    url: "/labor",
    icon: Users,
  },
  {
    title: "Presupuestos",
    url: "/budgets",
    icon: Calculator,
  },
  {
    title: "Reportes",
    url: "/reports",
    icon: BarChart3,
  },
];

const marketplaceItems = [
  {
    title: "Vista Pública",
    url: "/public",
    icon: Globe,
  },
  {
    title: "Marketplace",
    url: "/marketplace",
    icon: Store,
  },
  {
    title: "Empresas Proveedoras",
    url: "/suppliers",
    icon: Building2,
  },
  {
    title: "Mi Empresa",
    url: "/supplier-registration",
    icon: Users,
  },
];

const settingsItems = [
  {
    title: "Importar APU",
    url: "/apu-import",
    icon: Construction,
  },
  {
    title: "Configuración de Precios",
    url: "/price-settings",
    icon: DollarSign,
  },
  {
    title: "Factores por Ciudad",
    url: "/city-factors",
    icon: MapPin,
  },
  {
    title: "Configuración",
    url: "/settings",
    icon: Settings,
  },
];

const adminItems = [
  {
    title: "Organizar Actividades",
    url: "/admin/activities",
    icon: Settings,
  },
  {
    title: "Administrar Empresas",
    url: "/admin/companies",
    icon: Building2,
  },
  {
    title: "Gestión de Publicidades",
    url: "/admin/advertisements",
    icon: Camera,
  },
  {
    title: "Importar Empresas",
    url: "/import-companies",
    icon: Upload,
  },
  {
    title: "Importación Simple",
    url: "/simple-import",
    icon: Building2,
  },
  {
    title: "Gestión de Precios",
    url: "/admin-materials",
    icon: DollarSign,
  },
];

export default function AppSidebar() {
  const [location] = useLocation();
  const { user } = useAuth();
  


  const isActive = (url: string) => {
    if (url === "/dashboard" && (location === "/" || location === "/dashboard")) {
      return true;
    }
    return location === url;
  };

  return (
    <Sidebar className="border-r">
      <SidebarHeader className="p-6">
        <div className="flex items-center space-x-2">
          <div className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center">
            <Construction className="w-4 h-4 text-white" />
          </div>
          <span className="text-lg font-semibold text-on-surface">MICA</span>
        </div>
      </SidebarHeader>
      
      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupLabel>Sistema</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {menuItems.filter((item) => {
                // Empresas proveedoras solo ven dashboard, materiales y herramientas
                if ((user as any)?.userType === "supplier") {
                  return ["Panel Principal", "Materiales", "Herramientas"].includes(item.title);
                }
                // Usuarios normales y admin ven todo excepto reportes
                return item.title !== "Reportes";
              }).map((item) => {
                // Redirect supplier companies to their specific dashboard
                const url = (user as any)?.userType === "supplier" && item.title === "Panel Principal" 
                  ? "/supplier-dashboard" 
                  : item.url;
                
                return (
                  <SidebarMenuItem key={item.title}>
                    <SidebarMenuButton
                      asChild
                      isActive={isActive(url)}
                      className="w-full"
                    >
                      <Link href={url}>
                        <item.icon className="w-4 h-4" />
                        <span>{item.title}</span>
                      </Link>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                );
              })}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
        
        <SidebarGroup>
          <SidebarGroupLabel>Marketplace</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {marketplaceItems.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton
                    asChild
                    isActive={isActive(item.url)}
                    className="w-full"
                  >
                    <Link href={item.url}>
                      <item.icon className="w-4 h-4" />
                      <span>{item.title}</span>
                    </Link>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        {(user as any)?.userType === "supplier" && (
          <SidebarGroup>
            <SidebarGroupLabel>Mi Empresa</SidebarGroupLabel>
            <SidebarGroupContent>
              <SidebarMenu>
                <SidebarMenuItem>
                  <SidebarMenuButton
                    asChild
                    isActive={isActive("/supplier-dashboard")}
                    className="w-full"
                  >
                    <Link href="/supplier-dashboard">
                      <Store className="w-4 h-4" />
                      <span>Panel de Empresa</span>
                    </Link>
                  </SidebarMenuButton>
                </SidebarMenuItem>
                <SidebarMenuItem>
                  <SidebarMenuButton
                    asChild
                    isActive={isActive("/supplier-pricing")}
                    className="w-full"
                  >
                    <Link href="/supplier-pricing">
                      <DollarSign className="w-4 h-4" />
                      <span>Mis Ofertas de Precios</span>
                    </Link>
                  </SidebarMenuButton>
                </SidebarMenuItem>
                <SidebarMenuItem>
                  <SidebarMenuButton
                    asChild
                    isActive={isActive("/company-advertising")}
                    className="w-full"
                  >
                    <Link href="/company-advertising">
                      <Camera className="w-4 h-4" />
                      <span>Gestión de Publicidad</span>
                    </Link>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              </SidebarMenu>
            </SidebarGroupContent>
          </SidebarGroup>
        )}

        {(user?.role === "admin") && (
          <SidebarGroup>
            <SidebarGroupLabel>Configuración</SidebarGroupLabel>
            <SidebarGroupContent>
              <SidebarMenu>
                {settingsItems.map((item) => (
                  <SidebarMenuItem key={item.title}>
                    <SidebarMenuButton
                      asChild
                      isActive={isActive(item.url)}
                      className="w-full"
                    >
                      <Link href={item.url}>
                        <item.icon className="w-4 h-4" />
                        <span>{item.title}</span>
                      </Link>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                ))}
              </SidebarMenu>
            </SidebarGroupContent>
          </SidebarGroup>
        )}

        {user?.role === "admin" && (
          <SidebarGroup>
            <SidebarGroupLabel>Administración</SidebarGroupLabel>
            <SidebarGroupContent>
              <SidebarMenu>
                {adminItems.map((item) => (
                  <SidebarMenuItem key={item.title}>
                    <SidebarMenuButton
                      asChild
                      isActive={isActive(item.url)}
                      className="w-full"
                    >
                      <Link href={item.url}>
                        <item.icon className="w-4 h-4" />
                        <span>{item.title}</span>
                      </Link>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                ))}
              </SidebarMenu>
            </SidebarGroupContent>
          </SidebarGroup>
        )}
      </SidebarContent>
      
      <SidebarFooter className="p-4 border-t">
        <div className="text-xs text-muted-foreground text-center">
          MICA v1.0.0
        </div>
      </SidebarFooter>
    </Sidebar>
  );
}
