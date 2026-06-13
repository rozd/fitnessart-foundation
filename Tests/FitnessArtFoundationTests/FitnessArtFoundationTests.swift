import Foundation
import Testing
import FitnessArtFoundation

// MARK: - TimeOfDay Tests

@Suite("TimeOfDay")
struct TimeOfDayTests {

    @Test("Valid init at boundaries", arguments: [
        (0, 0), (23, 59), (12, 30),
    ])
    func validInit(hour: Int, minute: Int) throws {
        let time = try TimeOfDay(hour: hour, minute: minute)
        #expect(time.hour == hour)
        #expect(time.minute == minute)
    }

    @Test("Invalid hour throws")
    func invalidHour() {
        #expect(throws: TimeOfDay.Error.self) {
            try TimeOfDay(hour: -1, minute: 0)
        }
        #expect(throws: TimeOfDay.Error.self) {
            try TimeOfDay(hour: 24, minute: 0)
        }
    }

    @Test("Invalid minute throws")
    func invalidMinute() {
        #expect(throws: TimeOfDay.Error.self) {
            try TimeOfDay(hour: 0, minute: -1)
        }
        #expect(throws: TimeOfDay.Error.self) {
            try TimeOfDay(hour: 0, minute: 60)
        }
    }

    @Test("totalMinutes computation")
    func totalMinutes() throws {
        let time = try TimeOfDay(hour: 14, minute: 30)
        #expect(time.totalMinutes == 870)
    }

    @Test("Init from totalMinutes — normal")
    func initFromTotalMinutesNormal() {
        let time = TimeOfDay(totalMinutes: 870)
        #expect(time.hour == 14)
        #expect(time.minute == 30)
    }

    @Test("Init from totalMinutes — wrapping negative")
    func initFromTotalMinutesNegative() {
        let time = TimeOfDay(totalMinutes: -60)
        #expect(time.hour == 23)
        #expect(time.minute == 0)
    }

    @Test("Init from totalMinutes — wrapping over 1440")
    func initFromTotalMinutesOver1440() {
        let time = TimeOfDay(totalMinutes: 1500)
        #expect(time.hour == 1)
        #expect(time.minute == 0)
    }

    @Test("snapped(to:) rounds to nearest interval")
    func snapped() throws {
        let time = try TimeOfDay(hour: 14, minute: 17)
        let snapped = time.snapped(to: 15)
        #expect(snapped.hour == 14)
        #expect(snapped.minute == 15)
    }

    @Test("snapped(to: 0) returns self")
    func snappedZeroInterval() throws {
        let time = try TimeOfDay(hour: 14, minute: 17)
        let snapped = time.snapped(to: 0)
        #expect(snapped == time)
    }

    @Test("adding(minutes:) normal")
    func addingMinutes() throws {
        let time = try TimeOfDay(hour: 14, minute: 30)
        let result = time.adding(minutes: 45)
        #expect(result.hour == 15)
        #expect(result.minute == 15)
    }

    @Test("adding(minutes:) wraps past midnight")
    func addingMinutesWrap() throws {
        let time = try TimeOfDay(hour: 23, minute: 30)
        let result = time.adding(minutes: 60)
        #expect(result.hour == 0)
        #expect(result.minute == 30)
    }

    @Test("subtracting(minutes:) normal")
    func subtractingMinutes() throws {
        let time = try TimeOfDay(hour: 14, minute: 30)
        let result = time.subtracting(minutes: 45)
        #expect(result.hour == 13)
        #expect(result.minute == 45)
    }

    @Test("subtracting(minutes:) wraps before midnight")
    func subtractingMinutesWrap() throws {
        let time = try TimeOfDay(hour: 0, minute: 30)
        let result = time.subtracting(minutes: 60)
        #expect(result.hour == 23)
        #expect(result.minute == 30)
    }

    @Test("Codable round-trip encodes as HH:mm string")
    func codableRoundTrip() throws {
        let time = try TimeOfDay(hour: 9, minute: 5)
        let data = try JSONEncoder().encode(time)
        let jsonString = String(data: data, encoding: .utf8)!
        #expect(jsonString == "\"09:05\"")
        let decoded = try JSONDecoder().decode(TimeOfDay.self, from: data)
        #expect(decoded == time)
    }

    @Test("Init from valid string")
    func initFromValidString() throws {
        let time = try TimeOfDay(from: "14:30")
        #expect(time.hour == 14)
        #expect(time.minute == 30)
    }

    @Test("Init from invalid string throws")
    func initFromInvalidString() {
        #expect(throws: (any Swift.Error).self) {
            try TimeOfDay(from: "25:00")
        }
        #expect(throws: (any Swift.Error).self) {
            try TimeOfDay(from: "abc")
        }
    }

    @Test("formatted property")
    func formatted() throws {
        let time = try TimeOfDay(hour: 9, minute: 5)
        #expect(time.formatted == "09:05")
    }

    @Test("Comparable ordering")
    func comparable() throws {
        let early = try TimeOfDay(hour: 8, minute: 0)
        let late = try TimeOfDay(hour: 17, minute: 30)
        #expect(early < late)
        #expect(!(late < early))
    }

    @Test("Identifiable id equals totalMinutes")
    func identifiable() throws {
        let time = try TimeOfDay(hour: 14, minute: 30)
        #expect(time.id == time.totalMinutes)
    }

    @Test("Equatable")
    func equatable() throws {
        let a = try TimeOfDay(hour: 12, minute: 0)
        let b = try TimeOfDay(hour: 12, minute: 0)
        let c = try TimeOfDay(hour: 12, minute: 1)
        #expect(a == b)
        #expect(a != c)
    }

    @Test("Hashable — equal values hash the same")
    func hashable() throws {
        let a = try TimeOfDay(hour: 12, minute: 0)
        let b = try TimeOfDay(hour: 12, minute: 0)
        #expect(a.hashValue == b.hashValue)
        let set: Set<TimeOfDay> = [a, b]
        #expect(set.count == 1)
    }
}

// MARK: - Weekday Tests

@Suite("Weekday")
struct WeekdayTests {

    @Test("Raw values Sunday=1 through Saturday=7")
    func rawValues() {
        #expect(Weekday.sunday.rawValue == 1)
        #expect(Weekday.monday.rawValue == 2)
        #expect(Weekday.tuesday.rawValue == 3)
        #expect(Weekday.wednesday.rawValue == 4)
        #expect(Weekday.thursday.rawValue == 5)
        #expect(Weekday.friday.rawValue == 6)
        #expect(Weekday.saturday.rawValue == 7)
    }

    @Test("Init from valid rawValue")
    func initValidRawValue() {
        #expect(Weekday(rawValue: 1) == .sunday)
        #expect(Weekday(rawValue: 7) == .saturday)
    }

    @Test("Init from invalid rawValue returns nil")
    func initInvalidRawValue() {
        #expect(Weekday(rawValue: 0) == nil)
        #expect(Weekday(rawValue: 8) == nil)
    }

    @Test("Init from Date extracts correct weekday")
    func initFromDate() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        // 2024-01-01 is a Monday
        let components = DateComponents(year: 2024, month: 1, day: 1)
        let date = calendar.date(from: components)!
        let weekday = Weekday(from: date, calendar: calendar)
        #expect(weekday == .monday)
    }

    @Test("allCasesOrdered with Monday-first calendar")
    func allCasesOrderedMondayFirst() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // Monday
        let ordered = Weekday.allCasesOrdered(using: calendar)
        #expect(ordered.first == .monday)
        #expect(ordered.last == .sunday)
        #expect(ordered.count == 7)
    }

    @Test("allCasesOrdered with Sunday-first calendar")
    func allCasesOrderedSundayFirst() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1 // Sunday
        let ordered = Weekday.allCasesOrdered(using: calendar)
        #expect(ordered.first == .sunday)
        #expect(ordered.last == .saturday)
        #expect(ordered.count == 7)
    }

    @Test("orderIndex consistency with allCasesOrdered")
    func orderIndexConsistency() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // Monday
        let ordered = Weekday.allCasesOrdered(using: calendar)
        for (index, day) in ordered.enumerated() {
            #expect(day.orderIndex(using: calendar) == index)
        }
    }

    @Test("shortName returns non-empty string")
    func shortName() {
        for day in Weekday.allCases {
            #expect(!day.shortName.isEmpty)
        }
    }

    @Test("veryShortName returns non-empty string")
    func veryShortName() {
        for day in Weekday.allCases {
            #expect(!day.veryShortName.isEmpty)
        }
    }

    @Test("fullName returns non-empty string")
    func fullName() {
        for day in Weekday.allCases {
            #expect(!day.fullName.isEmpty)
        }
    }

    @Test("Identifiable id equals rawValue")
    func identifiable() {
        for day in Weekday.allCases {
            #expect(day.id == day.rawValue)
        }
    }

    @Test("Codable round-trip encodes as Int")
    func codableRoundTrip() throws {
        let day = Weekday.wednesday
        let data = try JSONEncoder().encode(day)
        let jsonString = String(data: data, encoding: .utf8)!
        #expect(jsonString == "4")
        let decoded = try JSONDecoder().decode(Weekday.self, from: data)
        #expect(decoded == day)
    }

    @Test("nextOccurrence returns future date on correct weekday")
    func nextOccurrence() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = DateComponents(year: 2024, month: 1, day: 1) // Monday
        let date = calendar.date(from: components)!
        let nextFriday = Weekday.friday.nextOccurrence(from: date, calendar: calendar)
        #expect(nextFriday != nil)
        let dayComponent = calendar.component(.weekday, from: nextFriday!)
        #expect(dayComponent == Weekday.friday.rawValue)
        #expect(nextFriday! > date)
    }
}

// MARK: - Price Tests

@Suite("Price")
struct PriceTests {

    @Test("Init stores amount and currency")
    func initStoresValues() {
        let price = Price(amount: 29.99, currency: Locale.Currency("EUR"))
        #expect(price.amount == 29.99)
        #expect(price.currency == Locale.Currency("EUR"))
    }

    @Test("zero factory")
    func zeroFactory() {
        let price = Price.zero(currency: Locale.Currency("USD"))
        #expect(price.amount == 0)
        #expect(price.currency == Locale.Currency("USD"))
    }

    @Test("withAmount preserves currency")
    func withAmount() {
        let original = Price(amount: 10, currency: Locale.Currency("EUR"))
        let updated = original.withAmount(25)
        #expect(updated.amount == 25)
        #expect(updated.currency == Locale.Currency("EUR"))
    }

    @Test("Codable round-trip")
    func codableRoundTrip() throws {
        let price = Price(amount: 49.99, currency: Locale.Currency("USD"))
        let data = try JSONEncoder().encode(price)
        let decoded = try JSONDecoder().decode(Price.self, from: data)
        #expect(decoded == price)
    }

    @Test("Hashable — same values hash equally")
    func hashable() {
        let a = Price(amount: 10, currency: Locale.Currency("EUR"))
        let b = Price(amount: 10, currency: Locale.Currency("EUR"))
        let c = Price(amount: 20, currency: Locale.Currency("EUR"))
        #expect(a.hashValue == b.hashValue)
        let set: Set<Price> = [a, b]
        #expect(set.count == 1)
        #expect(a != c)
    }

    @Test("debugDescription format")
    func debugDescription() {
        let price = Price(amount: 10, currency: Locale.Currency("EUR"))
        #expect(price.debugDescription.contains("10"))
        #expect(price.debugDescription.lowercased().contains("eur"))
    }
}

// MARK: - Coordinates Tests

@Suite("Coordinates")
struct CoordinatesTests {

    @Test("Valid init at boundaries", arguments: [
        (0.0, 0.0), (90.0, 180.0), (-90.0, -180.0),
    ])
    func validInit(latitude: Double, longitude: Double) throws {
        let coords = try Coordinates(latitude: latitude, longitude: longitude)
        #expect(coords.latitude == latitude)
        #expect(coords.longitude == longitude)
    }

    @Test("Invalid latitude throws")
    func invalidLatitude() {
        #expect(throws: Coordinates.Error.self) {
            try Coordinates(latitude: 91, longitude: 0)
        }
        #expect(throws: Coordinates.Error.self) {
            try Coordinates(latitude: -91, longitude: 0)
        }
    }

    @Test("Invalid longitude throws")
    func invalidLongitude() {
        #expect(throws: Coordinates.Error.self) {
            try Coordinates(latitude: 0, longitude: 181)
        }
        #expect(throws: Coordinates.Error.self) {
            try Coordinates(latitude: 0, longitude: -181)
        }
    }

    @Test("Codable round-trip")
    func codableRoundTrip() throws {
        let coords = try Coordinates(latitude: 48.8566, longitude: 2.3522)
        let data = try JSONEncoder().encode(coords)
        let decoded = try JSONDecoder().decode(Coordinates.self, from: data)
        #expect(decoded == coords)
    }

    @Test("Equatable")
    func equatable() throws {
        let a = try Coordinates(latitude: 48.8566, longitude: 2.3522)
        let b = try Coordinates(latitude: 48.8566, longitude: 2.3522)
        let c = try Coordinates(latitude: 0, longitude: 0)
        #expect(a == b)
        #expect(a != c)
    }
}

// MARK: - ValidityPeriod Tests

@Suite("ValidityPeriod")
struct ValidityPeriodTests {

    @Test("Init with amount and unit")
    func initStoresValues() {
        let period = ValidityPeriod(amount: 30, unit: .day)
        #expect(period.amount == 30)
        #expect(period.unit == .day)
    }

    @Test("Factory methods")
    func factoryMethods() {
        let days = ValidityPeriod.days(7)
        #expect(days.amount == 7)
        #expect(days.unit == .day)

        let weeks = ValidityPeriod.weeks(4)
        #expect(weeks.amount == 4)
        #expect(weeks.unit == .weekOfMonth)

        let months = ValidityPeriod.months(3)
        #expect(months.amount == 3)
        #expect(months.unit == .month)
    }

    @Test("Identifiable id format")
    func identifiable() {
        let period = ValidityPeriod.days(30)
        #expect(period.id == "30-day")
    }

    @Test("Codable round-trip — day")
    func codableDay() throws {
        let period = ValidityPeriod.days(30)
        let data = try JSONEncoder().encode(period)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        #expect(json["unit"] as? String == "day")
        let decoded = try JSONDecoder().decode(ValidityPeriod.self, from: data)
        #expect(decoded == period)
    }

    @Test("Codable round-trip — week")
    func codableWeek() throws {
        let period = ValidityPeriod.weeks(2)
        let data = try JSONEncoder().encode(period)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        #expect(json["unit"] as? String == "week")
        let decoded = try JSONDecoder().decode(ValidityPeriod.self, from: data)
        #expect(decoded == period)
    }

    @Test("Codable round-trip — month")
    func codableMonth() throws {
        let period = ValidityPeriod.months(6)
        let data = try JSONEncoder().encode(period)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        #expect(json["unit"] as? String == "month")
        let decoded = try JSONDecoder().decode(ValidityPeriod.self, from: data)
        #expect(decoded == period)
    }

    @Test("Codable round-trip — year")
    func codableYear() throws {
        let period = ValidityPeriod(amount: 1, unit: .year)
        let data = try JSONEncoder().encode(period)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        #expect(json["unit"] as? String == "year")
        let decoded = try JSONDecoder().decode(ValidityPeriod.self, from: data)
        #expect(decoded == period)
    }

    @Test("Decoding invalid unit string throws")
    func decodingInvalidUnit() throws {
        let json = #"{"amount": 1, "unit": "invalid"}"#
        let data = json.data(using: .utf8)!
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(ValidityPeriod.self, from: data)
        }
    }

    @Test("Encoding unsupported Calendar.Component throws")
    func encodingUnsupportedUnit() {
        let period = ValidityPeriod(amount: 1, unit: .hour)
        #expect(throws: EncodingError.self) {
            try JSONEncoder().encode(period)
        }
    }

    @Test("labelForDisplay")
    func labelForDisplay() {
        #expect(ValidityPeriod.days(1).labelForDisplay == "Days")
        #expect(ValidityPeriod.weeks(1).labelForDisplay == "Weeks")
        #expect(ValidityPeriod.months(1).labelForDisplay == "Months")
    }

    @Test("descriptionForDisplay")
    func descriptionForDisplay() {
        #expect(ValidityPeriod.days(30).descriptionForDisplay == "30 Days")
        #expect(ValidityPeriod.weeks(4).descriptionForDisplay == "4 Weeks")
    }

    @Test("Calendar.Component.labelForDisplay — known and unknown")
    func calendarComponentLabel() {
        #expect(Calendar.Component.day.labelForDisplay == "Days")
        #expect(Calendar.Component.weekOfMonth.labelForDisplay == "Weeks")
        #expect(Calendar.Component.month.labelForDisplay == "Months")
        #expect(Calendar.Component.year.labelForDisplay == "Years")
        #expect(Calendar.Component.hour.labelForDisplay == "")
    }

    @Test("Equatable")
    func equatable() {
        #expect(ValidityPeriod.days(30) == ValidityPeriod.days(30))
        #expect(ValidityPeriod.days(30) != ValidityPeriod.days(7))
        #expect(ValidityPeriod.days(30) != ValidityPeriod.months(30))
    }

    @Test("Hashable")
    func hashable() {
        let a = ValidityPeriod.days(30)
        let b = ValidityPeriod.days(30)
        #expect(a.hashValue == b.hashValue)
        let set: Set<ValidityPeriod> = [a, b]
        #expect(set.count == 1)
    }
}

// MARK: - WorkoutAllowance Tests

@Suite("WorkoutAllowance")
struct WorkoutAllowanceTests {

    @Test("init(total:) positive becomes .limited")
    func initPositive() {
        let allowance = WorkoutAllowance(total: 10)
        #expect(allowance == .limited(to: 10))
    }

    @Test("init(total: nil) becomes .unlimited")
    func initNil() {
        let allowance = WorkoutAllowance(total: nil)
        #expect(allowance == .unlimited)
    }

    @Test("init(total: 0) becomes .unlimited")
    func initZero() {
        let allowance = WorkoutAllowance(total: 0)
        #expect(allowance == .unlimited)
    }

    @Test("total property")
    func totalProperty() {
        #expect(WorkoutAllowance.limited(to: 5).total == 5)
        #expect(WorkoutAllowance.unlimited.total == nil)
    }

    @Test("Identifiable id — numeric string vs unlimited")
    func identifiable() {
        #expect(WorkoutAllowance.limited(to: 10).id == "10")
        #expect(WorkoutAllowance.unlimited.id == "unlimited")
    }

    @Test("Codable round-trip — limited encodes as Int")
    func codableLimited() throws {
        let allowance = WorkoutAllowance.limited(to: 10)
        let data = try JSONEncoder().encode(allowance)
        let jsonString = String(data: data, encoding: .utf8)!
        #expect(jsonString == "10")
        let decoded = try JSONDecoder().decode(WorkoutAllowance.self, from: data)
        #expect(decoded == allowance)
    }

    @Test("Codable round-trip — unlimited encodes as null")
    func codableUnlimited() throws {
        let allowance = WorkoutAllowance.unlimited
        let data = try JSONEncoder().encode(allowance)
        let jsonString = String(data: data, encoding: .utf8)!
        #expect(jsonString == "null")
        let decoded = try JSONDecoder().decode(WorkoutAllowance.self, from: data)
        #expect(decoded == allowance)
    }

    @Test("Equatable")
    func equatable() {
        #expect(WorkoutAllowance.limited(to: 10) == WorkoutAllowance.limited(to: 10))
        #expect(WorkoutAllowance.limited(to: 10) != WorkoutAllowance.limited(to: 5))
        #expect(WorkoutAllowance.limited(to: 10) != WorkoutAllowance.unlimited)
        #expect(WorkoutAllowance.unlimited == WorkoutAllowance.unlimited)
    }

    @Test("Hashable")
    func hashable() {
        let a = WorkoutAllowance.limited(to: 10)
        let b = WorkoutAllowance.limited(to: 10)
        #expect(a.hashValue == b.hashValue)
        let set: Set<WorkoutAllowance> = [a, b, .unlimited]
        #expect(set.count == 2)
    }
}

// MARK: - WorkoutCapacities Tests

@Suite("WorkoutCapacities")
struct WorkoutCapacitiesTests {

    @Test("Codable round-trip — encodes as a flat { id: Int } map")
    func codableRoundTrip() throws {
        let capacities = WorkoutCapacities(["yoga": 10, "pilates": 12])
        let data = try JSONEncoder().encode(capacities)
        let decoded = try JSONDecoder().decode(WorkoutCapacities.self, from: data)
        #expect(decoded == capacities)

        // The encoded shape must be the flat map, NOT { "storage": {...} }.
        let object = try JSONSerialization.jsonObject(with: data) as? [String: Int]
        #expect(object == ["yoga": 10, "pilates": 12])
    }

    @Test("decodes the existing Firestore shape { \"yoga\": 10 }")
    func decodesFirestoreShape() throws {
        let data = Data("{\"yoga\":10}".utf8)
        let decoded = try JSONDecoder().decode(WorkoutCapacities.self, from: data)
        #expect(decoded.offeredWorkoutIds == ["yoga"])
        #expect(decoded.capacity(forWorkoutId: "yoga") == 10)
    }

    @Test("empty map round-trips to .empty")
    func emptyRoundTrip() throws {
        let data = Data("{}".utf8)
        let decoded = try JSONDecoder().decode(WorkoutCapacities.self, from: data)
        #expect(decoded == .empty)
        #expect(decoded.isEmpty)
        let reEncoded = try JSONEncoder().encode(WorkoutCapacities.empty)
        #expect(String(data: reEncoded, encoding: .utf8) == "{}")
    }

    @Test("offeredWorkoutIds returns the keys")
    func offeredWorkoutIds() {
        let capacities = WorkoutCapacities(["yoga": 10, "pilates": 12])
        #expect(capacities.offeredWorkoutIds == ["yoga", "pilates"])
    }

    @Test("capacity(forWorkoutId:) returns the value or nil")
    func capacityLookup() {
        let capacities = WorkoutCapacities(["yoga": 10])
        #expect(capacities.capacity(forWorkoutId: "yoga") == 10)
        #expect(capacities.capacity(forWorkoutId: "absent") == nil)
    }

    @Test("conducts(workoutId:) and isEmpty")
    func conductsAndEmpty() {
        let capacities = WorkoutCapacities(["pilates": 12])
        #expect(capacities.conducts(workoutId: "pilates"))
        #expect(!capacities.conducts(workoutId: "yoga"))
        #expect(WorkoutCapacities.empty.isEmpty)
    }

    @Test("asDictionary exposes the underlying map for Model/DTO mapping")
    func asDictionary() {
        let capacities = WorkoutCapacities(["yoga": 10, "pilates": 12])
        #expect(capacities.asDictionary == ["yoga": 10, "pilates": 12])
    }

    @Test("Equatable & Hashable")
    func equatableHashable() {
        let a = WorkoutCapacities(["yoga": 10])
        let b = WorkoutCapacities(["yoga": 10])
        #expect(a == b)
        #expect(a.hashValue == b.hashValue)
        let set: Set<WorkoutCapacities> = [a, b, .empty]
        #expect(set.count == 2)
    }
}

// MARK: - LocalizedString Tests

@Suite("LocalizedString")
struct LocalizedStringTests {

    @Test("Init with translations dictionary")
    func initWithTranslations() {
        let ls = LocalizedString(translations: ["en": "Hello", "de": "Hallo"])
        #expect(ls.translations["en"] == "Hello")
        #expect(ls.translations["de"] == "Hallo")
    }

    @Test("empty static property")
    func emptyProperty() {
        let ls = LocalizedString.empty
        #expect(ls.translations.isEmpty)
    }

    @Test("string(in:) with matching lang")
    func stringInMatchingLang() {
        let ls = LocalizedString(translations: ["en": "Hello", "de": "Hallo"])
        #expect(ls.string(in: "en") == "Hello")
        #expect(ls.string(in: "de") == "Hallo")
    }

    @Test("string(in:) with missing lang returns empty")
    func stringInMissingLang() {
        let ls = LocalizedString(translations: ["en": "Hello"])
        #expect(ls.string(in: "fr") == "")
    }

    @Test("string(for: Locale) lookup")
    func stringForLocale() {
        let ls = LocalizedString(translations: ["en": "Hello", "de": "Hallo"])
        let enLocale = Locale(identifier: "en")
        #expect(ls.string(for: enLocale) == "Hello")
    }

    @Test("copyWith adds/overwrites translation")
    func copyWith() {
        let ls = LocalizedString(translations: ["en": "Hello"])
        let updated = ls.copyWith(string: "Hallo", for: Locale(identifier: "de"))
        #expect(updated.translations["de"] == "Hallo")
        #expect(updated.translations["en"] == "Hello")

        let overwritten = ls.copyWith(string: "Hi", for: Locale(identifier: "en"))
        #expect(overwritten.translations["en"] == "Hi")
    }

    @Test("Collection conformance — iteration and count")
    func collectionConformance() {
        let ls = LocalizedString(translations: ["en": "Hello", "de": "Hallo"])
        #expect(ls.count == 2)
        var keys = Set<String>()
        for (key, _) in ls {
            keys.insert(key)
        }
        #expect(keys == Set(["en", "de"]))
    }

    @Test("Codable round-trip encodes as flat dictionary")
    func codableRoundTrip() throws {
        let ls = LocalizedString(translations: ["en": "Hello", "de": "Hallo"])
        let data = try JSONEncoder().encode(ls)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: String]
        #expect(json["en"] == "Hello")
        #expect(json["de"] == "Hallo")
        let decoded = try JSONDecoder().decode(LocalizedString.self, from: data)
        #expect(decoded == ls)
    }

    @Test("Hashable")
    func hashable() {
        let a = LocalizedString(translations: ["en": "Hello"])
        let b = LocalizedString(translations: ["en": "Hello"])
        #expect(a.hashValue == b.hashValue)
        let set: Set<LocalizedString> = [a, b]
        #expect(set.count == 1)
    }
}

// MARK: - Amenity Tests

@Suite("Amenity")
struct AmenityTests {

    @Test("Init with all params, optional description nil")
    func initAllParams() {
        let amenity = Amenity(systemImageName: "wifi", title: "WiFi", description: "Free WiFi")
        #expect(amenity.systemImageName == "wifi")
        #expect(amenity.title == "WiFi")
        #expect(amenity.description == "Free WiFi")

        let noDesc = Amenity(systemImageName: "wifi", title: "WiFi")
        #expect(noDesc.description == nil)
    }

    @Test("Codable round-trip")
    func codableRoundTrip() throws {
        let amenity = Amenity(systemImageName: "wifi", title: "WiFi", description: "Free WiFi")
        let data = try JSONEncoder().encode(amenity)
        let decoded = try JSONDecoder().decode(Amenity.self, from: data)
        #expect(decoded.systemImageName == amenity.systemImageName)
        #expect(decoded.title == amenity.title)
        #expect(decoded.description == amenity.description)
    }
}

// MARK: - Enum Codable Round-Trip Tests

@Suite("BookingStatus")
struct BookingStatusTests {

    @Test("All cases encode to/from raw strings", arguments: [
        (BookingStatus.confirmed, "confirmed"),
        (BookingStatus.cancelled, "cancelled"),
    ])
    func codableRoundTrip(status: BookingStatus, expectedRaw: String) throws {
        #expect(status.rawValue == expectedRaw)
        let data = try JSONEncoder().encode(status)
        let jsonString = String(data: data, encoding: .utf8)!
        #expect(jsonString == "\"\(expectedRaw)\"")
        let decoded = try JSONDecoder().decode(BookingStatus.self, from: data)
        #expect(decoded == status)
    }
}

@Suite("UserRole")
struct UserRoleTests {

    @Test("All cases encode to/from raw strings", arguments: [
        (UserRole.admin, "admin"),
        (UserRole.trainer, "trainer"),
        (UserRole.client, "client"),
    ])
    func codableRoundTrip(role: UserRole, expectedRaw: String) throws {
        #expect(role.rawValue == expectedRaw)
        let data = try JSONEncoder().encode(role)
        let decoded = try JSONDecoder().decode(UserRole.self, from: data)
        #expect(decoded == role)
    }
}

@Suite("AttendanceStatus")
struct AttendanceStatusTests {

    @Test("All cases with snake_case raw values", arguments: [
        (AttendanceStatus.attended, "attended"),
        (AttendanceStatus.noShow, "no_show"),
        (AttendanceStatus.lateCancelled, "late_cancelled"),
    ])
    func codableRoundTrip(status: AttendanceStatus, expectedRaw: String) throws {
        #expect(status.rawValue == expectedRaw)
        let data = try JSONEncoder().encode(status)
        let jsonString = String(data: data, encoding: .utf8)!
        #expect(jsonString == "\"\(expectedRaw)\"")
        let decoded = try JSONDecoder().decode(AttendanceStatus.self, from: data)
        #expect(decoded == status)
    }
}

@Suite("CancellationType")
struct CancellationTypeTests {

    @Test("All cases encode to/from raw strings", arguments: [
        (CancellationType.timely, "timely"),
        (CancellationType.late, "late"),
    ])
    func codableRoundTrip(type: CancellationType, expectedRaw: String) throws {
        #expect(type.rawValue == expectedRaw)
        let data = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(CancellationType.self, from: data)
        #expect(decoded == type)
    }
}

@Suite("NotificationType")
struct NotificationTypeTests {

    @Test("All 7 cases with raw string values", arguments: [
        (NotificationType.bookingConfirmed, "booking_confirmed"),
        (NotificationType.bookingCancelled, "booking_cancelled"),
        (NotificationType.waitlistJoined, "waitlist_joined"),
        (NotificationType.waitlistPromoted, "waitlist_promoted"),
        (NotificationType.sessionCancelled, "session_cancelled"),
        (NotificationType.sessionChanged, "session_changed"),
        (NotificationType.sessionReminder, "session_reminder"),
    ])
    func codableRoundTrip(type: NotificationType, expectedRaw: String) throws {
        #expect(type.rawValue == expectedRaw)
        let data = try JSONEncoder().encode(type)
        let jsonString = String(data: data, encoding: .utf8)!
        #expect(jsonString == "\"\(expectedRaw)\"")
        let decoded = try JSONDecoder().decode(NotificationType.self, from: data)
        #expect(decoded == type)
    }
}

@Suite("SessionStatus")
struct SessionStatusTests {

    @Test("All cases encode to/from raw strings", arguments: [
        (SessionStatus.scheduled, "scheduled"),
        (SessionStatus.ongoing, "ongoing"),
        (SessionStatus.completed, "completed"),
        (SessionStatus.cancelled, "cancelled"),
    ])
    func codableRoundTrip(status: SessionStatus, expectedRaw: String) throws {
        #expect(status.rawValue == expectedRaw)
        let data = try JSONEncoder().encode(status)
        let decoded = try JSONDecoder().decode(SessionStatus.self, from: data)
        #expect(decoded == status)
    }
}
