import func Foundation.floor

struct RGBFloat {
    let r, g, b: Float

    init(r: Float, g: Float, b: Float) {
        self.r = r
        self.g = g
        self.b = b
    }

    // DC stands for direct current coefficient
    func encodeDC() -> Int {
        let roundedR = r.linearTosRGB()
        let roundedG = g.linearTosRGB()
        let roundedB = b.linearTosRGB()
        return (roundedR << 16) + (roundedG << 8) + roundedB
    }

    init(decodingDC value: Int) {
        r = (value >> 16).sRGBToLinear()
        g = ((value >> 8) & 255).sRGBToLinear()
        b = (value & 255).sRGBToLinear()
    }

    // AC stands for alternating current or AC coefficient
    func encodeAC(maximumValue: Float) -> Int {
        let quantR = Int(max(0, min(18, floor(signPow(r / maximumValue, 0.5) * 9 + 9.5))))
        let quantG = Int(max(0, min(18, floor(signPow(g / maximumValue, 0.5) * 9 + 9.5))))
        let quantB = Int(max(0, min(18, floor(signPow(b / maximumValue, 0.5) * 9 + 9.5))))
        return quantR * 19 * 19 + quantG * 19 + quantB
    }

    // Decodes the AC (Alternating Current) components, which represent the higher frequency details of the image.
    init(decodingAC value: Int, maximumValue: Float) {
        let quantR = value / (19 * 19)
        let quantG = (value / 19) % 19
        let quantB = value % 19
        r = signPow((Float(quantR) - 9) / 9, 2) * maximumValue
        g = signPow((Float(quantG) - 9) / 9, 2) * maximumValue
        b = signPow((Float(quantB) - 9) / 9, 2) * maximumValue
    }

}

extension [RGBFloat] {
    func hash(numberOfComponents components: (Int, Int)) -> String {
        let factors = self // FIX: !!!
        let dc = factors.first!
        let ac = factors.dropFirst()

        var hash = ""

        let sizeFlag = (components.0 - 1) + (components.1 - 1) * 9
        hash += sizeFlag.encode83(length: 1)

        let maximumValue: Float
        if ac.count > 0 {
            let actualMaximumValue = ac.map({ Swift.max(abs($0.r), abs($0.g), abs($0.b)) }).max()!
            let quantisedMaximumValue = Int(Swift.max(0, Swift.min(82, floor(actualMaximumValue * 166 - 0.5))))
            maximumValue = Float(quantisedMaximumValue + 1) / 166
            hash += quantisedMaximumValue.encode83(length: 1)
        } else {
            maximumValue = 1
            hash += 0.encode83(length: 1)
        }

        hash += dc.encodeDC().encode83(length: 4)

        for factor in ac {
            hash += factor.encodeAC(maximumValue: maximumValue).encode83(length: 2)
        }

        return hash
    }

}
