function addToCart(productName) {
    alert(`Added ${productName} to cart!`);
    console.log(`Product added to cart: ${productName}`);
}

// Simple cart functionality
let cart = [];

function addToCart(productName) {
    cart.push(productName);
    alert(`✅ Added ${productName} to cart!\nItems in cart: ${cart.length}`);
    updateCartCount();
}

function updateCartCount() {
    const cartCount = document.getElementById('cart-count');
    if (cartCount) {
        cartCount.textContent = cart.length;
    }
}

// Initialize when page loads
document.addEventListener('DOMContentLoaded', function() {
    console.log('TeeTime store loaded successfully');
});