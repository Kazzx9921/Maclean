import SwiftUI

struct ScanningAnimationView: View {
    let title: String
    let fileLog: [String]

    private let lineHeight: CGFloat = 26

    var body: some View {
        VStack(spacing: 12) {
            ShimmerText(title)
                .font(.title2.bold())

            fileLogCanvas
        }
    }

    private var fileLogCanvas: some View {
        TimelineView(.animation) { _ in
            Canvas { context, size in
                let maxVisible = 30
                let lines = fileLog.count > maxVisible ? Array(fileLog.suffix(maxVisible)) : fileLog
                guard !lines.isEmpty else { return }

                let centerY = size.height / 2
                let totalLines = lines.count

                let lastLineBaseY = CGFloat(totalLines - 1) * lineHeight
                let currentScroll = lastLineBaseY - centerY

                for (index, line) in lines.enumerated() {
                    let yPos = CGFloat(index) * lineHeight - currentScroll + centerY

                    guard yPos > -lineHeight * 2 && yPos < size.height + lineHeight * 2 else { continue }

                    let distRatio = abs(yPos - centerY) / max(centerY, 1)
                    let opacity = max(0.0, 1.0 - distRatio * 1.3)

                    guard opacity > 0.01 else { continue }

                    let text = Text(line)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.primary.opacity(opacity))

                    let resolved = context.resolve(text)

                    context.drawLayer { ctx in
                        ctx.draw(resolved, at: CGPoint(x: size.width / 2, y: yPos))
                    }
                }
            }
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: .black, location: 0.15),
                        .init(color: .black, location: 0.85),
                        .init(color: .clear, location: 1.0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .frame(height: 300)
    }
}

// MARK: - Shimmer Text

private struct ShimmerText: View {
    let text: String
    @State private var phase: CGFloat = -1

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .foregroundStyle(.secondary)
            .overlay {
                GeometryReader { geo in
                    let width = geo.size.width
                    let gradientWidth = width * 0.8

                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0.0),
                            .init(color: .primary.opacity(0.6), location: 0.35),
                            .init(color: .primary, location: 0.5),
                            .init(color: .primary.opacity(0.6), location: 0.65),
                            .init(color: .clear, location: 1.0),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: gradientWidth)
                    .offset(x: phase * (width + gradientWidth * 0.5) - gradientWidth * 0.25)
                }
                .mask(Text(text).font(.title2.bold()))
            }
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2.5)
                    .repeatForever(autoreverses: true)
                ) {
                    phase = 1
                }
            }
    }
}
