# Product Price Scraper API Server

A Go-based REST API server that searches for product prices across multiple retailers using Google Custom Search API. The service supports multiple countries, automatic currency detection, and scrapes product information from various e-commerce platforms.

## Recorded Demo

🎥 **[Watch Demo Video](https://drive.google.com/file/d/1uuSt0wJa9y5S4n2kRCTOjkulEm_OhT43/view?usp=sharing)**

*Click the link above to see the API in action with live product searches across multiple retailers.*

## Features

- 🔍 **Multi-Retailer Search**: Searches across major retailers like Amazon, Walmart, Best Buy, Flipkart, etc.
- 🌍 **Multi-Country Support**: Supports US, India, UK, Canada, and Australia
- 💰 **Currency Detection**: Automatically detects and displays prices in local currencies
- 🛒 **Product Scraping**: Extracts product names, prices, and links
- 📊 **Price Sorting**: Returns results sorted by price (lowest to highest)
- 🚀 **RESTful API**: Clean JSON API with CORS support
- ⚡ **Fast Response**: Optimized scraping with concurrent requests

## Supported Countries & Retailers

### United States (US)
- Amazon.com, Walmart.com, Best Buy, Target, eBay, Apple, B&H Photo

### India (IN)
- Amazon.in, Flipkart, Myntra, PayTM Mall, Snapdeal, Apple, Croma

### United Kingdom (UK)
- Amazon.co.uk, Currys, Argos, Very, Apple, John Lewis

### Canada (CA)
- Amazon.ca, Best Buy Canada, Walmart Canada, Canadian Tire, Apple

### Australia (AU)
- Amazon.com.au, JB Hi-Fi, Officeworks, Apple, Big W

## Prerequisites

1. **Google Custom Search API Setup**:
   - Create a Google Cloud Project
   - Enable the Custom Search JSON API
   - Create API credentials (API Key)
   - Set up a Custom Search Engine (CSE)

2. **Environment Variables**:
   ```bash
   export GOOGLE_API_KEY_ENV="your-google-api-key"
   export GOOGLE_CSE_ID_ENV="your-custom-search-engine-id"
   export PORT="8080"  # Optional, defaults to 8080
   ```

## Installation & Setup

### Local Development

1. **Clone and navigate to the project**:
   ```bash
   cd find-best-server
   ```

2. **Install dependencies**:
   ```bash
   go mod tidy
   ```

3. **Set environment variables**:
   ```bash
   source env.sh  # Make sure to update env.sh with your API credentials
   ```

4. **Run the server**:
   ```bash
   go run main.go
   ```

### Docker Deployment

1. **Build the Docker image**:
   ```bash
   docker build -t product-price-scraper .
   ```

2. **Run with Docker**:
   ```bash
   docker run -p 8080:8080 \
     -e GOOGLE_API_KEY_ENV="your-api-key" \
     -e GOOGLE_CSE_ID_ENV="your-cse-id" \
     product-price-scraper
   ```

## API Documentation

### Base URL
```
https://find-best-server-iyashjayesh2687-zd0agquo.leapcell.dev
```

### Endpoints

#### 1. Health Check
```http
GET /health
```

**Response**:
```json
{
  "status": "healthy",
  "timestamp": "2025-07-06T12:00:00Z",
  "service": "price-scraper"
}
```

#### 2. Search Products
```http
POST /search
```

**Request Body**:
```json
{
  "country": "US",
  "query": "iPhone 16 Pro 128GB"
}
```

**Parameters**:
- `country` (string): Country code (US, IN, UK, CA, AU) - defaults to US
- `query` (string, required): Product search query

**Response**:
```json
[
  {
    "productName": "Apple iPhone 16 Pro (128GB) - Natural Titanium",
    "price": "$999.00",
    "currency": "USD",
    "link": "https://www.amazon.com/dp/B0DGHXM2CQ"
  },
  {
    "productName": "iPhone 16 Pro 128GB Natural Titanium",
    "price": "$999.99",
    "currency": "USD",
    "link": "https://www.bestbuy.com/site/apple-iphone-16-pro/6576005.p"
  }
]
```

#### 3. API Documentation
```http
GET /
```

Returns detailed API documentation in JSON format.

## Usage Examples

### Using cURL

```bash
# Search for iPhone in US
curl -X POST https://find-best-server-iyashjayesh2687-zd0agquo.leapcell.dev/search \
  -H "Content-Type: application/json" \
  -d '{"country": "US", "query": "iPhone 16 Pro 128GB"}'

# Search for Samsung Galaxy in India
curl -X POST https://find-best-server-iyashjayesh2687-zd0agquo.leapcell.dev/search \
  -H "Content-Type: application/json" \
  -d '{"country": "IN", "query": "Samsung Galaxy S24"}'

# Search for MacBook in UK
curl -X POST https://find-best-server-iyashjayesh2687-zd0agquo.leapcell.dev/search \
  -H "Content-Type: application/json" \
  -d '{"country": "UK", "query": "MacBook Air M3"}'
```

### Using JavaScript (Frontend)

```javascript
async function searchProducts(query, country = 'US') {
  const response = await fetch('https://find-best-server-iyashjayesh2687-zd0agquo.leapcell.dev/search', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      country: country,
      query: query
    })
  });
  
  return await response.json();
}

// Usage
searchProducts('iPhone 16 Pro', 'US').then(products => {
  console.log('Found products:', products);
});
```

## Configuration

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `GOOGLE_API_KEY_ENV` | Google Custom Search API Key | Yes | - |
| `GOOGLE_CSE_ID_ENV` | Google Custom Search Engine ID | Yes | - |
| `PORT` | Server port | No | 8080 |

### Google Custom Search Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable the "Custom Search JSON API"
4. Create credentials (API Key)
5. Go to [Google Custom Search](https://cse.google.com/)
6. Create a new search engine
7. Configure it to search the entire web
8. Note down the Search Engine ID

## Architecture

The application follows a clean architecture pattern:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   HTTP Server   │────│  Search Logic   │────│  Web Scraper    │
│   (REST API)    │    │ (Google API)    │    │  (goquery)      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
    ┌─────────┐            ┌─────────┐            ┌─────────┐
    │  CORS   │            │ Country │            │ Price   │
    │Middleware│            │Currency │            │Extract  │
    └─────────┘            │Mapping  │            │ Logic   │
                          └─────────┘            └─────────┘
```

## Error Handling

The API returns appropriate HTTP status codes:

- `200` - Success
- `400` - Bad Request (invalid JSON, missing query)
- `405` - Method Not Allowed
- `500` - Internal Server Error

Error responses follow this format:
```json
{
  "error": "Error message description"
}
```

## Rate Limits

- Google Custom Search API: 100 free queries per day
- Upgrade to paid plan for higher limits
- The server implements request timeouts and error handling

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is open source and available under the MIT License.

## Support

For issues and questions:
1. Check the API documentation at `https://find-best-server-iyashjayesh2687-zd0agquo.leapcell.dev/`
2. Verify your Google API credentials
3. Check server logs for detailed error messages
4. Ensure the target websites are accessible

## Troubleshooting

### Common Issues

1. **403 Error**: Check that Custom Search API is enabled and API key is valid
2. **429 Error**: Daily quota exceeded (100 free searches per day)
3. **No Results**: Try different search terms or check if retailers are accessible
4. **Price Not Found**: Some retailers may have changed their HTML structure

### Debug Mode

The server provides detailed logging. Watch the console output for:
- Search queries being executed
- API responses
- Scraping results
- Error messages
