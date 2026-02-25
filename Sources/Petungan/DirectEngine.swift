import Foundation

/// Direct conversion engine using the continuous drift formula.
///
/// ~98% accurate (536/546 years agree with Precise for 1555–2100 AJ).
/// Faster than Precise but may be off by 1 year for ~1.8% of edge cases
/// where 1 Sura falls in very early January.
public enum DirectEngine {

    /// Convert a Javanese year to a Gregorian year using the continuous drift formula.
    ///
    /// Formula:
    /// ```
    /// drift = |jawaYear - 1555| * 10.875833
    /// decrement = round(drift / 365.2425)
    /// difference = max(78 - decrement, 1)   // if jawaYear >= 1555
    /// difference = 78 + decrement            // if jawaYear < 1555
    /// gregorianYear = jawaYear + difference
    /// ```
    ///
    /// - Parameter jawaYear: Javanese year to convert.
    /// - Returns: Approximate Gregorian year.
    public static func jawaToMasehi(_ jawaYear: Int) -> Int {
        let baseJawa = JavaneseCalendarConstants.baseJawa
        let initialDiff = JavaneseCalendarConstants.initialDifference
        let minDiff = JavaneseCalendarConstants.minDifference
        let driftPerYear = JavaneseCalendarConstants.driftPerYear
        let solarYearDays = JavaneseCalendarConstants.solarYearDays

        let yearsFromBase = jawaYear - baseJawa
        let totalDrift = Double(abs(yearsFromBase)) * driftPerYear
        let differenceDecrement = Int((totalDrift / solarYearDays).rounded())

        let difference: Int
        if yearsFromBase >= 0 {
            difference = initialDiff - differenceDecrement
        } else {
            difference = initialDiff + differenceDecrement
        }

        return jawaYear + max(difference, minDiff)
    }

    /// Convert a Gregorian year to a Javanese year using iterative inversion
    /// of the continuous drift formula.
    ///
    /// - Parameter gregorianYear: Gregorian year to convert.
    /// - Returns: Approximate Javanese year.
    public static func masehiToJawa(_ gregorianYear: Int) -> Int {
        if gregorianYear == JavaneseCalendarConstants.baseGregorian {
            return JavaneseCalendarConstants.baseJawa
        }

        var estimated = gregorianYear - JavaneseCalendarConstants.initialDifference
        let maxIterations = 10

        for _ in 0..<maxIterations {
            let calculated = jawaToMasehi(estimated)
            let error = calculated - gregorianYear
            if error == 0 { return estimated }
            estimated -= error
        }

        return estimated
    }
}
