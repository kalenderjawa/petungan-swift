# Petungan (Swift)

Konversi tahun antar sistem Kalender Jawa, Masehi (Gregorian), dan Hijriyah.

```
Kalender Jawa (AJ) <--> Kalender Masehi (CE) <--> Kalender Hijriyah (AH)
```

Akurasi 100% (berbasis Julian Day Number), tervalidasi terhadap data [almnk.com](https://almnk.com).

> Swift port dari [@kalenderjawa/petungan](https://github.com/kalenderjawa/petungan) (JavaScript).

## Instalasi

### Swift Package Manager

Tambahkan ke `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/kalenderjawa/petungan-swift.git", from: "2.1.0"),
]
```

Atau di Xcode: **File → Add Package Dependencies** → paste URL repository.

## Penggunaan

```swift
import Petungan

// Jawa → Masehi
Petungan.jawaToMasehi(1555)  // 1633 (reformasi Sultan Agung)
Petungan.jawaToMasehi(1955)  // 2021
Petungan.jawaToMasehi(1958)  // 2024

// Masehi → Jawa
Petungan.masehiToJawa(1633)  // 1555
Petungan.masehiToJawa(2021)  // 1955
Petungan.masehiToJawa(2026)  // 1960

// Jawa → Hijriyah
Petungan.jawaToHijri(1555)   // 1043
Petungan.jawaToHijri(1955)   // 1443

// Hijriyah → Jawa
Petungan.hijriToJawa(1043)   // 1555
Petungan.hijriToJawa(1443)   // 1955
```

### API Alternatif (Akses Engine Langsung)

```swift
// Precise — JDN-based, 100% akurat (default)
Petungan.Precise.jawaToMasehi(1955)  // 2021
Petungan.Precise.masehiToJawa(2021)  // 1955

// Direct — continuous drift formula, ~98% akurat
Petungan.Direct.jawaToMasehi(1955)   // 2021
Petungan.Direct.masehiToJawa(2021)   // 1955
```

### Konstanta

```swift
JavaneseCalendarConstants.baseJawa       // 1555
JavaneseCalendarConstants.baseGregorian  // 1633
JavaneseCalendarConstants.hijriOffset    // 512
```

## Platform

- iOS 13+
- macOS 10.15+
- tvOS 13+
- watchOS 6+

## Testing

```bash
swift test
```

38 tests covering ground truth validation, round-trip reversibility, boundary conditions, and engine agreement rates.

## Lisensi

MIT License
