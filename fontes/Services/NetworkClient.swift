import Foundation

// Standard API Response structure defined in OpenAPI spec
struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String?
    let data: T?
    let error: String?
}

struct EmptyBody: Encodable {}

enum NetworkError: Error {
    case invalidURL
    case encodingError
    case requestFailed(Error)
    case invalidResponse
    case serverError(String)
    case unauthorized
    case decodingError(Error)
    case noData
}

class NetworkClient {
    static let shared = NetworkClient()
    
    private var authToken: String?
    var baseURL: String = "http://localhost:8080"
    
    // Handler for refreshing token. Returns true if refresh was successful.
    var tokenRefreshHandler: (() async -> Bool)?
    
    private init() {}
    
    /// Sets the Bearer token for subsequent requests
    func setToken(_ token: String) {
        self.authToken = token
    }
    
    /// Performs a POST request with a JSON body
    func post<Response: Decodable, Body: Encodable>(path: String, body: Body) async throws -> Response {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.encodingError
        }
        
        return try await performRequest(request)
    }
    
    /// Helper to handle the standard API response structure
    private func performRequest<T: Decodable>(_ request: URLRequest, retryCount: Int = 0) async throws -> T {
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.requestFailed(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            if retryCount < 1, let refreshHandler = tokenRefreshHandler {
                let refreshed = await refreshHandler()
                if refreshed {
                    // Token refreshed successfully, retry request with new token
                    var newRequest = request
                    if let newToken = authToken {
                        newRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
                    }
                    return try await performRequest(newRequest, retryCount: retryCount + 1)
                }
            }
            throw NetworkError.unauthorized
        }
        
        // Decode the standard API response wrapper
        do {
            let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
            
            if apiResponse.success {
                if let responseData = apiResponse.data {
                    return responseData
                } else {
                    throw NetworkError.noData
                }
            } else {
                throw NetworkError.serverError(apiResponse.error ?? apiResponse.message ?? "Unknown server error")
            }
        } catch {
            if let decodingError = error as? DecodingError {
                // Optional: Print the response body for debugging if decoding fails
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Decoding failed. Response body: \(responseString)")
                }
                throw NetworkError.decodingError(decodingError)
            }
            throw error
        }
    }
}
