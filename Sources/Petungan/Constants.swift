/// Core constants for the Javanese calendar conversion system.
///
/// Based on Sultan Agung's calendar reform of 1633 CE, which aligned
/// the Javanese calendar (previously solar Saka) with the Islamic lunar calendar.
public enum JavaneseCalendarConstants {
    /// Sultan Agung's calendar reform base year (Javanese).
    public static let baseJawa = 1555
    /// Corresponding Gregorian year for the reform.
    public static let baseGregorian = 1633
    /// Corresponding Hijri year for the reform.
    public static let baseHijri = 1043
    /// Initial year difference between Javanese and Gregorian (1633 - 1555).
    public static let initialDifference = 78
    /// Minimum possible difference (calendars cannot fully converge).
    public static let minDifference = 1
    /// Fixed offset between Javanese and Hijri years (1555 - 1043).
    public static let hijriOffset = 512
    /// Daily drift between solar and lunar years (365.2425 - 354.36667).
    public static let driftPerYear = 10.875833
    /// Mean tropical (Gregorian) year length in days.
    public static let solarYearDays = 365.2425
}

/// Epoch for the civil/tabular Islamic calendar (1 Muharram 1 AH) in JDN.
/// Reference: Calendrical Calculations.
let islamicEpochJDN = 1_948_439
