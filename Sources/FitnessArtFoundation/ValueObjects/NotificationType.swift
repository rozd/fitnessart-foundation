public enum NotificationType: String, Codable, Sendable {
    case bookingConfirmed = "booking_confirmed"
    case bookingCancelled = "booking_cancelled"
    case waitlistJoined = "waitlist_joined"
    case waitlistPromoted = "waitlist_promoted"
    case sessionCancelled = "session_cancelled"
    case sessionChanged = "session_changed"
    case sessionReminder = "session_reminder"
}
