#if canImport(UIKit)

import UIKit

extension UIImage {

    public func blurHash(numberOfComponents components: (Int, Int)) -> String? {
        let pixelWidth = Int(round(size.width * scale))
        let pixelHeight = Int(round(size.height * scale))

        let context = CGContext(
            data: nil,
            width: pixelWidth,
            height: pixelHeight,
            bitsPerComponent: 8,
            bytesPerRow: pixelWidth * 4,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
        context.scaleBy(x: scale, y: -scale)
        context.translateBy(x: 0, y: -size.height)

        UIGraphicsPushContext(context)
        draw(at: .zero)
        UIGraphicsPopContext()

        guard let cgImage = context.makeImage(),
              let dataProvider = cgImage.dataProvider,
              let data = dataProvider.data else {
            assertionFailure("Unexpected error!")
            return nil
        }

        return (data as Data).withUnsafeBytes { pixels in
            pixels.blurHash(
                numberOfComponents: components,
                width: cgImage.width,
                height: cgImage.height,
                bytesPerRow: cgImage.bytesPerRow,
                bitsPerPixel: cgImage.bitsPerPixel
            )
        }
    }

    public convenience init?(blurHash: String, size: CGSize, punch: Float = 1) {
        let width = Int(size.width)
        let height = Int(size.height)
        guard let data = Data(blurhash: blurHash, width: width, height: height, punch: punch) else { return nil }
        let bytesPerRow = width * 3
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        guard let provider = CGDataProvider(data: data as CFData) else { return nil }
        guard let cgImage = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 24, bytesPerRow: bytesPerRow,
        space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else { return nil }
        self.init(cgImage: cgImage)
    }

}

#endif
