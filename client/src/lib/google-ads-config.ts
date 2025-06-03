// Google AdSense Configuration for MICAA
// This file contains the configuration and setup instructions for Google Ads

export interface AdConfig {
  clientId: string;
  adSlots: {
    banner: string;
    sidebar: string;
    square: string;
    mobile: string;
    responsive: string;
  };
}

// Default configuration - replace with actual Google AdSense values
export const googleAdsConfig: AdConfig = {
  clientId: "ca-pub-XXXXXXXXXXXXXXXXX", // Replace with your Google AdSense Publisher ID
  adSlots: {
    banner: "1234567890",      // 728x90 banner ad slot
    sidebar: "0987654321",     // 160x600 sidebar ad slot  
    square: "1122334455",      // 300x250 square ad slot
    mobile: "5544332211",      // 320x50 mobile ad slot
    responsive: "6677889900"   // Responsive ad slot
  }
};

// Ad placement strategy for optimal revenue
export const adPlacementStrategy = {
  public: {
    description: "High traffic, monetization focused",
    placements: [
      "Header banner (728x90) - High visibility",
      "Between statistics and content (300x250) - Natural break", 
      "Sidebar (160x600) - Desktop only, persistent",
      "Before footer (Responsive) - High engagement",
      "Mobile banner (320x50) - Mobile specific"
    ]
  },
  authenticated: {
    description: "Reduced ads for better UX",
    placements: [
      "Sidebar only for premium content",
      "Footer area for minimal disruption"
    ]
  }
};

// Setup instructions for Google AdSense
export const setupInstructions = `
GOOGLE ADSENSE SETUP FOR MICAA:

1. CREATE GOOGLE ADSENSE ACCOUNT:
   - Go to www.google.com/adsense
   - Sign up with your Google account
   - Add your website: micaa.store
   - Wait for approval (usually 1-7 days)

2. GET YOUR PUBLISHER ID:
   - In AdSense dashboard, go to Account > Account information
   - Copy your Publisher ID (starts with ca-pub-)
   - Replace "ca-pub-XXXXXXXXXXXXXXXXX" in google-ads-config.ts

3. CREATE AD UNITS:
   - Go to Ads > By ad unit > Display ads
   - Create these ad units:
     * Banner Ad (728x90) for desktop headers
     * Square Ad (300x250) for content areas  
     * Sidebar Ad (160x600) for desktop sidebars
     * Mobile Banner (320x50) for mobile headers
     * Responsive Ad (auto-size) for flexible areas

4. UPDATE CONFIGURATION:
   - Copy each ad unit ID from AdSense
   - Update the adSlots object in google-ads-config.ts
   - The ad components will automatically use these IDs

5. ADD ADSENSE SCRIPT:
   - Add this to your HTML head section:
   <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-XXXXXXXXXXXXXXXXX" crossorigin="anonymous"></script>

6. VERIFY IMPLEMENTATION:
   - Use AdSense dashboard to check ad serving
   - Monitor revenue and performance metrics
   - Adjust ad placements based on analytics

REVENUE OPTIMIZATION TIPS:
- Place ads above the fold for better viewability
- Use responsive ads for mobile optimization  
- Test different ad sizes and placements
- Monitor Core Web Vitals impact
- Ensure ads don't hurt user experience
`;

// Helper function to load Google AdSense script
export function loadGoogleAdsScript(publisherId: string): Promise<void> {
  return new Promise((resolve, reject) => {
    if (document.querySelector(`script[src*="googlesyndication.com"]`)) {
      resolve();
      return;
    }

    const script = document.createElement('script');
    script.async = true;
    script.src = `https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${publisherId}`;
    script.crossOrigin = 'anonymous';
    
    script.onload = () => resolve();
    script.onerror = () => reject(new Error('Failed to load Google AdSense script'));
    
    document.head.appendChild(script);
  });
}

// Ad performance tracking
export function trackAdPerformance(adSlot: string, action: 'impression' | 'click') {
  // This would integrate with your analytics system
  console.log(`Ad ${action} tracked for slot: ${adSlot}`);
  
  // Example: Send to Google Analytics
  if (typeof gtag !== 'undefined') {
    gtag('event', action, {
      event_category: 'ads',
      event_label: adSlot,
      value: action === 'click' ? 1 : 0
    });
  }
}