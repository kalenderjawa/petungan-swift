import XCTest
@testable import Petungan

final class PreciseEngineTests: XCTestCase {

    func testBaseYear() {
        XCTAssertEqual(PreciseEngine.jawaToMasehi(1555), 1633)
    }

    func testModernYears() {
        XCTAssertEqual(PreciseEngine.jawaToMasehi(1955), 2021)
        XCTAssertEqual(PreciseEngine.jawaToMasehi(1958), 2024)
    }

    func testReversibility() {
        let years = [1555, 1600, 1800, 1955, 1958, 2000]
        for jawa in years {
            let g = PreciseEngine.jawaToMasehi(jawa)
            let back = PreciseEngine.masehiToJawa(g)
            XCTAssertEqual(back, jawa, "Reversibility failed for \(jawa)")
        }
    }

    func testMonotonicity() {
        // Gregorian → Javanese mapping should be monotonically non-decreasing
        let years = [2020, 2021, 2022, 2023, 2024, 2025, 2026]
        let mapped = years.map { PreciseEngine.masehiToJawa($0) }
        for i in 1..<mapped.count {
            let diff = mapped[i] - mapped[i - 1]
            XCTAssertGreaterThanOrEqual(diff, 0, "Monotonicity violated at \(years[i])")
            XCTAssertLessThanOrEqual(diff, 1, "Jump too large at \(years[i])")
        }
    }

    func testPreReformYear() {
        // Should compute without crashing
        let result = PreciseEngine.jawaToMasehi(1500)
        XCTAssertTrue(result < 1633)
    }

    func testMasehiToJawaReversibilityBroadRange() {
        var failures = 0
        for g in 1633...2100 {
            let jawa = PreciseEngine.masehiToJawa(g)
            let backToG = PreciseEngine.jawaToMasehi(jawa)
            if backToG != g { failures += 1 }
        }
        // Allow a few failures due to the two-1-Muharram-per-year edge case
        XCTAssertLessThanOrEqual(failures, 5, "Too many reversibility failures: \(failures)")
    }
}
