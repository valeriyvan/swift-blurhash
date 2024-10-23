import Foundation
import Algorithms

/// Helper for working with bitmap data.
/// Pixels are ordered line by line, like arrays in C.
struct Bitmap: Sendable { // swiftlint:disable:this type_body_length

    /// Creates useless empty bitmap.
    init() {
        width = 0
        height = 0
        backing = ContiguousArray<UInt8>()
    }

    /// Creates a new bitmap.
    /// - Parameters:
    ///   - width: The width of the bitmap.
    ///   - height: The height of the bitmap.
    ///   - color: The starting color of the bitmap (RGBA format).
    init(width: Int, height: Int, color: Rgba) {
        assert(width >= 0 && height >= 0)
        self.width = width
        self.height = height
        let pixelCount = width * height
        let capacity =  pixelCount * 4
        backing = ContiguousArray<UInt8>(unsafeUninitializedCapacity: capacity) { buffer, initializedCapacity in
            for index in 0 ..< pixelCount {
                let offset = index * 4
                buffer[offset + 0] = color.r
                buffer[offset + 1] = color.g
                buffer[offset + 2] = color.b
                buffer[offset + 3] = color.a
            }
            initializedCapacity = capacity
        }
    }

    /// Creates a new bitmap from the supplied byte data.
    /// - Parameters:
    ///   - width: The width of the bitmap.
    ///   - height: The height of the bitmap.
    ///   - data: The byte data to fill the bitmap with, must be width * height * depth (4) long.
    ///   - blending: Background color to be blended. If nil, data provided is used as is.
    ///   If not nil,  background is blended into bitmap making it opaque (alpha 255), alpha of background itself is ignored.
    init(width: Int, height: Int, data: ContiguousArray<UInt8>, blending background: Rgba? = nil) {
        assert(width > 0 && height > 0)
        assert(width * height * 4 == data.count)
        self.width = width
        self.height = height
        if let background {
            self.backing = ContiguousArray(unsafeUninitializedCapacity: width * height * 4) {
                buffer, initializedCapacity in // swiftlint:disable:this closure_parameter_position
                for y in 0..<height {
                    for x in 0..<width {
                        let offset = (width * y + x) * 4
                        let rgba = Rgba(data[offset..<offset+4]).blending(background: background)
                        buffer[offset + 0] = rgba.r
                        buffer[offset + 1] = rgba.g
                        buffer[offset + 2] = rgba.b
                        buffer[offset + 3] = rgba.a
                    }
                }
                initializedCapacity = width * height * 4
            }
        } else {
            self.backing = data
        }
    }

    init(width: Int, height: Int, data: Data, blending background: Rgba? = nil) {
        assert(width > 0 && height > 0)
        assert(width * height * 4 == data.count)
        self.width = width
        self.height = height
        if let background {
            self.backing = ContiguousArray(unsafeUninitializedCapacity: width * height * 4) {
                buffer, initializedCapacity in // swiftlint:disable:this closure_parameter_position
                for y in 0..<height {
                    for x in 0..<width {
                        let offset = (width * y + x) * 4
                        let rgba = Rgba(data[offset..<offset+4]).blending(background: background)
                        buffer[offset + 0] = rgba.r
                        buffer[offset + 1] = rgba.g
                        buffer[offset + 2] = rgba.b
                        buffer[offset + 3] = rgba.a
                    }
                }
                initializedCapacity = width * height * 4
            }
        } else {
            self.backing = ContiguousArray<UInt8>(data)
        }
    }

    init(width: Int, height: Int, data: [UInt8], blending background: Rgba? = nil) {
        self = Bitmap(width: width, height: height, data: ContiguousArray(data), blending: background)
    }

    init(width: Int, height: Int, initializer: (_: Int, _: Int) -> Rgba) {
        assert(width > 0 && height > 0)
        self.width = width
        self.height = height
        self.backing = ContiguousArray(unsafeUninitializedCapacity: width * height * 4) {
            buffer, initializedCapacity in // swiftlint:disable:this closure_parameter_position
            for y in 0..<height {
                for x in 0..<width {
                    let rgba = initializer(x, y)
                    let offset = (width * y + x) * 4
                    buffer[offset + 0] = rgba.r
                    buffer[offset + 1] = rgba.g
                    buffer[offset + 2] = rgba.b
                    buffer[offset + 3] = rgba.a
                }
            }
            initializedCapacity = width * height * 4
        }
    }

    /// Width of the bitmap.
    private(set) var width: Int

    @inlinable
    @inline(__always)
    var widthIndices: Range<Int> { 0..<width }

    /// Height of the bitmap.
    private(set) var height: Int

    @inlinable
    @inline(__always)
    var heightIndices: Range<Int> { 0..<height }

    @inlinable
    @inline(__always)
    var pixelCount: Int { width * height }

    @inlinable
    @inline(__always)
    var componentCount: Int { pixelCount * 4 }

    /// Raw bitmap data.
    private(set) var backing: ContiguousArray<UInt8> // C ordering, row by row

    /// Bitmap has no pixels.
    @inlinable
    @inline(__always)
    var isEmpty: Bool { width == 0 || height == 0 }

    @inlinable
    @inline(__always)
    func isInBounds(x: Int, y: Int) -> Bool {
        x >= 0 && x < width && y >= 0 && y < height
    }

    @inlinable
    @inline(__always)
    func isInBounds(_ point: Point<Int>) -> Bool {
        point.x >= 0 && point.x < width && point.y >= 0 && point.y < height
    }

    subscript(x: Int, y: Int) -> Rgba {
        get {
            backing.withUnsafeBufferPointer {
                let offset = offset(x: x, y: y)
                return Rgba($0[offset..<offset + 4])
            }
        }
        set {
            let offset = offset(x: x, y: y)
            backing.withUnsafeMutableBufferPointer {
                $0[offset + 0] = newValue.r
                $0[offset + 1] = newValue.g
                $0[offset + 2] = newValue.b
                $0[offset + 3] = newValue.a
            }

        }
    }

    subscript(_ point: Point<Int>) -> Rgba {
        get {
            self[point.x, point.y]
        }
        set {
            self[point.x, point.y] = newValue
        }
    }

    /// Fills the bitmap with the given color.
    /// - Parameter color: The color to fill the bitmap with.
    mutating func fill(color: Rgba) {
        let count = pixelCount
        backing.withUnsafeMutableBufferPointer {
            for index in 0 ..< count {
                let offset = index * 4
                $0[offset + 0] = color.r
                $0[offset + 1] = color.g
                $0[offset + 2] = color.b
                $0[offset + 3] = color.a
            }
        }
    }

    @inlinable
    @inline(__always)
    internal func offset(x: Int, y: Int) -> Int {
        assert(0..<width ~= x && 0..<height ~= y)
        return (width * y + x) * 4
    }

    mutating func addFrame(width inset: Int, color: Rgba) {
        assert(inset >= 0)
        guard inset > 0 else { return }
        let newWidth = width + inset * 2
        let newHeight = height + inset * 2
        let newCapacity = newWidth * newHeight * 4
        let newBacking = ContiguousArray<UInt8>(unsafeUninitializedCapacity: newCapacity) {
            buffer, initializedCapacity in // swiftlint:disable:this closure_parameter_position
            for y in 0..<newHeight {
                for x in 0..<newWidth {
                    let targetOffset =  (newWidth * y + x) * 4
                    if (inset..<newWidth-inset ~= x) && (inset..<newHeight-inset ~= y) {
                        let sourceOffset = (width * (y - inset) + (x - inset)) * 4
                        for i in 0..<4 {
                            buffer[targetOffset + i] = backing[sourceOffset + i] // TODO: withUnsafeBufferPointer
                        }
                    } else {
                        buffer[targetOffset + 0] = color.r
                        buffer[targetOffset + 1] = color.g
                        buffer[targetOffset + 2] = color.b
                        buffer[targetOffset + 3] = color.a
                    }
                }
            }
            initializedCapacity = newCapacity
        }
        width = newWidth
        height = newHeight
        backing = newBacking
    }

    // Primitive downsample algorithm utilising Bitmap's averageColor function.
    func downsample(factor: Int) -> Bitmap {
        assert(factor > 0)
        guard factor > 1 else { return self }
        let downsampledWidth = width / factor
        let downsampledHeight = height / factor
        let origin = self
        return Bitmap(width: downsampledWidth, height: downsampledHeight) { x, y in
            Bitmap(width: factor, height: factor) { sampleX, sampleY in
                origin[x * factor + sampleX, y * factor + sampleY]
            }
            .averageColor()
        }
    }

    // Transposes Bitmap
    mutating func transpose() {
        self = Bitmap(width: height, height: width) {
            self[$1, $0]
        }
    }

    // Swaps points (x1, y1) and (x2, y2)
    // TODO: optimize
    mutating func swap(x1: Int, y1: Int, x2: Int, y2: Int) {
        let copy = self[x1, y1]
        self[x1, y1] = self[x2, y2]
        self[x2, y2] = copy
    }

    // Reflects bitmap around vertical axis
    // TODO: optimize
    mutating func reflectVertically() {
        for x in 0 ..< width / 2 {
            for y in 0 ..< height {
                swap(x1: x, y1: y, x2: width - x - 1, y2: y)
            }
        }
    }

    // Reflects bitmap around horizontal axis
    // TODO: optimize
    mutating func reflectHorizontally() {
        for x in 0 ..< width {
            for y in 0 ..< height / 2 {
                swap(x1: x, y1: y, x2: x, y2: height - y - 1)
            }
        }
    }

    // TODO: is it possible to do in place?
    private mutating func reflectDown() {
        self = Bitmap(width: width, height: height) {
            self[width - $0 - 1, height - $1 - 1]
        }
    }

    private mutating func reflectLeftMirrored() {
        self = Bitmap(width: height, height: width) {
            self[$1, $0]
        }
    }

    private mutating func reflectLeft() {
        self = Bitmap(width: height, height: width) {
            self[$1, height - $0 - 1]
        }
    }

    private mutating func reflectRightMirrored() {
        self = Bitmap(width: height, height: width) {
            self[width - $1 - 1, height - $0 - 1]
        }
    }

    private mutating func reflectRight() {
        self = Bitmap(width: height, height: width) {
            self[width - $1 - 1, $0]
        }
    }

    // https://home.jeita.or.jp/tsc/std-pdf/CP3451C.pdf, page 30
    enum ExifOrientation: Int {
        // 1 The Oth row is at the visual top of the image, and the 0th column is the visual left-hand side.
        case up = 1
        // 2 The Oth row is at the visual top of the image, and the Oth column is the visual right-hand side.
        case upMirrored = 2
        // 3 The Oth row is at the visual bottom of the image, and the Oth column is the visual right-hand side.
        case down = 3
        // 4 The Oth row is at the visual bottom of the image, and the 0th column is the visual left-hand side.
        case downMirrored = 4
        // 5 The Oth row is the visual left-hand side of the image, and the 0th column is the visual top.
        case leftMirrored = 5
        // 6 The Oth row is the visual right-hand side of the image, and the 0th column is the visual top.
        case left = 6
        // 7 The Oth row is the visual right-hand side of the image, and the 0th column is the visual bottom.
        case rightMirrored = 7
        // 8 The Oth row is the visual left-hand side of the image, and the 0th column is the visual bottom.
        case right = 8
    }

    mutating func rotateToUpOrientation(accordingTo orientation: ExifOrientation) {
        switch orientation {
        case .up:
            ()
        case .upMirrored:
            reflectVertically()
        case .down:
            reflectDown()
        case .downMirrored:
            reflectHorizontally()
        case .leftMirrored:
            reflectLeftMirrored()
        case .left:
            reflectLeft()
        case .rightMirrored:
            reflectRightMirrored()
        case .right:
            reflectRight()
        }
    }
}

extension Bitmap: Equatable {
    static func == (lhs: Bitmap, rhs: Bitmap) -> Bool {
        lhs.width == rhs.width && lhs.height == rhs.height && lhs.backing == rhs.backing
    }
}

extension Bitmap {

    /// Computes the average RGB color of the pixels in the bitmap.
    /// - Returns: The average RGB color of the image, RGBA8888 format. Alpha is set to opaque (255).
    func averageColor() -> Rgba {
        // TODO: carefully check implementation for overflows.
        // TODO: make it internal
        guard !isEmpty else { return .black }

        var totalRed: Int = 0
        var totalGreen: Int = 0
        var totalBlue: Int = 0
        backing.withUnsafeBufferPointer {
            for i in stride(from: 0, to: $0.count, by: 4) {
                totalRed += Int($0[i])
                totalGreen += Int($0[i + 1])
                totalBlue += Int($0[i + 2])
            }
        }

        let pixelCount = self.pixelCount
        return Rgba(
            r: UInt8(totalRed / pixelCount),
            g: UInt8(totalGreen / pixelCount),
            b: UInt8(totalBlue / pixelCount),
            a: 255
        )
    }

    // Returns opaque (alpha 255) image with blended background.
    // Alpha of background itself is ignored.
    func blending(background: Rgba) -> Bitmap {
        Bitmap(width: width, height: height) { x, y in
            self[x, y].blending(background: background)
        }
    }

}

extension Bitmap {

    enum ParsePpmError: Error {
        case noP3
        case inconsistentHeader(String)
        case maxElementNot255(String)
        case wrongElement(String)
        case excessiveCharacters(String)
    }

    // Format is described in https://en.wikipedia.org/wiki/Netpbm and https://netpbm.sourceforge.net/doc/ppm.html
    init(ppmString string: String) throws {
        var stringWithTrimmedComments = ""
        string.enumerateLines { line, _ in
            let endIndex = line.firstIndex(of: "#") ?? line.endIndex
            stringWithTrimmedComments.append(line[..<endIndex].trimmingCharacters(in: .whitespacesAndNewlines))
            stringWithTrimmedComments.append(" ")
        }
        let scanner = Scanner(string: stringWithTrimmedComments)
        scanner.charactersToBeSkipped = .whitespacesAndNewlines
        guard scanner.scanString("P3") != nil else {
            throw ParsePpmError.noP3
        }
        guard let width = scanner.scanInt(), width > 0, let height = scanner.scanInt(), height > 0 else {
            throw ParsePpmError.inconsistentHeader(String(string[..<scanner.currentIndex]))
        }
        guard let maxValue = scanner.scanInt(), maxValue == 255
        else {
            throw ParsePpmError.maxElementNot255(String(string[..<scanner.currentIndex]))
        }
        self.width = width
        self.height = height
        let capacity = width * height * 4
        self.backing = try ContiguousArray<UInt8>(unsafeUninitializedCapacity: capacity) { buffer, initializedCount in
            var counter: Int = 0
            repeat {
                let startIndex = scanner.currentIndex
                guard
                    let red = scanner.scanInt(), 0...255 ~= red,
                    let green = scanner.scanInt(), 0...255 ~= green,
                    let blue = scanner.scanInt(), 0...255 ~= blue
                else {
                    let context = String(string[startIndex..<scanner.currentIndex])
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    throw ParsePpmError.wrongElement(context)
                }
                buffer[counter] = UInt8(red)
                counter += 1
                buffer[counter] = UInt8(green)
                counter += 1
                buffer[counter] = UInt8(blue)
                counter += 1
                buffer[counter] = 255
                counter += 1
            } while counter < capacity

            let startIndex = scanner.currentIndex
            guard scanner.isAtEnd else {
                let context = String(string[startIndex...]).trimmingCharacters(in: .whitespacesAndNewlines)
                throw ParsePpmError.excessiveCharacters(context)
            }
            initializedCount = capacity
        }
    }

    func ppmString(background: Rgba = .white) -> String {
        """
        P3
        \(width) \(height)
        255

        """
        +
        backing
            // .lazy ???
            .chunks(ofCount: 4)
            .map { Rgba($0).blending(background: background).asArray.dropLast() }
            .compactMap { $0.map(String.init).joined(separator: " ") + "\n" }
            .joined()
    }

    var ppmString: String { ppmString() }
}

extension Bitmap {

    // swiftlint:disable:next cyclomatic_complexity
    func compare(with other: Bitmap, precision: Double) -> Bool {
        guard width != 0 else { return false }
        guard other.width != 0 else { return false }
        guard width == other.width else { return false }
        guard height != 0 else { return false }
        guard other.height != 0 else { return false }
        guard height == other.height else { return false }
        var differentPixelCount = 0
        let threshold = 1 - precision
        let componentCount = Double(componentCount)
        for y in heightIndices {
            for x in widthIndices {
                if self[x, y] != other[x, y] {
                    if precision >= 0 { return false }
                    differentPixelCount += 1
                }
                if Double(differentPixelCount) / Double(componentCount) > threshold { return false }
            }
        }
        return true
    }

}

// swiftlint:disable:this file_length
