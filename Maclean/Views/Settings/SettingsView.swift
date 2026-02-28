import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var l10n: L10n
    @EnvironmentObject var sentinel: SentinelService

    var body: some View {
        Form {
            Section(l10n.language) {
                Picker(l10n.language, selection: $l10n.currentLanguage) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
                .pickerStyle(.menu)
            }

            Section(l10n.sentinel) {
                Toggle(l10n.sentinelEnabled, isOn: $sentinel.isEnabled)
                Text(l10n.sentinelDesc)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section(l10n.about) {
                LabeledContent(l10n.version, value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.1.0")
                LabeledContent(l10n.build, value: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
            }
        }
        .formStyle(.grouped)
        .navigationTitle(l10n.settings)
    }
}
