import Foundation

/// Studio policy governing when a session "freezes" ahead of its start time.
///
/// At freeze time the studio's booking rules take effect: workout credits are
/// deducted, cancellations lock, and the waitlist auto-promotes. The standard
/// studio policy freezes one hour before the session begins.
///
/// Shared between the backend (which stamps `freezeAt` on each session and runs
/// the freeze sweep) and the mobile app (which locks the cancel button once the
/// freeze instant has passed) so both agree on the exact boundary.
public struct FreezeTimePolicy: Sendable, Equatable, Codable {

    /// How long before the session start the freeze window opens.
    public let leadTime: TimeInterval

    public init(leadTime: TimeInterval) {
        self.leadTime = leadTime
    }

    /// The standard studio policy: freeze one hour before the session starts.
    public static let standard = FreezeTimePolicy(leadTime: 60 * 60)

    /// The instant at which a session freezes, given its start instant.
    public func freezeTime(sessionStart: Date) -> Date {
        sessionStart.addingTimeInterval(-leadTime)
    }

    /// Whether the session has frozen at the given `now`.
    public func isFrozen(sessionStart: Date, now: Date) -> Bool {
        now >= freezeTime(sessionStart: sessionStart)
    }
}
