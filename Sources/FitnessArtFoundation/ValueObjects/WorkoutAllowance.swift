enum WorkoutAllowance: Sendable, Equatable, Hashable, Codable {
    case limited(to: Int)
    case unlimited

    init(total: Int?) {
        if let total, total > 0 {
            self = .limited(to: total)
        } else {
            self = .unlimited
        }
    }
}

// MARK: - Identifiable

extension WorkoutAllowance: Identifiable {

    var id: String {
        switch self {
        case .limited(to: let value): return "\(value)"
        case .unlimited: return "unlimited"
        }
    }
}

// MARK: - Codable

extension WorkoutAllowance {

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let total = try container.decode(Int?.self)
        self.init(total: total)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .limited(to: let value):
            try container.encode(value)
        case .unlimited:
            try container.encodeNil()
        }
    }
}
