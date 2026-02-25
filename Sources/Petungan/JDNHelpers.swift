import Foundation

/// Julian Day Number helpers for Gregorian and civil Islamic calendar conversions.
/// Algorithms from Calendrical Calculations (Reingold & Dershowitz).

// MARK: - Gregorian <-> JDN

/// Convert a Gregorian date to Julian Day Number.
func gregorianToJDN(year: Int, month: Int, day: Int) -> Int {
    let a = (14 - month) / 12
    let y = year + 4800 - a
    let m = month + 12 * a - 3
    return day
        + (153 * m + 2) / 5
        + 365 * y
        + y / 4
        - y / 100
        + y / 400
        - 32045
}

/// Convert a Julian Day Number to a Gregorian date.
func jdnToGregorian(_ jdn: Int) -> (year: Int, month: Int, day: Int) {
    let a = jdn + 32044
    let b = (4 * a + 3) / 146097
    let c = a - (146097 * b) / 4
    let d = (4 * c + 3) / 1461
    let e = c - (1461 * d) / 4
    let m = (5 * e + 2) / 153
    let day = e - (153 * m + 2) / 5 + 1
    let month = m + 3 - 12 * (m / 10)
    let year = b * 100 + d - 4800 + m / 10
    return (year, month, day)
}

// MARK: - Civil Islamic (tabular) <-> JDN

/// Convert a civil Islamic date to Julian Day Number.
func islamicToJDN(year: Int, month: Int, day: Int) -> Int {
    return day
        + Int(ceil(29.5 * Double(month - 1)))
        + (year - 1) * 354
        + (3 + 11 * year) / 30
        + islamicEpochJDN
        - 1
}

/// Convert a Julian Day Number to a civil Islamic date.
func jdnToIslamic(_ jdn: Int) -> (year: Int, month: Int, day: Int) {
    let daysSinceEpoch = jdn - islamicEpochJDN + 1
    let year = (30 * daysSinceEpoch + 10646) / 10631
    let firstOfYear = islamicToJDN(year: year, month: 1, day: 1)
    let month = min(12, Int(ceil(Double(jdn - firstOfYear + 1) / 29.5)))
    let firstOfMonth = islamicToJDN(year: year, month: month, day: 1)
    let day = jdn - firstOfMonth + 1
    return (year, month, day)
}
