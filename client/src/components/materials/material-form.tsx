import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation } from "@tanstack/react-query";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useToast } from "@/hooks/use-toast";
import { queryClient, apiRequest } from "@/lib/queryClient";
import { insertMaterialSchema } from "@shared/schema";
import type { MaterialWithCategory, MaterialCategory, InsertMaterial } from "@shared/schema";
import { z } from "zod";

const formSchema = insertMaterialSchema.extend({
  price: z.string().min(1, "El precio es requerido"),
});

type FormData = z.infer<typeof formSchema>;

interface MaterialFormProps {
  material?: MaterialWithCategory | null;
  categories: MaterialCategory[];
  onClose: () => void;
}

export default function MaterialForm({ material, categories, onClose }: MaterialFormProps) {
  const { toast } = useToast();
  const isEditing = !!material;

  const form = useForm<FormData>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      name: material?.name || "",
      categoryId: material?.categoryId || 0,
      unit: material?.unit || "",
      price: material?.price || "",
      description: material?.description || "",
    },
  });

  const mutation = useMutation({
    mutationFn: async (data: FormData) => {
      const materialData: InsertMaterial = {
        ...data,
        price: data.price,
      };

      if (isEditing) {
        return await apiRequest("PUT", `/api/materials/${material.id}`, materialData);
      } else {
        return await apiRequest("POST", "/api/materials", materialData);
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/materials"] });
      queryClient.invalidateQueries({ queryKey: ["/api/statistics"] });
      toast({
        title: isEditing ? "Material actualizado" : "Material creado",
        description: isEditing 
          ? "El material ha sido actualizado correctamente."
          : "El material ha sido creado correctamente.",
      });
      onClose();
    },
    onError: (error) => {
      toast({
        title: "Error",
        description: `No se pudo ${isEditing ? 'actualizar' : 'crear'} el material.`,
        variant: "destructive",
      });
    },
  });

  const onSubmit = (data: FormData) => {
    mutation.mutate(data);
  };

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="max-w-md mx-4">
        <DialogHeader>
          <DialogTitle>
            {isEditing ? "Editar Material" : "Crear Material"}
          </DialogTitle>
          <DialogDescription>
            {isEditing 
              ? "Actualice la información del material."
              : "Complete la información para crear un nuevo material."
            }
          </DialogDescription>
        </DialogHeader>

        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
            <FormField
              control={form.control}
              name="name"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Nombre del Material</FormLabel>
                  <FormControl>
                    <Input 
                      placeholder="Ej: Cemento Portland Tipo I" 
                      {...field} 
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <FormField
              control={form.control}
              name="categoryId"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Categoría</FormLabel>
                  <Select
                    onValueChange={(value) => field.onChange(parseInt(value))}
                    value={field.value.toString()}
                  >
                    <FormControl>
                      <SelectTrigger>
                        <SelectValue placeholder="Seleccione una categoría" />
                      </SelectTrigger>
                    </FormControl>
                    <SelectContent>
                      {categories.map((category) => (
                        <SelectItem key={category.id} value={category.id.toString()}>
                          {category.name}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                  <FormMessage />
                </FormItem>
              )}
            />

            <div className="grid grid-cols-2 gap-4">
              <FormField
                control={form.control}
                name="price"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Precio Unitario</FormLabel>
                    <FormControl>
                      <Input 
                        type="number" 
                        step="0.01" 
                        placeholder="0.00" 
                        {...field} 
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />

              <FormField
                control={form.control}
                name="unit"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Unidad</FormLabel>
                    <FormControl>
                      <Input 
                        placeholder="Ej: Bolsa, m², kg" 
                        {...field} 
                      />
                    </FormControl>
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
                  <FormLabel>Descripción (Opcional)</FormLabel>
                  <FormControl>
                    <Textarea 
                      placeholder="Descripción adicional del material..."
                      className="resize-none"
                      rows={3}
                      {...field} 
                    />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />

            <div className="flex justify-end space-x-3 pt-4">
              <Button 
                type="button" 
                variant="outline" 
                onClick={onClose}
                disabled={mutation.isPending}
              >
                Cancelar
              </Button>
              <Button 
                type="submit" 
                className="bg-primary hover:bg-primary-variant"
                disabled={mutation.isPending}
              >
                {mutation.isPending ? (
                  isEditing ? "Actualizando..." : "Creando..."
                ) : (
                  isEditing ? "Actualizar Material" : "Crear Material"
                )}
              </Button>
            </div>
          </form>
        </Form>
      </DialogContent>
    </Dialog>
  );
}
