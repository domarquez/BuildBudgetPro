import { Switch, Route } from "wouter";
import { queryClient } from "./lib/queryClient";
import { QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { SidebarProvider } from "@/components/ui/sidebar";
import Dashboard from "@/pages/dashboard";
import Materials from "@/pages/materials";
import Budgets from "@/pages/budgets";
import PriceSettings from "@/pages/price-settings";
import NotFound from "@/pages/not-found";
import AppSidebar from "@/components/layout/sidebar";
import AppHeader from "@/components/layout/header";

function Router() {
  return (
    <Switch>
      <Route path="/" component={Dashboard} />
      <Route path="/dashboard" component={Dashboard} />
      <Route path="/materials" component={Materials} />
      <Route path="/budgets" component={Budgets} />
      <Route path="/price-settings" component={PriceSettings} />
      <Route component={NotFound} />
    </Switch>
  );
}

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <TooltipProvider>
        <SidebarProvider>
          <div className="min-h-screen bg-surface">
            <AppSidebar />
            <div className="flex flex-col flex-1 lg:ml-64">
              <AppHeader />
              <main className="flex-1">
                <Router />
              </main>
            </div>
          </div>
          <Toaster />
        </SidebarProvider>
      </TooltipProvider>
    </QueryClientProvider>
  );
}

export default App;
