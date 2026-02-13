import Foundation

public struct Coordinates: Codable, Sendable, Equatable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) throws {
        guard (-90...90).contains(latitude) else {
            throw Coordinates.Error.invalidLatitude(latitude)
        }
        guard (-180...180).contains(longitude) else {
            throw Coordinates.Error.invalidLongitude(longitude)
        }
        self.latitude = latitude
        self.longitude = longitude
    }

}

extension Coordinates {
    enum Error {
        case invalidLatitude(Double)
        case invalidLongitude(Double)

        var errorDescription: String? {
            switch self {
            case .invalidLatitude(let lat):
                return "Latitude must be between -90 and 90, got \(lat)"
            case .invalidLongitude(let lng):
                return "Longitude must be between -180 and 180, got \(lng)"
            }
        }
    }
}

extension Coordinates.Error: Error {
}

