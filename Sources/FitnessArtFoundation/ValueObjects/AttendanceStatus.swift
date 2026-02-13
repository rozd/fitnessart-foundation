public enum AttendanceStatus: String, Codable, Sendable {
    case attended
    case noShow = "no_show"
    case lateCancelled = "late_cancelled"
}
