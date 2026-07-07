public enum CancellationType: String, Codable, Sendable {
    /// Member cancelled before freeze time — spot released, no penalty.
    case timely
    /// Member cancelled after freeze time — credit already deducted, no refund.
    case late
    /// Freeze-time sweep dropped the booking because the member had no
    /// remaining credits / entitlement to fund the session.
    case insufficientCredits = "insufficient_credits"
}
