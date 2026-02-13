import Foundation

nonisolated struct LocalizedString: Sendable, Codable, Hashable {
    static let empty = LocalizedString(translations: [:])

    let translations: [String: String]

    func string(in lang: String? = nil) -> String {
        return translations[lang ?? defaultLanguageCode] ?? ""
    }

    func string(for locale: Locale?) -> String {
        let languageCode = locale?.language.languageCode?.identifier ?? defaultLanguageCode
        return translations[languageCode] ?? ""
    }

    var defaultLanguageCode: String {
        Locale.preferredLanguages.first?
            .components(separatedBy: "-").first ?? "en"
    }
}

// MARK: - Copy With

extension LocalizedString {

    func copyWith(string: String, for locale: Locale) -> LocalizedString {
        var newValues = translations
        if let languageCode = locale.language.languageCode?.identifier {
            newValues[languageCode] = string
        }
        return LocalizedString(translations: newValues)
    }

}

// MARK: - Collection Conformance

extension LocalizedString: Collection {
    typealias Index = [String: String].Index
    typealias Element = [String: String].Element

    var startIndex: Index { translations.startIndex }
    var endIndex: Index { translations.endIndex }

    subscript(position: Index) -> Element {
        return translations[position]
    }

    func index(after i: Index) -> Index {
        return translations.index(after: i)
    }

}

// MARK: - Codable

extension LocalizedString {
    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String: String].self)
        self.translations = dict
    }

    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(translations)
    }
}
