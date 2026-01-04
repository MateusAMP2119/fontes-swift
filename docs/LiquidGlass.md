# Liquid Glass Documentation

**Liquid Glass** (also known as Glassmorphism) is a dynamic and interactive material design system for SwiftUI. It combines the optical properties of glass with a sense of fluidity, blurring content behind it and reflecting surrounding light and color.

## Usage

### applying the Effect

The primary modifier is `.glassEffect()`. It applies the glass material to the view's background.

```swift
Text("Hello, Liquid Glass!")
    .glassEffect()
```

By default, this uses a `.regular` glass variant and a `Capsule` shape.

### Customization

#### Shape
You can specify the shape of the glass effect using the `in:` parameter.

```swift
VStack { ... }
    .glassEffect(in: RoundedRectangle(cornerRadius: 16))
```

#### Tint
Apply a tint color to the glass effect using the `.tint()` modifier.

```swift
Button(...)
    .glassEffect()
    .tint(.blue)
```

#### Variants
You can choose between different variants (if supported by the implementation):
- `.regular`: Stronger tint, better legibility.
- `.clear`: Subtler, good for decorative elements.

### Grouping and Morphing

For fluid transitions and combined shapes, use `GlassEffectContainer` and `.glassEffectUnion`.

```swift
GlassEffectContainer {
    Text("Item 1")
        .glassEffect()
        .matchedGeometryEffect(id: "item1", in: namespace)
    
    Text("Item 2")
        .glassEffect()
}
```

- **`GlassEffectContainer`**: Coordinates glass elements to blend them together.
- **`.glassEffectUnion(id: namespace:)`**: Merges separate glass views into a single fluid shape.

## Best Practices

- **Hierarchy**: Use Liquid Glass for floating elements like navigation bars, tab bars, and modals. Avoid using it for primary content backgrounds.
- **Accessibility**: The material automatically adapts to system settings like "Reduce Transparency" (becoming opaque) and "Increase Contrast".
- **Context**: Ensure the background behind the glass provides enough contrast or visual interest for the blur effect to be visible.

## Components

### GlassTabView
A tab bar implementation using the Liquid Glass material.

```swift
GlassTabView()
```

Uses `.tabViewBottomAccessory` to place the accessory view (like the tab bar) with the glass effect.

### TabAccessoryView
The content view for the `GlassTabView` accessory area.
