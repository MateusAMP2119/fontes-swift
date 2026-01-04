# Swift 6.0 Release Notes Summary

Swift 6.0, released in September 2024, introduces major advancements in safety, performance, and developer productivity.

## Key Features

### 1. Complete Concurrency Checking
Data-race safety is now a compile-time guarantee. Swift 6 eliminates data races by verifying the safety of concurrent code at compile time.
*   **Default Behavior:** Enabled by default in Swift 6 language mode.
*   **Migration:** Incremental migration is supported from Swift 5 modes.

### 2. Typed Throws
Functions can now specify the exact type of error they throw, rather than just `any Error`.
```swift
func parse(value: String) throws(ParseError) -> Int { ... }
```
This improves type safety and allows clients to exhaustively catch errors without a generic `catch` block.

### 3. 128-bit Integer Types
Native support for `Int128` and `UInt128` is now available on all platforms.
```swift
let bigNumber: Int128 = 100_000_000_000_000_000_000_000_000_000
```

### 4. Noncopyable Types (Improvements)
Enhanced support for noncopyable (move-only) types.
*   **Generics:** Noncopyable types can now be used with generics in more contexts.
*   **Partial Consumption:** Support for partially consuming fields of a noncopyable struct.

### 5. Embedded Swift (Experimental)
A new compilation mode for constrained environments (microcontrollers, kernel development).
*   Produces small, standalone binaries without the Swift runtime dependency.
*   Disables runtime-dependent features (like reflection) to ensure small footprint.

### 6. C++ Interoperability
Expanded support for C++ features, including:
*   Move-only types
*   Virtual methods
*   Default arguments
*   Better standard library integration

### 7. Swift Testing Framework
A new, modern testing framework designed specifically for Swift.
*   **Expressive APIs:** `let result = try #require(function())`
*   **Macros:** Heavily uses macros for clear syntax.
*   **Parallel Execution:** Built-in support for running tests in parallel.

### 8. Access Control for Imports
You can now specify the visibility of imported modules.
```swift
public import MyLibrary
internal import MyInternalHelper
```
This helps prevent leaking implementation details in your public API.

## Updates for Apple Platforms
*   **Foundation:** The Foundation framework is now written in Swift, sharing a single implementation across macOS, iOS, Linux, and Windows.
*   **Xcode 16:** Swift 6 is the default toolchain in Xcode 16.

## References
*   [Official Swift 6 Announcement](https://swift.org)
*   [SE-0414: Region based Isolation](https://github.com/apple/swift-evolution/blob/main/proposals/0414-region-based-isolation.md)
