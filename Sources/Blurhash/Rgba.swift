import Foundation

 /// Helper for manipulating RGBA8888 color data.
struct Rgba {

    var r: UInt8 // The red component (0-255).
    var g: UInt8 // The green component (0-255).
    var b: UInt8 // The blue component (0-255).
    var a: UInt8 // The alpha component (0-255).

    init(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

    init(_ tuple: (r: UInt8, g: UInt8, b: UInt8, a: UInt8)) {
        self.r = tuple.r
        self.g = tuple.g
        self.b = tuple.b
        self.a = tuple.a
    }

    init(_ array: [UInt8]) {
        assert(array.count == 4)
        self.r = array[0]
        self.g = array[1]
        self.b = array[2]
        self.a = array[3]
    }

    init(_ array: ContiguousArray<UInt8>) {
        assert(array.count == 4)
        self.r = array[0]
        self.g = array[1]
        self.b = array[2]
        self.a = array[3]
    }

    init(_ slice: ArraySlice<UInt8>) {
        assert(slice.count == 4)
        self.r = slice[slice.startIndex]
        self.g = slice[slice.startIndex + 1]
        self.b = slice[slice.startIndex + 2]
        self.a = slice[slice.startIndex + 3]
    }

    init(_ data: Data) {
        assert(data.count == 4)
        self.r = data[data.startIndex]
        self.g = data[data.startIndex + 1]
        self.b = data[data.startIndex + 2]
        self.a = data[data.startIndex + 3]
    }

    init(_ slice: Slice<Data>) {
        assert(slice.count == 4)
        self.r = slice[slice.startIndex]
        self.g = slice[slice.startIndex + 1]
        self.b = slice[slice.startIndex + 2]
        self.a = slice[slice.startIndex + 3]
    }

    init(_ buffer: UnsafeBufferPointer<UInt8>) {
        assert(buffer.count == 4)
        self.r = buffer[0]
        self.g = buffer[1]
        self.b = buffer[2]
        self.a = buffer[3]
    }

    init(_ slice: Slice<UnsafeBufferPointer<UInt8>>) {
        assert(slice.count == 4)
        self.r = slice[slice.startIndex]
        self.g = slice[slice.startIndex + 1]
        self.b = slice[slice.startIndex + 2]
        self.a = slice[slice.startIndex + 3]
    }

    func withAlphaComponent(_ alpha: UInt8) -> Rgba {
        Rgba(r: r, g: g, b: b, a: alpha)
    }

    static var black: Rgba { Rgba(r: 0, g: 0, b: 0, a: 255) }
    static var white: Rgba { Rgba(r: 255, g: 255, b: 255, a: 255) }
    static var red: Rgba { Rgba(r: 255, g: 0, b: 0, a: 255) }
    static var green: Rgba { Rgba(r: 0, g: 255, b: 0, a: 255) }
    static var blue: Rgba { Rgba(r: 0, g: 0, b: 255, a: 255) }
    static var yellow: Rgba { Rgba(r: 255, g: 255, b: 0, a: 255) }
    static var magenta: Rgba { Rgba(r: 255, g: 0, b: 255, a: 255) }
    static var cyan: Rgba { Rgba(r: 0, g: 255, b: 255, a: 255) }

    // Returns opaque (alpha 255) color with blended background.
    // Alpha of background itself is ignored.
    func blending(background: Rgba) -> Rgba {
        // https://stackoverflow.com/a/746937/942513
        let alpha: Double = Double(a) / 255.0
        let oneMinusAlpha: Double = 1.0 - alpha
        return Rgba(
            r: UInt8(Double(r) * alpha + oneMinusAlpha * Double(background.r)),
            g: UInt8(Double(g) * alpha + oneMinusAlpha * Double(background.g)),
            b: UInt8(Double(b) * alpha + oneMinusAlpha * Double(background.b)),
            a: 255
        )
    }

    var asArray: [UInt8] { [r, g, b, a] }

    var asTuple: (UInt8, UInt8, UInt8, UInt8) { (r, g, b, a) }

}

extension Rgba: Equatable {}
