public struct Amenity: Sendable, Codable {
    public let systemImageName: String
    public let title: String
    public let description: String?

    public init(systemImageName: String, title: String, description: String? = nil) {
        self.systemImageName = systemImageName
        self.title = title
        self.description = description
    }
}

extension Amenity: Equatable {

    public static func == (lhs: Amenity, rhs: Amenity) -> Bool {
        lhs.systemImageName == rhs.systemImageName
    }
}
