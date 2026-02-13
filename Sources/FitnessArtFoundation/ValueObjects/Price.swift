import Foundation

nonisolated struct Price: Sendable, Codable, Hashable {
    var amount: Decimal
    var currency: Locale.Currency

    init(amount: Decimal, currency: Locale.Currency) {
        self.amount = amount
        self.currency = currency
    }
}

extension Price {

    static func zero(currency: Locale.Currency) -> Price {
        Price(amount: 0, currency: currency)
    }

    func withAmount(_ amount: Decimal) -> Price {
        Price(amount: amount, currency: currency)
    }

}

extension Price {

    var debugDescription: String {
        "\(amount) \(currency)"
    }

}
