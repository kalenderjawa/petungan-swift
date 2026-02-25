import XCTest
@testable import Petungan

final class DirectEngineTests: XCTestCase {

    func testBaseYear() {
        XCTAssertEqual(DirectEngine.jawaToMasehi(1555), 1633)
    }

    func testModernYear() {
        XCTAssertEqual(DirectEngine.jawaToMasehi(1955), 2021)
    }

    func testBaseYearReverse() {
        XCTAssertEqual(DirectEngine.masehiToJawa(1633), 1555)
    }

    func testReversibility() {
        let years = [1555, 1589, 1623, 1657, 1691, 1725, 1955, 2000]
        for jawa in years {
            let g = DirectEngine.jawaToMasehi(jawa)
            let back = DirectEngine.masehiToJawa(g)
            XCTAssertLessThanOrEqual(
                abs(back - jawa), 1,
                "Direct reversibility for \(jawa): got \(back)"
            )
        }
    }

    func testBoundaryYears() {
        let boundaryYears = [1588, 1589, 1622, 1623, 1656, 1657]
        for year in boundaryYears {
            let result = DirectEngine.jawaToMasehi(year)
            XCTAssertTrue(result > year, "Boundary year \(year) should map to a larger Gregorian year")
        }
    }

    func testPreReformYears() {
        // Years before 1555 should still work (difference increases)
        let result = DirectEngine.jawaToMasehi(1000)
        XCTAssertTrue(result > 1000 + JavaneseCalendarConstants.initialDifference)
    }

    func testExtremeYears() {
        // Should not crash
        let _ = DirectEngine.jawaToMasehi(500)
        let _ = DirectEngine.jawaToMasehi(3000)
        let _ = DirectEngine.masehiToJawa(1000)
        let _ = DirectEngine.masehiToJawa(3000)
    }
}
