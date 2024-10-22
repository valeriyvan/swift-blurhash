extension BinaryInteger {

    /// Encodes part or whole integer value with custom base83 encoding.
    /// - Parameter length: defines how many characters encoded string should have.
    /// - Returns: encoded value
    func encode83(length: Int) -> String {
        assert(length > 0)
        var result = ""
        for i in 1...length {
            let index = (Int(self) / pow(83, length - i)) % 83
            result.append(encodeCharacters[index])
        }
        return result
    }

}

extension String {
    
    /// Decodes base 83 encoded string. Function ignores unexpected character.
    /// - Returns: decoded value
    func decode83() -> Int {
        var value: Int = 0
        for character in self {
            if let digit = decodeCharacters[character] {
                value = value * 83 + digit
            }
        }
        return value
    }

}

private let decodeCharacters: [Character: Int] = {
    var dict: [Character: Int] = [:]
    for (index, character) in encodeCharacters.enumerated() {
        dict[character] = index
    }
    return dict
}()

let encodeCharacters: [Character] = [
    Character("0"),
    Character("1"),
    Character("2"),
    Character("3"),
    Character("4"),
    Character("5"),
    Character("6"),
    Character("7"),
    Character("8"),
    Character("9"),
    Character("A"),
    Character("B"),
    Character("C"),
    Character("D"),
    Character("E"),
    Character("F"),
    Character("G"),
    Character("H"),
    Character("I"),
    Character("J"),
    Character("K"),
    Character("L"),
    Character("M"),
    Character("N"),
    Character("O"),
    Character("P"),
    Character("Q"),
    Character("R"),
    Character("S"),
    Character("T"),
    Character("U"),
    Character("V"),
    Character("W"),
    Character("X"),
    Character("Y"),
    Character("Z"),
    Character("a"),
    Character("b"),
    Character("c"),
    Character("d"),
    Character("e"),
    Character("f"),
    Character("g"),
    Character("h"),
    Character("i"),
    Character("j"),
    Character("k"),
    Character("l"),
    Character("m"),
    Character("n"),
    Character("o"),
    Character("p"),
    Character("q"),
    Character("r"),
    Character("s"),
    Character("t"),
    Character("u"),
    Character("v"),
    Character("w"),
    Character("x"),
    Character("y"),
    Character("z"),
    Character("#"),
    Character("$"),
    Character("%"),
    Character("*"),
    Character("+"),
    Character(","),
    Character("-"),
    Character("."),
    Character(":"),
    Character(";"),
    Character("="),
    Character("?"),
    Character("@"),
    Character("["),
    Character("]"),
    Character("^"),
    Character("_"),
    Character("{"),
    Character("|"),
    Character("}"),
    Character("~")
]
