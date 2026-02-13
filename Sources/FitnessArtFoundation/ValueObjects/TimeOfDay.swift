import Foundation

/// Represents a time of day without a date (hours and minutes from midnight).
/// Used for recurring schedules that repeat weekly.
nonisolated struct TimeOfDay: Sendable, Equatable, Hashable, Codable, Comparable {
    let hour: Int      // 0-23
    let minute: Int    // 0-59

    init(hour: Int, minute: Int) {
        precondition(hour >= 0 && hour < 24, "Hour must be 0-23")
        precondition(minute >= 0 && minute < 60, "Minute must be 0-59")
        self.hour = hour
        self.minute = minute
    }

    /// Total minutes from midnight (for calculations)
    var totalMinutes: Int { hour * 60 + minute }

    /// Create from total minutes from midnight
    init(totalMinutes: Int) {
        let normalized = ((totalMinutes % (24 * 60)) + (24 * 60)) % (24 * 60)
        self.hour = normalized / 60
        self.minute = normalized % 60
    }

    /// Snap to the nearest interval (e.g., 30 minutes)
    func snapped(to interval: Int) -> TimeOfDay {
        guard interval > 0 else { return self }
        let snappedMinutes = ((totalMinutes + interval / 2) / interval) * interval
        return TimeOfDay(totalMinutes: snappedMinutes)
    }

    /// Add minutes to this time
    func adding(minutes: Int) -> TimeOfDay {
        TimeOfDay(totalMinutes: totalMinutes + minutes)
    }

    /// Subtract minutes from this time
    func subtracting(minutes: Int) -> TimeOfDay {
        adding(minutes: -minutes)
    }

    static func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
        lhs.totalMinutes < rhs.totalMinutes
    }
}

extension TimeOfDay {

    init(from string: String) throws {
        let components = string.split(separator: ":")
        guard components.count == 2,
              let h = Int(components[0]), (0...23).contains(h),
              let m = Int(components[1]), (0...59).contains(m) else {
            throw NSError(domain: "TimeOfDay", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid time format: \(string)"])
        }

        self.hour = h
        self.minute = m
    }

    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        let components = stringValue.split(separator: ":")
        guard components.count == 2,
              let h = Int(components[0]), (0...23).contains(h),
              let m = Int(components[1]), (0...59).contains(m) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid time format: \(stringValue)")
        }

        self.hour = h
        self.minute = m
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let stringValue = String(format: "%02d:%02d", hour, minute)
        try container.encode(stringValue)
    }

}

// MARK: - Common Times

extension TimeOfDay {
    static let midnight = TimeOfDay(hour: 0, minute: 0)
    static let noon = TimeOfDay(hour: 12, minute: 0)
}

// MARK: - Display

extension TimeOfDay {
    /// Format as "HH:mm"
    var formatted: String {
        String(format: "%02d:%02d", hour, minute)
    }

    /// Format as "H:mm AM/PM"
    func formatted(style: Date.FormatStyle.TimeStyle) -> String {
        let calendar = Calendar.current
        let components = DateComponents(hour: hour, minute: minute)
        guard let date = calendar.date(from: components) else {
            return formatted
        }
        return date.formatted(date: .omitted, time: style)
    }
}

// MARK: - Identifiable

extension TimeOfDay: Identifiable {
    var id: Int { totalMinutes }
}
