import Foundation

public extension Data {

    func blurHash(
        numberOfComponents components: (Int, Int),
        width: Int,
        height: Int,
        bytesPerRow: Int,
        bitsPerPixel: Int
    ) -> String {
        self.withUnsafeBytes { buffer in
            buffer.blurHash(
                numberOfComponents: components,
                width: width,
                height: height,
                bytesPerRow: bytesPerRow,
                bitsPerPixel: bitsPerPixel
            )
        }
    }

    init?(blurhash blurHash: String, width: Int, height: Int, punch: Float = 1) {
        let blurHashCharacters: [Character] = Array(blurHash)

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
        guard let data = CFDataCreateMutable(kCFAllocatorDefault, bytesPerRow * height) else { return nil }
        CFDataSetLength(data, bytesPerRow * height)
        guard let pixels = CFDataGetMutableBytePtr(data) else { return nil }

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
                pixels[offset] = UInt8(r.linearTosRGB())
                pixels[offset + 1] = UInt8(g.linearTosRGB())
                pixels[offset + 2] = UInt8(b.linearTosRGB())
            }
        }

        self = data as Data
    }

}
