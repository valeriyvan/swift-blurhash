import Foundation

struct Point<N: Numeric & Sendable>: Sendable {
    let x, y: N

    init(x: N, y: N) {
        self.x = x
        self.y = y
    }
}

extension Point<Int> {
    init(_ p: Point<Double>) {
        x = Int(p.x)
        y = Int(p.y)
    }
}

extension Point: Equatable where N: Equatable {}

extension Point: Hashable where N: Hashable {}

extension Point: CustomStringConvertible where N: CustomStringConvertible {
    var description: String {
        "Point(x=\(x), y=\(y))"
    }
}

#if canImport(CoreGraphics)

import struct CoreGraphics.CGPoint

extension CGPoint {

    init(_ point: Point<Double>) {
        self.init(x: point.x, y: point.y)
    }

}

extension Point<Double> {

    init(_ point: CGPoint) {
        self.init(x: point.x, y: point.y)
    }

}

#endif
