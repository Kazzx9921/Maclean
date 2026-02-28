import SwiftUI

// MARK: - Glass background modifier
// macOS 26+: uses Liquid Glass (.glassEffect)
// macOS 15–25: falls back to .regularMaterial

struct GlassBackground: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        if #available(macOS 26, *) {
            content
                .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius, style: .continuous))
        } else {
            content
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(.quaternary, lineWidth: 0.5)
                )
        }
    }
}

// MARK: - Glass bar modifier (with corner radius for floating bar)

struct GlassBar: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        if #available(macOS 26, *) {
            content
                .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius, style: .continuous))
        } else {
            content
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }
}

// MARK: - Glass button style
// macOS 26+: .glass / .glassProminent
// macOS 15–25: falls back to standard styles

struct GlassButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 26, *) {
            content.buttonStyle(.glass)
        } else {
            content.buttonStyle(.bordered)
        }
    }
}

struct GlassProminentButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 26, *) {
            content.buttonStyle(.glassProminent)
        } else {
            content.buttonStyle(.borderedProminent)
        }
    }
}

extension View {
    func glassBackground(cornerRadius: CGFloat = 12) -> some View {
        modifier(GlassBackground(cornerRadius: cornerRadius))
    }

    func glassBar(cornerRadius: CGFloat = 12) -> some View {
        modifier(GlassBar(cornerRadius: cornerRadius))
    }

    func glassButtonStyle() -> some View {
        modifier(GlassButtonModifier())
    }

    func glassProminentButtonStyle() -> some View {
        modifier(GlassProminentButtonModifier())
    }
}
