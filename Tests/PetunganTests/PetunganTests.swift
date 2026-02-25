import XCTest
@testable import Petungan

final class PetunganTests: XCTestCase {

    // MARK: - Jawa → Masehi

    func testBaseYearConversion() {
        XCTAssertEqual(Petungan.jawaToMasehi(1555), 1633)
    }

    func testModernYearConversion() {
        XCTAssertEqual(Petungan.jawaToMasehi(1955), 2021)
        XCTAssertEqual(Petungan.jawaToMasehi(1958), 2024)
    }

    // MARK: - Masehi → Jawa

    func testBaseYearReverse() {
        XCTAssertEqual(Petungan.masehiToJawa(1633), 1555)
    }

    func testModernYearReverse() {
        XCTAssertEqual(Petungan.masehiToJawa(2021), 1955)
        XCTAssertEqual(Petungan.masehiToJawa(2024), 1958)
    }

    // MARK: - Hijri

    func testJawaToHijri() {
        XCTAssertEqual(Petungan.jawaToHijri(1555), 1043)
        XCTAssertEqual(Petungan.jawaToHijri(1955), 1443)
    }

    func testHijriToJawa() {
        XCTAssertEqual(Petungan.hijriToJawa(1043), 1555)
        XCTAssertEqual(Petungan.hijriToJawa(1443), 1955)
    }

    // MARK: - Consistency: main should equal Precise

    func testMainEqualsPrecise() {
        let testYears = [1555, 1600, 1700, 1800, 1900, 1955]
        for year in testYears {
            XCTAssertEqual(
                Petungan.jawaToMasehi(year),
                PreciseEngine.jawaToMasehi(year),
                "Main should equal Precise for \(year)"
            )
        }
    }

    // MARK: - Historical years (before reform)

    func testPreReformYears() {
        // Should still compute (no crash)
        let result = Petungan.jawaToMasehi(1000)
        XCTAssertTrue(result < 1633, "Pre-reform year should map before 1633 CE")
    }

    // MARK: - Extreme years

    func testExtremeYears() {
        // Very old and very future years should not crash
        let _ = Petungan.jawaToMasehi(500)
        let _ = Petungan.jawaToMasehi(3000)
        let _ = Petungan.masehiToJawa(1000)
        let _ = Petungan.masehiToJawa(3000)
    }

    // MARK: - Reference points

    func testKnownReferencePoints() {
        let references: [(jawa: Int, gregorian: Int)] = [
            (1555, 1633),
            (1933, 2000),
        ]
        for ref in references {
            let g = Petungan.jawaToMasehi(ref.jawa)
            let j = Petungan.masehiToJawa(ref.gregorian)
            XCTAssertEqual(g, ref.gregorian, "jawaToMasehi(\(ref.jawa))")
            XCTAssertEqual(j, ref.jawa, "masehiToJawa(\(ref.gregorian))")
        }
    }
}
