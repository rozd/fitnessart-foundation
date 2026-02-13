import Foundation

public struct Price: Sendable, Codable, Hashable {
    public var amount: Decimal
    public var currency: Locale.Currency

    public init(amount: Decimal, currency: Locale.Currency) {
        self.amount = amount
        self.currency = currency
    }
}

extension Price {

    public static func zero(currency: Locale.Currency) -> Price {
        Price(amount: 0, currency: currency)
    }

    public func withAmount(_ amount: Decimal) -> Price {
        Price(amount: amount, currency: currency)
    }

}

extension Price {

    public var debugDescription: String {
        "\(amount) \(currency)"
    }

}
