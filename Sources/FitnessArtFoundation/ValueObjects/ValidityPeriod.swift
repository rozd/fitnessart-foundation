import Foundation

public struct ValidityPeriod: Sendable, Equatable, Hashable, Codable {
    public let amount: Int
    public let unit: Calendar.Component

    public init(amount: Int, unit: Calendar.Component) {
        self.amount = amount
        self.unit = unit
    }
}

extension ValidityPeriod {
    public static func days(_ amount: Int) -> ValidityPeriod {
        ValidityPeriod(amount: amount, unit: .day)
    }

    public static func weeks(_ amount: Int) -> ValidityPeriod {
        ValidityPeriod(amount: amount, unit: .weekOfMonth)
    }

    public static func months(_ amount: Int) -> ValidityPeriod {
        ValidityPeriod(amount: amount, unit: .month)
    }
}

// MARK: - Identifiable

extension ValidityPeriod: Identifiable {

    public var id: String {
        "\(amount)-\(unit)"
    }
}

// MARK: - Codable

extension ValidityPeriod {

    enum CodingKeys: String, CodingKey {
        case amount
        case unit
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decode(Int.self, forKey: .amount)
        let unitString = try container.decode(String.self, forKey: .unit)
        switch unitString {
        case "day":
            unit = .day
        case "week":
            unit = .weekOfMonth
        case "month":
            unit = .month
        case "year":
            unit = .year
        default:
            throw DecodingError.dataCorruptedError(forKey: .unit, in: container, debugDescription: "Invalid unit value")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        let unitString: String
        switch unit {
        case .day:
            unitString = "day"
        case .weekOfMonth:
            unitString = "week"
        case .month:
            unitString = "month"
        case .year:
            unitString = "year"
        default:
            throw EncodingError.invalidValue(unit, EncodingError.Context(codingPath: [CodingKeys.unit], debugDescription: "Invalid unit value"))
        }
        try container.encode(unitString, forKey: .unit)
    }
}

// MARK: - For Display

extension ValidityPeriod {

    public var labelForDisplay: String {
        unit.labelForDisplay
    }

    public var descriptionForDisplay: String {
        "\(amount) \(labelForDisplay)"
    }

}

extension Calendar.Component {

    public var labelForDisplay: String {
        switch self {
        case .day:
            return "Days"
        case .weekOfMonth:
            return "Weeks"
        case .month:
            return "Months"
        case .year:
            return "Years"
        default:
            return ""
        }
    }

}
