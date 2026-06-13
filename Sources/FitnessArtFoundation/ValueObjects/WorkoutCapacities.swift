/// The set of workout TYPES a studio conducts, each with its per-workout capacity.
///
/// Replaces the raw `[workoutId: Int]` map that previously lived on `Studio`
/// (`maxCapacityPerWorkout`). Splits the two conflated responsibilities behind
/// named accessors:
///   - `offeredWorkoutIds` — which workout types the studio conducts (the keys);
///   - `capacity(forWorkoutId:)` — the per-workout capacity (the values).
///
/// String-keyed because Foundation has no typed id types; the entity layers in
/// Mobile and Backend wrap/unwrap their own `WorkoutId` / `Workout.Id` at the boundary.
///
/// Codable encodes/decodes as the SAME flat map `{ "<workoutId>": <Int> }` that the
/// `studios.maxCapacityPerWorkout` Firestore field already uses — so no data migration.
public struct WorkoutCapacities: Sendable, Equatable, Hashable, Codable {

    private let storage: [String: Int]   // workoutId -> per-workout capacity

    public init(_ storage: [String: Int] = [:]) {
        self.storage = storage
    }

    public static let empty = WorkoutCapacities()

    // MARK: Responsibility A — which workout TYPES the studio conducts (the keys)

    public var offeredWorkoutIds: Set<String> { Set(storage.keys) }

    public func conducts(workoutId: String) -> Bool { storage[workoutId] != nil }

    // MARK: Responsibility B — per-workout capacity (the values)

    public func capacity(forWorkoutId id: String) -> Int? { storage[id] }

    // MARK: Boundary helpers for Model / DTO conversions

    public var isEmpty: Bool { storage.isEmpty }

    public var asDictionary: [String: Int] { storage }   // for *Model / *DTO mapping

    // MARK: - Codable (flat `{ id: Int }` map — identical to current Firestore shape)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.storage = try container.decode([String: Int].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(storage)
    }
}
