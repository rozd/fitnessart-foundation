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
