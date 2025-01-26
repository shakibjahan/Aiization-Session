@RestResource(urlMapping='/cart/*')
global with sharing class CartRestController {

    /**
     * Removes a product from the cart.
     * @return A message indicating whether the product was removed from the cart or not.
     */
    @HttpDelete
    global static String removeProductFromCart() {
        // Get the productId from the request URL
        RestRequest req = RestContext.request;
        String productId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        // Ensure the productId is not null or empty
        if (String.isBlank(productId)) {
            throw new IllegalArgumentException('Product ID cannot be null or empty');
        }

        try {
            // Query to fetch the Cart__c records associated with the productId
            List<Cart__c> cartItems = [
                SELECT Id
                FROM Cart__c
                WHERE Product__c = :productId
            ];

            // Check if any cart items were found
            if (cartItems.isEmpty()) {
                return 'No cart items found for the given product ID.';
            }

            // Delete the fetched Cart__c records
            delete cartItems;

            return 'Product removed from the cart successfully.';
        } catch (Exception e) {
            // Handle any exceptions that occur during the process
            return 'An error occurred while removing the product from the cart: ' + e.getMessage();
        }
    }

    @HttpPost
    global static Cart__c addProductToCart() {
        // Ensure the productId is not null or empty
        RestRequest req = RestContext.request;
        String productId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if (String.isBlank(productId)) {
            throw new IllegalArgumentException('Product ID cannot be null or empty');
        }

        try {
            // Create a new Cart__c record and assign the productId
            Cart__c newCartItem = new Cart__c(
                Product__c = productId
            );

            // Insert the new Cart__c record
            insert newCartItem;

            // Return the newly added Cart__c record
            return newCartItem;
        } catch (Exception e) {
            // Handle any exceptions that occur during the process
            throw new CustomException('An error occurred while adding the product to the cart: ' + e.getMessage());
        }
    }

    @HttpGet
    global static List<Cart__c> getAllCartItems() {
        try {
            // Query to fetch all Cart__c records
            List<Cart__c> cartItems = [
                SELECT Id, Name, Product__c, Quantity__c
                FROM Cart__c
            ];

            // Return the list of all cart items
            return cartItems;
        } catch (Exception e) {
            // Handle any exceptions that occur during the process
            throw new CustomException('An error occurred while fetching the cart items: ' + e.getMessage());
        }
    }
    public class CustomException extends Exception {}
}