import SwiftUI
import Combine

struct AppUser: Identifiable, Codable {
    var id: String
    var name: String
    var profileImageName: String?
}

final class UserManager: ObservableObject {
    @Published var currentUser: AppUser?
    @Published var isLoggedIn: Bool = false
    
    init() {
        setupNetworkClient()
        checkSession()
    }
    
    private func setupNetworkClient() {
        NetworkClient.shared.tokenRefreshHandler = { [weak self] () async -> Bool in
            return await self?.refreshAccessToken() ?? false
        }
    }
    
    private func checkSession() {
        if let token = KeychainManager.shared.getToken(forKey: KeychainManager.accessTokenKey) {
            NetworkClient.shared.setToken(token)
            // Optimistically set logged in, then verify
            isLoggedIn = true
            
            Task {
                do {
                    try await verifyToken()
                } catch {
                    print("Token verification failed: \(error)")
                    // If verification fails, try refresh
                    if await refreshAccessToken() {
                        print("Session refreshed successfully")
                    } else {
                        await logout()
                    }
                }
            }
        }
    }
    
    func verifyToken() async throws {
        let response: VerifyData = try await NetworkClient.shared.post(path: "/api/auth/verify", body: EmptyBody())
        
        if let userData = response.user,
           let userId = userData.id,
           let username = userData.username {
            let appUser = AppUser(id: String(userId), name: username, profileImageName: nil)
            await MainActor.run {
                self.currentUser = appUser
            }
        }
    }
    
    func refreshAccessToken() async -> Bool {
        guard let refreshToken = KeychainManager.shared.getToken(forKey: KeychainManager.refreshTokenKey) else {
            return false
        }
        
        let request = RefreshTokenRequestModel(refreshToken: refreshToken)
        
        do {
            // We use a separate NetworkClient call or handle it carefully to avoid infinite loops
            // But since we are calling a specific endpoint that might not require auth header (or ignores it), it should be fine.
            // However, /api/auth/refresh usually doesn't require the expired access token, just the refresh token in body.
            // NetworkClient adds the Authorization header if it has one.
            
            let response: TokenData = try await NetworkClient.shared.post(path: "/api/auth/refresh", body: request)
            
            if let accessToken = response.accessToken, let newRefreshToken = response.refreshToken {
                try KeychainManager.shared.save(token: accessToken, forKey: KeychainManager.accessTokenKey)
                try KeychainManager.shared.save(token: newRefreshToken, forKey: KeychainManager.refreshTokenKey)
                NetworkClient.shared.setToken(accessToken)
                return true
            }
        } catch {
            print("Token refresh failed: \(error)")
        }
        
        return false
    }
    
    func setSession(accessToken: String, refreshToken: String, user: AppUser) {
        do {
            try KeychainManager.shared.save(token: accessToken, forKey: KeychainManager.accessTokenKey)
            try KeychainManager.shared.save(token: refreshToken, forKey: KeychainManager.refreshTokenKey)
            NetworkClient.shared.setToken(accessToken)
            self.currentUser = user
            self.isLoggedIn = true
        } catch {
            print("Failed to save tokens: \(error)")
        }
    }
    
    func login(request: LoginRequestModel) async throws {
        let response: AuthData = try await NetworkClient.shared.post(path: "/api/auth/login", body: request)
        handleAuthResponse(response)
    }
    
    func register(request: SignupRequestModel) async throws {
        let response: AuthData = try await NetworkClient.shared.post(path: "/api/auth/register", body: request)
        handleAuthResponse(response)
    }
    
    func logout() async {
        if let refreshToken = KeychainManager.shared.getToken(forKey: KeychainManager.refreshTokenKey) {
            let request = LogoutRequestModel(refreshToken: refreshToken)
            do {
                let _: String? = try await NetworkClient.shared.post(path: "/api/auth/logout", body: request)
            } catch {
                print("Logout failed: \(error)")
            }
        }
        
        KeychainManager.shared.deleteToken(forKey: KeychainManager.accessTokenKey)
        KeychainManager.shared.deleteToken(forKey: KeychainManager.refreshTokenKey)
        
        await MainActor.run {
            currentUser = nil
            isLoggedIn = false
        }
    }
    
    private func handleAuthResponse(_ response: AuthData) {
        guard let tokens = response.tokens,
              let accessToken = tokens.accessToken,
              let refreshToken = tokens.refreshToken,
              let userData = response.user,
              let userId = userData.id,
              let username = userData.username else {
            return
        }
        
        let appUser = AppUser(id: String(userId), name: username, profileImageName: nil)
        
        DispatchQueue.main.async {
            self.setSession(accessToken: accessToken, refreshToken: refreshToken, user: appUser)
        }
    }
}
