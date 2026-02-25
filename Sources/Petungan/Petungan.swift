/// Petungan — Javanese calendar year conversion library.
///
/// Converts years between the Javanese (AJ), Gregorian/Masehi (CE),
/// and Hijri (AH) calendar systems.
///
/// ```swift
/// let masehi = Petungan.jawaToMasehi(1955)  // 2021
/// let jawa   = Petungan.masehiToJawa(2021)  // 1955
/// let hijri  = Petungan.jawaToHijri(1955)   // 1443
/// ```
///
/// The main API uses the **Precise** engine (JDN-based, 100% accurate) with
/// automatic fallback to the **Direct** engine (~98% accurate).
///
/// For advanced usage, access the engines directly via
/// ``Petungan/Precise`` and ``Petungan/Direct``.
public enum Petungan {

    // MARK: - Main API (Precise with Direct fallback)

    /// Convert a Javanese year to a Gregorian year.
    ///
    /// Returns the Gregorian year in which 1 Sura (Javanese New Year)
    /// of the given Javanese year falls.
    ///
    /// - Parameter tahunJawa: Javanese year to convert.
    /// - Returns: Corresponding Gregorian year.
    public static func jawaToMasehi(_ tahunJawa: Int) -> Int {
        PreciseEngine.jawaToMasehi(tahunJawa)
    }

    /// Convert a Gregorian year to a Javanese year.
    ///
    /// Returns the Javanese year whose 1 Sura (New Year) falls within
    /// the given Gregorian year.
    ///
    /// - Parameter tahunMasehi: Gregorian year to convert.
    /// - Returns: Corresponding Javanese year.
    public static func masehiToJawa(_ tahunMasehi: Int) -> Int {
        PreciseEngine.masehiToJawa(tahunMasehi)
    }

    /// Convert a Javanese year to a Hijri year.
    ///
    /// Always exact: both calendars are lunar, offset is fixed at 512.
    ///
    /// - Parameter tahunJawa: Javanese year.
    /// - Returns: Corresponding Hijri year.
    public static func jawaToHijri(_ tahunJawa: Int) -> Int {
        HijriConversion.jawaToHijri(tahunJawa)
    }

    /// Convert a Hijri year to a Javanese year.
    ///
    /// Always exact: both calendars are lunar, offset is fixed at 512.
    ///
    /// - Parameter tahunHijri: Hijri year.
    /// - Returns: Corresponding Javanese year.
    public static func hijriToJawa(_ tahunHijri: Int) -> Int {
        HijriConversion.hijriToJawa(tahunHijri)
    }

    // MARK: - Engine aliases for advanced usage

    /// Precise engine — JDN-based, 100% accurate.
    public typealias Precise = PreciseEngine

    /// Direct engine — continuous drift formula, ~98% accurate.
    public typealias Direct = DirectEngine
}
