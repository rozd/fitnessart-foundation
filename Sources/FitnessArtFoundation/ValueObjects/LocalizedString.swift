import Foundation

public struct LocalizedString: Sendable, Codable, Hashable {
    public static let empty = LocalizedString(translations: [:])

    public let translations: [String: String]

    public init(translations: [String: String]) {
        self.translations = translations
    }

    public func string(in lang: String? = nil) -> String {
        return translations[lang ?? defaultLanguageCode] ?? ""
    }

    public func string(for locale: Locale?) -> String {
        let languageCode = locale?.language.languageCode?.identifier ?? defaultLanguageCode
        return translations[languageCode] ?? ""
    }

    public var defaultLanguageCode: String {
        Locale.preferredLanguages.first?
            .components(separatedBy: "-").first ?? "en"
    }
}

// MARK: - Copy With

extension LocalizedString {

    public func copyWith(string: String, for locale: Locale) -> LocalizedString {
        var newValues = translations
        if let languageCode = locale.language.languageCode?.identifier {
            newValues[languageCode] = string
        }
        return LocalizedString(translations: newValues)
    }

}

// MARK: - Collection Conformance

extension LocalizedString: Collection {
    public typealias Index = [String: String].Index
    public typealias Element = [String: String].Element

    public var startIndex: Index { translations.startIndex }
    public var endIndex: Index { translations.endIndex }

    public subscript(position: Index) -> Element {
        return translations[position]
    }

    public func index(after i: Index) -> Index {
        return translations.index(after: i)
    }

}

// MARK: - Codable

extension LocalizedString {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String: String].self)
        self.translations = dict
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(translations)
    }
}
