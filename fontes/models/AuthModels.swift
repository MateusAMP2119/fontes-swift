import Foundation

// MARK: - Request Models

struct LoginRequestModel: Codable {
    let username: String?
    let email: String?
    let password: String
}

struct SignupRequestModel: Codable {
    let username: String
    let password: String
    let email: String
    let role: String?
}

struct LogoutRequestModel: Codable {
    let refreshToken: String
}

struct RefreshTokenRequestModel: Codable {
    let refreshToken: String
}

// MARK: - Response Models

struct TokenData: Codable {
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: Int?
}

struct UserData: Codable {
    let id: Int?
    let username: String?
    let email: String?
    let createdAt: String?
}

struct UserExistsData: Codable {
    let exists: Bool
}

struct VerifyData: Codable {
    let user: UserData?
    let expiresIn: Int?
}

struct AuthData: Codable {
    let user: UserData?
    let tokens: TokenData?
}

struct FieldError: Codable {
    let field: String?
    let message: String?
}

struct AuthApiResponseAuthData: Codable {
    let success: Bool?
    let message: String?
    let data: AuthData?
    let error: String?
    let details: [FieldError]?
}
