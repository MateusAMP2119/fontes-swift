import SwiftUI
import Combine

struct AppUser: Identifiable, Codable {
    var id: String
    var name: String
    var profileImageName: String?
}

final class UserManager: ObservableObject {
    @Published var currentUser: AppUser?
    
    // Mock data for testing
    init() {
        // Uncomment to test logged in state
        // self.currentUser = AppUser(id: "1", name: "Mateus", profileImageName: "profile_mock")
    }
    
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    func login() {
        // Mock login
        currentUser = AppUser(id: "1", name: "Mateus", profileImageName: "profile_mock")
    }
    
    func logout() {
        currentUser = nil
    }
}
