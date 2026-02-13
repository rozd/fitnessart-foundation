public enum WorkoutAllowance: Sendable, Equatable, Hashable, Codable {
    case limited(to: Int)
    case unlimited

    public init(total: Int?) {
        if let total, total > 0 {
            self = .limited(to: total)
        } else {
            self = .unlimited
        }
    }

    public var total: Int? {
        switch self {
        case .limited(to: let value): return value
        case .unlimited: return nil
        }
    }
}

// MARK: - Identifiable

extension WorkoutAllowance: Identifiable {

    public var id: String {
        switch self {
        case .limited(to: let value): return "\(value)"
        case .unlimited: return "unlimited"
        }
    }
}

// MARK: - Codable

extension WorkoutAllowance {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let total = try container.decode(Int?.self)
        self.init(total: total)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .limited(to: let value):
            try container.encode(value)
        case .unlimited:
            try container.encodeNil()
        }
    }
}
