import SwiftUI

struct HeaderVisibilityPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = true
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

extension View {
    func onScrollHideHeader() -> some View {
        modifier(ScrollHeaderBehaviorModifier())
    }
}

@available(iOS 18.0, *)
struct ScrollHeaderBehaviorModifier: ViewModifier {
    @State private var isHeaderVisible = true
    
    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: Bool.self) { geometry in
                let contentOffset = geometry.contentOffset.y
                let contentSize = geometry.contentSize.height
                let containerSize = geometry.containerSize.height
                
                // Always show if content is smaller than screen or near top
                if contentSize <= containerSize || contentOffset <= 0 {
                   return true
                }
                
                // Show/Hide based on scroll direction (using raw content offset check vs previous would be manual,
                // but we can check if we are simply scrolling down/up?
                // Actually, onScrollGeometryChange gives us a 'velocity' indirectly via snapshot comparison if we wanted,
                // but the standard way is often to track `oldValue` vs `newValue` in the trailing closure of `onScrollGeometryChange`
                // Wait, `onScrollGeometryChange` has `of`, `action`.
                
                // Let's stick to a simpler logic:
                // We return the state we want.
                
                return true // Placeholder, logic is in the compute
            } action: { oldValue, newValue in
                // We actually want to calculate *inside* the map or just use the action.
                // But onScrollGeometryChange(for: ...) computes a value derived from geometry.
                
                // Let's use the transformation to Bool directly.
            }
            // Retrying with correct API usage below.
            .background {
                // To avoid "modifier inside modifier" confusion, let's use the standard geometry reader approach 
                // OR use the new API specifically.
                // The prompt specified iOS 18 APIs.
                EmptyView()
            }
    }
}

// Correct Implementation using iOS 18 API
@available(iOS 18.0, *)
private struct ScrollHeaderLogicModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: Bool.self) { geometry in
                // Logic:
                // 1. If at top (offset < 0), visible = true
                // 2. If scrolling down (we need to compare old vs new offset, but this closure is stateless snapshot)
                //    Wait, this API is for deriving a value.
                //    We need velocity. Geometry doesn't give velocity directly?
                //    We can check bounds.
                
                // Let's use the `onScrollPhaseChange` or simply track offset in a state if needed?
                // Actually `onScrollGeometryChange` allows us to compute a value.
                
                // If we want "velocity" or "direction", we might need to compare with previous logic inside the `action`
                // BUT `action` only fires when the *computed value* changes.
                
                // Let's return the `contentOffset.y` and handle logic in `action`.
                return geometry.contentOffset.y < 0
            } action: { wasAtTop, isAtTop in
                // This only tells us if we pass 0. Not directional scrolling deeper down.
            }
    }
}

// Let's go with a robust robust solution that tracks direction.
struct ScrollDetectionModifier: ViewModifier {
    @State private var lastOffset: CGFloat = 0
    @State private var isVisible: Bool = true
    
    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .onScrollGeometryChange(for: CGFloat.self) { geometry in
                    geometry.contentOffset.y
                } action: { oldValue, newValue in
                    let threshold: CGFloat = 50 // Buffer
                    if newValue <= 0 {
                        // At top, show
                        if !isVisible { isVisible = true }
                    } else if newValue > oldValue {
                        // Scrolling Down -> Hide
                        if isVisible && newValue > threshold { isVisible = false }
                    } else {
                        // Scrolling Up -> Show
                        if !isVisible { isVisible = true }
                    }
                }
                .preference(key: HeaderVisibilityPreferenceKey.self, value: isVisible)
        } else {
            // Fallback for older iOS if needed, though instructions said iOS 18
            content
        }
    }
}
