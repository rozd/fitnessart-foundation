import Foundation

enum Weekday: Int, CaseIterable, Sendable, Codable, Identifiable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var id: Int { rawValue }

    static var allCasesOrderedUsingCurrentCalendar: [Weekday] {
        allCasesOrdered(using: .current)
    }

    static func allCasesOrdered(using calendar: Calendar) -> [Weekday] {
        let firstWeekday = calendar.firstWeekday // 1 = Sunday, 2 = Monday, etc.
        return (0..<7).compactMap { offset in
            let weekdayValue = ((firstWeekday - 1 + offset) % 7) + 1
            return Weekday(rawValue: weekdayValue)
        }
    }

    var orderIndexUsingCurrentCalendar: Int {
        orderIndex(using: .current)
    }

    func orderIndex(using calendar: Calendar) -> Int {
        let firstWeekday = calendar.firstWeekday
        let adjustedValue = (rawValue - firstWeekday + 7) % 7
        return adjustedValue
    }

    /// Create from ordered index (0 = Monday, 6 = Sunday)
    init?(orderedIndex: Int) {
        guard orderedIndex >= 0, orderedIndex < 7 else { return nil }
        self = Weekday.allCasesOrderedUsingCurrentCalendar[orderedIndex]
    }

    /// Short name (Mon, Tue, etc.) using current locale
    var shortName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.shortWeekdaySymbols[rawValue - 1]
    }

    /// Very short name (M, T, W, etc.) using current locale
    var veryShortName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.veryShortWeekdaySymbols[rawValue - 1]
    }

    /// Full name (Monday, Tuesday, etc.) using current locale
    var fullName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter.weekdaySymbols[rawValue - 1]
    }
}

// MARK: - Calendar Integration

extension Weekday {
    /// Get the weekday from a Date
    init?(from date: Date, calendar: Calendar = .current) {
        let weekday = calendar.component(.weekday, from: date)
        self.init(rawValue: weekday)
    }

    /// Get the next occurrence of this weekday from a given date
    func nextOccurrence(from date: Date = .now, calendar: Calendar = .current) -> Date? {
        var components = DateComponents()
        components.weekday = rawValue
        return calendar.nextDate(after: date, matching: components, matchingPolicy: .nextTime)
    }
}
