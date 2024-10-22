import Foundation
import Testing
@testable import Blurhash

@Test(arguments:
    [
        (172, 1, "6", 6),
        (172, 2, "26", 172),
        (1425, 1, "E", 14),
        (1425, 2, "HE", 1425),
        (1425, 3, "0HE", 1425),
        (837362, 1, "w", 58),
        (837362, 2, "jw", 3793),
        (837362, 3, "cjw", 265575),
        (837362, 4, "1cjw", 837362),
        (837362, 5, "01cjw", 837362)
    ]
)
func base83EncodingDecodingTests(
    input: Int,
    length: Int,
    inputEncoded: String,
    decoded: Int
) async throws {
    let encoded: String = input.encode83(length: length)
    #expect(encoded == inputEncoded)
    #expect(inputEncoded.decode83() == decoded)
}
