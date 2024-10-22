import Foundation
import Testing
@testable import Blurhash

@Test(.serialized,
    arguments:
    [

        ("12c2aca29ea896a628be",
         [
             RGBFloat(r: 0.30878544, g: 0.3056636, b: 0.30044177),
             RGBFloat(r: -0.0025237123, g: -0.0049696066, b: -0.00431733),
             RGBFloat(r: -0.13553469, g: 0.0027419513, b: 0.074508645),
             RGBFloat(r: 0.0007542877, g: 0.0043704687, b: -0.004289835),
             RGBFloat(r: 0.003214036, g: 0.05401443, b: 0.08857017),
             RGBFloat(r: 0.004342749, g: 0.0002722235, b: -0.0005242291),
             RGBFloat(r: -0.0016526144, g: -0.0049857, b: -0.007853879),
             RGBFloat(r: -0.011904109, g: -0.005987661, b:-0.0047992463),
             RGBFloat(r: 0.035423305, g: 0.050126582, b: 0.04661301),
             RGBFloat(r: 0.0013048295, g: 0.004633289, b: 0.0038941738),
             RGBFloat(r: -0.021357207, g: -0.038470365, b: -0.040393975),
             RGBFloat(r: 0.0059506716, g: -0.0030350043, b: -0.0010135288)
         ],
        //LEHV6nWB2yk8pyo0adR*.7kCMdnj website
         "LLHV6nae2ek8lAo0aeR*%fkCMxn%"
        ),

        ("a355ab362a07a267e078",
         [
            RGBFloat(r: 0.72753096, g: 0.69633704, b: 0.66635484),
            RGBFloat(r: 0.0021833314, g: -0.001998111, b: -0.005146616),
            RGBFloat(r: 0.017321492, g: 0.027120769, b: 0.04085801),
            RGBFloat(r: 0.008470643, g: 0.020957625, b: 0.02555934),
            RGBFloat(r: 0.029038105, g: 0.032329988, b: 0.032237273),
            RGBFloat(r: 0.0043088165, g: 0.004133791, b: 0.0036170548),
            RGBFloat(r: 0.0040016836, g: 0.0038395089, b: 0.0041517783),
            RGBFloat(r: -0.003671437, g: -0.0028503258, b: -0.001400331),
            RGBFloat(r: 0.013644979, g: 0.030343208, b: 0.043096587),
            RGBFloat(r: 0.0014947575, g: 0.0063477866, b: 0.0074247946),
            RGBFloat(r: -0.016794058, g: -0.028411055, b: -0.040853225),
            RGBFloat(r: -0.0035878073, g: -0.015106905, b: -0.018747382)
         ],
        //L6Pj0^jE.AyE_3t7t7R**0o#DgR4 website
         "L6Pj0^nh.AyE?vt7t7R**0o#DgR4"
        ),

        ("e08adedc9f82ade9f9d5",
         [
            RGBFloat(r: 0.23125176, g: 0.20994714, b: 0.3166483),
            RGBFloat(r: -0.003804303, g: 0.07915348, b: 0.103307836),
            RGBFloat(r: 0.0800351, g: 0.019863475, b: 0.02226438),
            RGBFloat(r: 0.032667723, g: -0.012600455, b: -0.102502584),
            RGBFloat(r: 0.07482678, g: -0.051079076, b: 0.06410716),
            RGBFloat(r: -0.08019731, g: -0.03525571, b: 0.056062106),
            RGBFloat(r: 0.04334971, g: -0.007005566, b: 0.029254735),
            RGBFloat(r: -0.038121708, g: -0.003921937, b: -0.01682467),
            RGBFloat(r: 0.07860153, g: -0.030930974, b: -0.03858918),
            RGBFloat(r: 0.007507471, g: 0.012047446, b: -0.030002628),
            RGBFloat(r: 0.08893829, g: -0.0076798913, b: -0.0943987),
            RGBFloat(r: -0.078626044, g: -0.00035222684, b: 0.06089586)
         ],
        //LGF5]+Yk^6#M@-5c,1J5@[or[Q6.   website
         "LGFFaXYk^6#M@-5c,1J5@@or[j6V"
        ),

        ("ea9e499f8080ce9956a8",
         [
            RGBFloat(r: 0.63763314, g: 0.44426617, b: 0.36904028),
            RGBFloat(r: 0.03791303, g: 0.02244274, b: 0.028183736),
            RGBFloat(r: -0.015359608, g: 0.056596585, b: 0.041824784),
            RGBFloat(r: 0.07051058, g: 0.033277187, b: 0.007664984),
            RGBFloat(r: 0.09313051, g: 0.021537164, b: -0.012714193),
            RGBFloat(r: -0.010193944, g: -0.034599114, b: 0.0020411063),
            RGBFloat(r: -0.0069687143, g: -0.042110477, b: -0.028846713),
            RGBFloat(r: -0.014612513, g: -0.012259891, b: -0.019959081),
            RGBFloat(r: 0.12502138, g: 0.06114881, b: 0.0037329488),
            RGBFloat(r: -0.012195165, g: -0.026794404, b: -0.022212312),
            RGBFloat(r: 0.023422938, g: 0.030282881, b: 0.02028124),
            RGBFloat(r: 0.023612037, g: -0.0061795614, b: -0.031144708)
         ],
        //LKO2?U%2Tw=w]~RBVZRi};RPxuwH  website
         "LKO2?V%2Tw=^]~RBVZRi};RPxuwH"
        )

    ]
)
func blurhashTest(filename: String, factorsSample: [RGBFloat], hash hashSample: String) async throws {
    let b = try Bitmap(ppmBundleResource: filename, withExtension: "ppm")
    let hash = b.backing.withUnsafeBytes {
        $0.blurHash(
            numberOfComponents: (4, 3),
            width: b.width,
            height: b.height,
            bytesPerRow: b.width * 4, // TODO: 4 bytes because Bitmap uses RGBA
            bitsPerPixel: 8 * 4       //
        )
    }
    #expect(hash == hashSample)
}
