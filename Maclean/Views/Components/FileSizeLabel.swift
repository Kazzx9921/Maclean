import SwiftUI

struct FileSizeLabel: View {
    let bytes: Int64

    var body: some View {
        Text(FileSize.formatted(bytes))
            .font(.system(.callout, design: .monospaced))
            .foregroundStyle(.secondary)
    }
}
