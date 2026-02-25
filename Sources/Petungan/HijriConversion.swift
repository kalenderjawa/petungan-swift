/// Javanese ↔ Hijri year conversion.
///
/// Both calendars are lunar-based, so the offset is a fixed constant (512 years).
/// 100% reversible for all years.
enum HijriConversion {

    /// Convert a Javanese year to a Hijri year.
    ///
    /// - Parameter tahunJawa: Javanese year.
    /// - Returns: Corresponding Hijri year (`tahunJawa - 512`).
    static func jawaToHijri(_ tahunJawa: Int) -> Int {
        tahunJawa - JavaneseCalendarConstants.hijriOffset
    }

    /// Convert a Hijri year to a Javanese year.
    ///
    /// - Parameter tahunHijri: Hijri year.
    /// - Returns: Corresponding Javanese year (`tahunHijri + 512`).
    static func hijriToJawa(_ tahunHijri: Int) -> Int {
        tahunHijri + JavaneseCalendarConstants.hijriOffset
    }
}
