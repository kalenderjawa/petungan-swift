import XCTest
@testable import Petungan

/// Ground truth data cross-referenced against almnk.com.
/// Each entry records the Javanese year and the Gregorian year
/// in which 1 Sura (Javanese New Year) falls.
private let groundTruth: [(jawa: Int, gregorian: Int, note: String)] = [
    (1555, 1633, "Sultan Agung reform epoch (8 Jul 1633)"),
    (1900, 1968, "1 Suro 1900 = 31 Mar 1968"),
    (1933, 2000, "1 Suro 1933 = 6 Apr 2000"),
    (1946, 2012, "1 Suro 1946 = 15 Nov 2012"),
    (1950, 2016, "1 Suro 1950 = 3 Oct 2016"),
    (1955, 2021, "1 Suro 1955 = 10 Aug 2021"),
    (1956, 2022, "1 Suro 1956 = 30 Jul 2022"),
    (1957, 2023, "1 Suro 1957 = 19 Jul 2023"),
    (1958, 2024, "1 Suro 1958 = 8 Jul 2024"),
    (1959, 2025, "1 Suro 1959 = 27 Jun 2025"),
]

final class ValidationTests: XCTestCase {

    // MARK: - Precise engine vs ground truth

    func testPreciseJawaToMasehi() {
        for entry in groundTruth {
            XCTAssertEqual(
                PreciseEngine.jawaToMasehi(entry.jawa), entry.gregorian,
                "Precise: \(entry.jawa) AJ → \(entry.gregorian) CE (\(entry.note))"
            )
        }
    }

    func testPreciseMasehiToJawa() {
        for entry in groundTruth {
            XCTAssertEqual(
                PreciseEngine.masehiToJawa(entry.gregorian), entry.jawa,
                "Precise reverse: \(entry.gregorian) CE → \(entry.jawa) AJ (\(entry.note))"
            )
        }
    }

    // MARK: - Direct engine vs ground truth (within ±1)

    func testDirectJawaToMasehi() {
        for entry in groundTruth {
            let result = DirectEngine.jawaToMasehi(entry.jawa)
            XCTAssertLessThanOrEqual(
                abs(result - entry.gregorian), 1,
                "Direct: \(entry.jawa) AJ → \(result) CE, expected ~\(entry.gregorian) (\(entry.note))"
            )
        }
    }

    // MARK: - Main wrapper vs ground truth (exact)

    func testMainJawaToMasehi() {
        for entry in groundTruth {
            XCTAssertEqual(
                Petungan.jawaToMasehi(entry.jawa), entry.gregorian,
                "Main: \(entry.jawa) AJ → \(entry.gregorian) CE (\(entry.note))"
            )
        }
    }

    func testMainMasehiToJawa() {
        for entry in groundTruth {
            XCTAssertEqual(
                Petungan.masehiToJawa(entry.gregorian), entry.jawa,
                "Main reverse: \(entry.gregorian) CE → \(entry.jawa) AJ (\(entry.note))"
            )
        }
    }

    // MARK: - Round-trip reversibility

    func testMainRoundTrip() {
        for entry in groundTruth {
            let masehi = Petungan.jawaToMasehi(entry.jawa)
            let back = Petungan.masehiToJawa(masehi)
            XCTAssertEqual(back, entry.jawa, "Round-trip: \(entry.jawa) → \(masehi) → \(back)")
        }
    }

    func testPreciseRoundTrip() {
        for entry in groundTruth {
            let g = PreciseEngine.jawaToMasehi(entry.jawa)
            let back = PreciseEngine.masehiToJawa(g)
            XCTAssertEqual(back, entry.jawa, "Precise round-trip: \(entry.jawa) → \(g) → \(back)")
        }
    }

    // MARK: - Direct vs Precise agreement rate (1555–2100)

    func testDirectVsPreciseAgreementRate() {
        var agree = 0
        var total = 0
        for j in 1555...2100 {
            total += 1
            if DirectEngine.jawaToMasehi(j) == PreciseEngine.jawaToMasehi(j) {
                agree += 1
            }
        }
        let rate = Double(agree) / Double(total) * 100.0
        XCTAssertGreaterThanOrEqual(rate, 95.0, "Agreement rate: \(rate)%")
    }

    func testDirectNeverDiffersMoreThanOne() {
        for j in 1555...2100 {
            let direct = DirectEngine.jawaToMasehi(j)
            let precise = PreciseEngine.jawaToMasehi(j)
            XCTAssertLessThanOrEqual(
                abs(direct - precise), 1,
                "Year \(j): Direct=\(direct), Precise=\(precise)"
            )
        }
    }

    // MARK: - Hijri offset consistency

    func testHijriOffsetConsistency() {
        for entry in groundTruth {
            XCTAssertEqual(Petungan.jawaToHijri(entry.jawa), entry.jawa - 512)
            XCTAssertEqual(Petungan.hijriToJawa(entry.jawa - 512), entry.jawa)
        }
    }
}
