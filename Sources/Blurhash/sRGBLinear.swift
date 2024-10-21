import Foundation

extension Float {
    // Converts from linear color space to sRGB
    func linearTosRGB() -> Int {
        let v = self.clamped(to: 0...1)
        let transformed: Self
        // 0.0031308 represents the point where the sRGB transfer function transitions from
        // a linear segment to a power function segment when converting from linear to sRGB.
        if v <= 0.0031308 {
            // Apply a linear transformation
            transformed = v * 12.92
        } else {
            // Apply gamma correction
            transformed = 1.055 * pow(v, 1 / 2.4) - 0.055
        }
        // Scale result to 0...255 range and round to the nearest integer
        return  Int(transformed * 255 + 0.5)
    }
}

extension BinaryInteger {
    // Converts from sRGB color space to linear
    func sRGBToLinear() -> Float {
        // Convert self which is supposed to be in 0...255 range to 0.0...1.0 range
        let v = Float(Int64(self)) / 255
        // 0.04045 is the corresponding transition point when converting from sRGB to linear RGB.
        // It's the result of applying the sRGB transfer function to 0.0031308.
        // 0.04045 ≈ 0.0031308 * 12.92
        if v <= 0.04045 {
            // Apply a linear transformation
            return v / 12.92
        } else {
            // Apply gamma correction
            return pow((v + 0.055) / 1.055, 2.4)
        }
    }
}
