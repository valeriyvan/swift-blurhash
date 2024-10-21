import Foundation
import Testing
@testable import Blurhash

@Test(arguments:
    [
        ("12c2aca29ea896a628be", 269, 173, 4, "LLHV6nae2ek8lAo0aeR*%fkCMxn%"),
        ("a355ab362a07a267e078", 242, 172, 4, "L6Pj0^nh.AyE?vt7t7R**0o#DgR4"),
        ("e08adedc9f82ade9f9d5", 301, 193, 4, "LGFFaXYk^6#M@-5c,1J5@@or[j6V"),
        ("ea9e499f8080ce9956a8", 187, 120, 4, "LKO2?V%2Tw=^]~RBVZRi};RPxuwH")
    ]
)
func dataTests(
    filename: String,
    width: Int,
    height: Int,
    bytesPerPixel: Int,
    hashSample: String
) async throws {
    guard let url = Bundle.module.url(forResource: filename, withExtension: "dat") else {
        fatalError("Resource \"\(filename).dat\" not found in test bundle")
    }
    let data = try Data(contentsOf: url)
    #expect(data.count == width * height * bytesPerPixel)
    #expect(
        data.blurHash(
            numberOfComponents: (4, 3),
            width: width,
            height: height,
            bytesPerRow: width * bytesPerPixel,
            bitsPerPixel: 8 * bytesPerPixel
        )
        ==
        hashSample
    )
}
