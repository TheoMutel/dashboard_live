console.log('Dashboard app initialized! 🎉');

// Dashboard Price Tracker Module
class DashboardPriceTracker {
    constructor() {
        this.priceElement = document.getElementById('btc-price');
        if (this.priceElement) {
            this.setupMercureListener();
        }
    }
    
    setupMercureListener() {
        // Listen for Turbo Stream updates from Mercure
        document.addEventListener('turbo:submit-end', (event) => {
            console.log('Turbo stream update received');
        });
        
        // Listen for any text content changes in the price element
        const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
                if (mutation.type === 'characterData' || mutation.type === 'childList') {
                    const newPrice = this.parsePrice(this.priceElement.textContent);
                    if (newPrice > 0) {
                        console.log('Price updated:', newPrice);
                        this.updateChartData(newPrice);
                    }
                }
            });
        });
        
        observer.observe(this.priceElement, {
            characterData: true,
            childList: true,
            subtree: true,
            characterDataOldValue: true
        });
    }
    
    parsePrice(text) {
        // Remove currency symbols and commas, parse to integer
        const cleaned = text.replace(/[^\d]/g, '');
        return parseInt(cleaned) || 0;
    }
    
    updateChartData(price) {
        // Will be implemented in the template script
        const event = new CustomEvent('priceUpdate', { detail: { price } });
        document.dispatchEvent(event);
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    new DashboardPriceTracker();
});
