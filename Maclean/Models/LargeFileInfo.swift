import Foundation

enum FileCategory: String, CaseIterable, Sendable {
    case all = "All"
    case video = "Videos"
    case archive = "Archives"
    case diskImage = "Disk Images"
    case installer = "Installers"
    case vm = "Virtual Machines"
    case other = "Other"
}

struct LargeFileInfo: Identifiable, Sendable {
    let id = UUID()
    let path: URL
    let size: Int64
    let modificationDate: Date?
    let category: FileCategory
    var isSelected: Bool = false

    var name: String { path.lastPathComponent }

    var relativePath: String {
        path.path(percentEncoded: false)
            .replacingOccurrences(
                of: FileManager.default.homeDirectoryForCurrentUser.path(percentEncoded: false),
                with: "~/"
            )
    }

    static func categorize(_ url: URL) -> FileCategory {
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "mp4", "mov", "avi", "mkv", "wmv", "flv", "webm", "m4v":
            return .video
        case "zip", "tar", "gz", "rar", "7z", "bz2", "xz", "tgz":
            return .archive
        case "dmg", "iso", "img", "sparseimage", "sparsebundle":
            return .diskImage
        case "pkg", "xip", "mpkg":
            return .installer
        case "vmdk", "vdi", "qcow2", "vmwarevm", "vhd", "ova":
            return .vm
        default:
            return .other
        }
    }
}
