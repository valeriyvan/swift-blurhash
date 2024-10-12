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
}

#endif
