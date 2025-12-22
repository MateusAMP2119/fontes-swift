import SwiftUI

struct CustomTabViewBottomAccessory<Accessory: View>: ViewModifier {
    let accessory: Accessory
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            accessory
                .padding(.bottom, 49) // Standard TabBar height
        }
    }
}

extension View {
    func customTabViewBottomAccessory<Accessory: View>(@ViewBuilder accessory: () -> Accessory) -> some View {
        modifier(CustomTabViewBottomAccessory(accessory: accessory()))
    }
}
