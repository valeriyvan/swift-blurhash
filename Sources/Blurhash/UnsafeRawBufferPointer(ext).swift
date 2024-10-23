import Foundation

public extension UnsafeRawBufferPointer {

    func blurHash(numberOfComponents components: (Int, Int), width: Int, height: Int, bytesPerRow: Int, bitsPerPixel: Int) -> String {
        factors(
            numberOfComponents: components,
            width: width,
            height: height,
            bytesPerRow: bytesPerRow,
            bitsPerPixel: bitsPerPixel
        )
        .hash(numberOfComponents: components)
    }

    internal func factors(
        numberOfComponents components: (Int, Int),
        width: Int,
        height: Int,
        bytesPerRow: Int,
        bitsPerPixel: Int
    ) -> [RGBFloat] {
        let widthFloat = Float(width)
        let heightFloat = Float(height)
        let pixels = self.baseAddress!.assumingMemoryBound(to: UInt8.self)
        var factors: [RGBFloat] = []
        for y in 0 ..< components.1 {
            let ypi = Float.pi * Float(y)
            for x in 0 ..< components.0 {
                let normalisation: Float = (x == 0 && y == 0) ? 1.0 : 2.0
                let factor = multiplyBasisFunction(
                    pixels: pixels,
                    width: width,
                    height: height,
                    bytesPerRow: bytesPerRow,
                    bytesPerPixel: bitsPerPixel / 8,
                    pixelOffset: 0
                ) {
                    normalisation * cos(Float.pi * Float(x) * $0 / widthFloat) * cos(ypi * $1 / heightFloat)
                }
                factors.append(factor)
            }
        }
        return factors
    }

    // Don't forget deallocate created buffer.
    init?(blurhash: String, width: Int, height: Int, punch: Float = 1) {
        let mutableRawBuffer = UnsafeMutableRawBufferPointer(
            blurhash: blurhash,
            width: width,
            height: height,
            punch: punch
        )
        guard let mutableRawBuffer else { return nil }
        self.init(mutableRawBuffer)
    }

}

private func multiplyBasisFunction(
    pixels: UnsafePointer<UInt8>,
    width: Int,
    height: Int,
    bytesPerRow: Int,
    bytesPerPixel: Int,
    pixelOffset: Int,
    basisFunction: (Float, Float) -> Float
) -> RGBFloat {
    var r: Float = 0
    var g: Float = 0
    var b: Float = 0

    let buffer = UnsafeBufferPointer(start: pixels, count: height * bytesPerRow)

    for x in 0 ..< width {
        for y in 0 ..< height {
            let basis = basisFunction(Float(x), Float(y))
            let index = y * bytesPerRow + bytesPerPixel * x + pixelOffset + 0
            assert(index + 2 < buffer.count)
            r += basis * buffer[index + 0].sRGBToLinear()
            g += basis * buffer[index + 1].sRGBToLinear()
            b += basis * buffer[index + 2].sRGBToLinear()
        }
    }

    let scale = 1.0 / Float(width * height)

    return RGBFloat(r: r * scale, g: g * scale, b: b * scale)
}
