import SwiftUI

struct ScrollStatePreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false // False = Header Visible (Default)
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func onScrollHideHeader() -> some View {
        if #available(iOS 18.0, *) {
            modifier(ScrollDetectionModifier())
        } else {
            self
        }
    }
}

@available(iOS 18.0, *)
struct ScrollDetectionModifier: ViewModifier {
    @State private var lastOffset: CGFloat = 0
    @State private var isHidden: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
            } action: { oldValue, newValue in
                let topBounce = newValue < 0
                if topBounce {
                    if isHidden { isHidden = false }
                    lastOffset = newValue
                    return
                }
                
                let delta = newValue - lastOffset
                let threshold: CGFloat = 10 // Minimum drag to trigger change
                
                if delta > threshold && !isHidden {
                    // Scrolling Down -> Hide
                    isHidden = true
                } else if delta < -threshold && isHidden {
                    // Scrolling Up -> Show
                    isHidden = false
                }
                
                lastOffset = newValue
            }
            .preference(key: ScrollStatePreferenceKey.self, value: isHidden)
    }
}
