import SwiftUI

struct WhitelistView: View {
    @EnvironmentObject var whitelistService: WhitelistService
    @EnvironmentObject var l10n: L10n
    @State private var showingAdd = false
    @State private var newPath = ""
    @State private var newNote = ""

    var body: some View {
        Group {
            if whitelistService.entries.isEmpty {
                ContentUnavailableView(
                    l10n.noWhitelist,
                    systemImage: "list.bullet.rectangle",
                    description: Text(l10n.whitelistDescription)
                )
            } else {
                List {
                    ForEach(whitelistService.entries) { entry in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.path)
                                .font(.system(.body, design: .monospaced))
                            if !entry.note.isEmpty {
                                Text(entry.note)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Text(l10n.formattedDate(entry.addedAt))
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical, 2)
                    }
                    .onDelete { offsets in
                        whitelistService.remove(at: offsets)
                    }
                }
            }
        }
        .navigationTitle(l10n.whitelist)
        .toolbar {
            Button {
                showingAdd = true
            } label: {
                Label(l10n.add, systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingAdd) {
            addSheet
        }
    }

    private var addSheet: some View {
        VStack(spacing: 16) {
            Text(l10n.addWhitelistEntry)
                .font(.headline)

            TextField(l10n.pathPlaceholder, text: $newPath)
                .textFieldStyle(.roundedBorder)

            TextField(l10n.notePlaceholder, text: $newNote)
                .textFieldStyle(.roundedBorder)

            HStack {
                Button(l10n.cancel) {
                    resetAddForm()
                }
                .glassButtonStyle()
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button(l10n.browse) {
                    browseFolder()
                }
                .glassButtonStyle()

                Button(l10n.add) {
                    let expanded = (newPath as NSString).expandingTildeInPath
                    whitelistService.add(WhitelistEntry(path: expanded, note: newNote))
                    resetAddForm()
                }
                .glassProminentButtonStyle()
                .keyboardShortcut(.defaultAction)
                .disabled(!isValidWhitelistPath)
            }
        }
        .padding()
        .frame(width: 450)
    }

    private var isValidWhitelistPath: Bool {
        let expanded = (newPath as NSString).expandingTildeInPath
        guard expanded.hasPrefix("/"), expanded != "/" else { return false }
        let forbidden = ["/System", "/Library", "/usr", "/bin", "/sbin", "/private", "/Applications"]
        if forbidden.contains(expanded) { return false }
        return FileManager.default.fileExists(atPath: expanded)
    }

    private func resetAddForm() {
        newPath = ""
        newNote = ""
        showingAdd = false
    }

    private func browseFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        if panel.runModal() == .OK, let url = panel.url {
            newPath = url.path(percentEncoded: false)
        }
    }
}
