import { useEffect, useRef } from "react";

interface AdSpaceProps {
  adSlot: string;
  adFormat?: "auto" | "rectangle" | "horizontal" | "vertical";
  adSize?: string;
  className?: string;
  style?: React.CSSProperties;
}

export function AdSpace({ 
  adSlot, 
  adFormat = "auto", 
  adSize = "auto",
  className = "",
  style = {}
}: AdSpaceProps) {
  const adRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (typeof window !== 'undefined' && window.adsbygoogle && adRef.current) {
      try {
        (window.adsbygoogle = window.adsbygoogle || []).push({});
      } catch (error) {
        console.error('Error loading ad:', error);
      }
    }
  }, []);

  return (
    <div className={`ad-container ${className}`} style={style}>
      <div className="text-xs text-gray-400 mb-1 text-center">Publicidad</div>
      <ins
        ref={adRef}
        className="adsbygoogle"
        style={{ display: "block", ...style }}
        data-ad-client="ca-pub-XXXXXXXXXXXXXXXXX" // Se reemplazará con el ID real
        data-ad-slot={adSlot}
        data-ad-format={adFormat}
        data-full-width-responsive="true"
        {...(adSize !== "auto" && { "data-ad-size": adSize })}
      />
    </div>
  );
}

// Componentes específicos para diferentes ubicaciones
export function SidebarAd() {
  return (
    <AdSpace
      adSlot="1234567890"
      adFormat="vertical"
      adSize="160x600"
      className="hidden lg:block sticky top-20"
      style={{ minHeight: "600px" }}
    />
  );
}

export function BannerAd() {
  return (
    <AdSpace
      adSlot="0987654321"
      adFormat="horizontal"
      adSize="728x90"
      className="w-full max-w-4xl mx-auto my-6"
      style={{ minHeight: "90px" }}
    />
  );
}

export function SquareAd() {
  return (
    <AdSpace
      adSlot="1122334455"
      adFormat="rectangle"
      adSize="300x250"
      className="mx-auto my-4"
      style={{ minHeight: "250px", width: "300px" }}
    />
  );
}

export function MobileAd() {
  return (
    <AdSpace
      adSlot="5544332211"
      adFormat="horizontal"
      adSize="320x50"
      className="lg:hidden w-full my-4"
      style={{ minHeight: "50px" }}
    />
  );
}

export function ResponsiveAd() {
  return (
    <AdSpace
      adSlot="6677889900"
      adFormat="auto"
      className="w-full my-6"
      style={{ minHeight: "200px" }}
    />
  );
}