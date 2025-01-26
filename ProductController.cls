@RestResource(urlMapping='/products/*')
global with sharing class ProductController {
    public ProductController() {

    }

    @HttpGet
    @AuraEnabled(cacheable=true)
    global static List<Product2> getProducts() {
        // Get the productId from the request URL
        RestRequest req = RestContext.request;
        String productId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        // Check if the request URI contains a productId
        if (!String.isBlank(productId) && productId != 'products') {
            // Query to fetch the specific product record
            Product2 product = [
                SELECT Id, Name, Description
                FROM Product2
                WHERE Id = :productId
                LIMIT 1
            ];

            // Return the specific product in a list
            return new List<Product2> { product };
        } else {
            // Query to fetch all product records
            List<Product2> products = [
                SELECT Id, Name, Description
                FROM Product2
            ];

            // Return the list of all products
            return products;
        }
    }
}