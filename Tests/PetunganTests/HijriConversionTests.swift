import XCTest
@testable import Petungan

final class HijriConversionTests: XCTestCase {

    func testBaseConversion() {
        XCTAssertEqual(Petungan.jawaToHijri(1555), 1043)
        XCTAssertEqual(Petungan.hijriToJawa(1043), 1555)
    }

    func testModernConversion() {
        XCTAssertEqual(Petungan.jawaToHijri(1955), 1443)
        XCTAssertEqual(Petungan.hijriToJawa(1443), 1955)
    }

    func testOffsetIsAlways512() {
        let testYears = [1000, 1555, 1600, 1900, 1955, 2000, 2100]
        for jawa in testYears {
            XCTAssertEqual(Petungan.jawaToHijri(jawa), jawa - 512)
            XCTAssertEqual(Petungan.hijriToJawa(jawa - 512), jawa)
        }
    }

    func testPerfectReversibility() {
        for jawa in 1000...2500 {
            let hijri = Petungan.jawaToHijri(jawa)
            let back = Petungan.hijriToJawa(hijri)
            XCTAssertEqual(back, jawa)
        }
    }

    func testPreCorrelationYears() {
        // Before 1555 AJ / 1043 AH — should still compute
        XCTAssertEqual(Petungan.jawaToHijri(1000), 488)
        XCTAssertEqual(Petungan.hijriToJawa(500), 1012)
    }
}
