import Foundation

public extension UnsafeMutableRawBufferPointer {

    // Don't forget deallocate created buffer.
    init?(blurhash: String, width: Int, height: Int, punch: Float = 1) {
        let blurHashCharacters: [Character] = Array(blurhash)

        guard blurHashCharacters.count >= 6 else { return nil }

        let sizeFlag = String(blurHashCharacters[0]).decode83()
        let numY = (sizeFlag / 9) + 1
        let numX = (sizeFlag % 9) + 1

        let quantisedMaximumValue = String(blurHashCharacters[1]).decode83()
        let maximumValue = Float(quantisedMaximumValue + 1) / 166

        guard blurHashCharacters.count == 4 + 2 * numX * numY else { return nil }

        let colours: [RGBFloat] = (0 ..< numX * numY).map { i in
            guard i > 0 else {
                let value: Int = String(blurHashCharacters[2 ..< 6]).decode83()
                return RGBFloat(decodingDC: value)
            }
            let value: Int = String(blurHashCharacters[4 + i * 2 ..< 4 + i * 2 + 2]).decode83()
            return RGBFloat(decodingAC: value, maximumValue: maximumValue * punch)
        }

        let bytesPerRow = width * 3

        let buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: bytesPerRow * height, alignment: 1)

        for y in 0 ..< height {
            for x in 0 ..< width {
                var r: Float = 0
                var g: Float = 0
                var b: Float = 0

                for j in 0 ..< numY {
                    for i in 0 ..< numX {
                        let basis = cos(Float.pi * Float(x) * Float(i) / Float(width)) *
                        cos(Float.pi * Float(y) * Float(j) / Float(height))
                        let colour = colours[i + j * numX]
                        r += colour.r * basis
                        g += colour.g * basis
                        b += colour.b * basis
                    }
                }

                let offset = x * 3 + y * bytesPerRow
                buffer[offset] = UInt8(r.linearTosRGB())
                buffer[offset + 1] = UInt8(g.linearTosRGB())
                buffer[offset + 2] = UInt8(b.linearTosRGB())
            }
        }

        self = buffer
    }

}
