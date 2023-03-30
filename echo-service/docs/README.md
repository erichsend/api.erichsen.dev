# Echo API Documentation

The Echo API provides an endpoint that returns an echo of the client's request.

This API is accessible at: https://api.erichsen.dev

## Endpoint

### `GET /`

Returns an echo of the client's request, including information about the hostname, pod (if available), server values, request information, request headers, and request body (if available).

#### Response

- `200 OK`: Successfully returned the client's request information.

#### Response Schema

- `hostname` (string): The hostname of the server that the API is running on.
- `podInformation` (string): Information about the pod where the request was handled, or "-no pod information available-" if not applicable.
- `serverValues` (object): An object containing server version information.
  - `serverVersion` (string): The server version.
- `requestInformation` (object): An object containing information about the incoming request.
  - `clientAddress` (string): The client's IP address.
  - `method` (string): The HTTP method of the request.
  - `realPath` (string): The requested path.
  - `query` (string): The query string of the request.
  - `requestVersion` (string): The HTTP version of the request.
  - `requestScheme` (string): The request scheme (e.g., "http" or "https").
  - `requestUri` (string): The full request URI.
- `requestHeaders` (object): An object containing the headers included in the incoming request.
- `requestBody` (string): The request body if included in the incoming request, or "-no body in request-" if not applicable.








