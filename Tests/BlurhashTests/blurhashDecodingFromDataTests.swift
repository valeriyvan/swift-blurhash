import Foundation
import Testing
@testable import Blurhash

// This is de facto snapshot test and it would be better
// to use swift-snapshot-testing framework.

@Test(arguments:
    [
        ("LLHV6nae2ek8lAo0aeR*%fkCMxn%", 269, 173, "12c2aca29ea896a628be-blurred"),
        ("L6Pj0^nh.AyE?vt7t7R**0o#DgR4", 242, 172, "a355ab362a07a267e078-blurred"),
        ("LGFFaXYk^6#M@-5c,1J5@@or[j6V", 301, 193, "e08adedc9f82ade9f9d5-blurred"),
        ("LKO2?V%2Tw=^]~RBVZRi};RPxuwH", 187, 120, "ea9e499f8080ce9956a8-blurred")
    ]
)
func blurhashDecodingFromDataTests(
    hash: String,
    width: Int,
    height: Int,
    sampleFilename: String
) async throws {
    let data = Data(blurhash: hash, width: width, height: height)!
        .withUnsafeBytes { ptr in                             // Adds alpha channel
            var data = Data()                                 // because Bitmap needs it
            data.reserveCapacity(ptr.count / 3 * 4)           //
            for i in stride(from: 0, to: ptr.count, by: 3) {  //
                data.append(ptr[i])                           //
                data.append(ptr[i + 1])                       //
                data.append(ptr[i + 2])                       //
                data.append(255)                              //
            }                                                 //
            return data                                       //
        }                                                     //
    let bitmap = Bitmap(width: width, height: height, data: data)
    let bitmapSample = try Bitmap(ppmBundleResource: sampleFilename, withExtension: "ppm")
    #expect(bitmap == bitmapSample)
}
