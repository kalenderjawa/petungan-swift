/// Precise conversion engine using Julian Day Number via the civil Islamic calendar.
///
/// 100% accurate for years 1555–2100 AJ (validated against almnk.com).
/// Algorithm: Jawa → Hijri (offset 512) → JDN (1 Muharram) → Gregorian.
public enum PreciseEngine {

    /// Convert a Javanese year to the Gregorian year in which 1 Sura falls.
    ///
    /// - Parameter jawaYear: Javanese year to convert.
    /// - Returns: Gregorian year containing 1 Sura of that Javanese year.
    public static func jawaToMasehi(_ jawaYear: Int) -> Int {
        let hijriYear = jawaYear - JavaneseCalendarConstants.hijriOffset
        let newYearJDN = islamicToJDN(year: hijriYear, month: 1, day: 1)
        let gDate = jdnToGregorian(newYearJDN)
        return gDate.year
    }

    /// Convert a Gregorian year to the Javanese year whose 1 Sura falls within it.
    ///
    /// When two Javanese new years fall in the same Gregorian year, the later
    /// (larger) Javanese year is returned.
    ///
    /// - Parameter gregorianYear: Gregorian year to convert.
    /// - Returns: Javanese year whose 1 Sura falls in the given Gregorian year.
    public static func masehiToJawa(_ gregorianYear: Int) -> Int {
        let jan1JDN = gregorianToJDN(year: gregorianYear, month: 1, day: 1)
        let dec31JDN = gregorianToJDN(year: gregorianYear, month: 12, day: 31)
        let islamicAtJan1 = jdnToIslamic(jan1JDN).year

        // Find the largest Hijri year whose 1 Muharram falls within the Gregorian year.
        var bestMatch: Int? = nil
        for delta in -2...2 {
            let y = islamicAtJan1 + delta
            let startJDN = islamicToJDN(year: y, month: 1, day: 1)
            if startJDN >= jan1JDN && startJDN <= dec31JDN {
                if bestMatch == nil || y > bestMatch! {
                    bestMatch = y
                }
            }
        }
        if let match = bestMatch {
            return match + JavaneseCalendarConstants.hijriOffset
        }

        // Fallback: closest Hijri new year to the year window.
        var bestY = islamicAtJan1
        var bestDist = Int.max
        for y in (islamicAtJan1 - 3)...(islamicAtJan1 + 3) {
            let startJDN = islamicToJDN(year: y, month: 1, day: 1)
            let dist: Int
            if startJDN >= jan1JDN && startJDN <= dec31JDN {
                dist = 0
            } else {
                dist = min(abs(startJDN - jan1JDN), abs(startJDN - dec31JDN))
            }
            if dist < bestDist || (dist == bestDist && y > bestY) {
                bestDist = dist
                bestY = y
            }
        }
        return bestY + JavaneseCalendarConstants.hijriOffset
    }
}
