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

    init?(blurhash: String, width: Int, height: Int, punch: Float = 1) {
        let rawBuffer = UnsafeMutableRawBufferPointer(
            blurhash: blurhash,
            width: width,
            height: height,
            punch: punch
        )
        guard let rawBuffer, let baseAddress = rawBuffer.baseAddress else { return nil }
        self.init(
            bytesNoCopy: baseAddress,
            count: rawBuffer.count,
            deallocator: .custom({ buffer, _ in buffer.deallocate() })
        )
    }

}
