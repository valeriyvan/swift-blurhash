extension BinaryInteger {
    func encode83(length: Int) -> String {
        var result = ""
        for i in 1...length {
            let index = (Int(self) / pow(83, length - i)) % 83
            result += encodeCharacters[index]
        }
        return result
    }
}
