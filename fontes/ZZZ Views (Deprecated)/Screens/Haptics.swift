import Foundation
import CoreHaptics
import UIKit

/// A small helper to safely use haptics across devices and the simulator.
/// It checks hardware support before using Core Haptics and falls back to
/// UIKit feedback generators when needed.
public enum Haptics {
    private static var engine: CHHapticEngine?

    /// Returns true when the current device supports Core Haptics.
    public static var supportsHaptics: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }

    /// Prepare the haptic engine if supported. Safe to call multiple times.
    public static func prepare() {
        guard supportsHaptics else { return }
        if engine != nil { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            // If engine fails, keep engine nil so we use UIKit fallback.
            engine = nil
            #if DEBUG
            print("[Haptics] Failed to start engine: \(error)")
            #endif
        }
    }

    /// Play a simple transient haptic. Uses Core Haptics when available,
    /// otherwise falls back to a light impact.
    public static func playTransient() {
        if supportsHaptics {
            do {
                if engine == nil { prepare() }
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)
                let pattern = try CHHapticPattern(events: [event], parameters: [])
                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                // Fallback to UIKit if Core Haptics fails
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                #if DEBUG
                print("[Haptics] Transient fallback due to error: \(error)")
                #endif
            }
        } else {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    /// Play a notification haptic using UIKit, which works on more devices
    /// than Core Haptics pattern library access.
    public static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }

    /// Play an impact with a given style using UIKit.
    public static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
