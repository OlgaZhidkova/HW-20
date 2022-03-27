//
//  String+Extention.swift
//  HW 20
//
//  Created by Ольга on 28.02.2022.
//

import Foundation

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    /// Метод замены символа в строке по индексу.
    /// - Parameters:
    ///   - index: Индекс симовола, который будет заменен.
    ///   - length: Символ, который будет поставлен по данному индексу.
    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }

    /// Метод генерации строки(String).
    /// - Parameters:
    ///   - length: Нужное количество символов в возращаемой строке.
    /// - Returns: Строка  из рандомных символов.
    static func random(length: Int = 10) -> String {

        let printable = String().printable.map { String($0) }
        var randomString = ""

        for _ in 0 ..< length {
            randomString.append(printable.randomElement()!)
        }
        return randomString
    }

    /// Метод разделения строки(String) на массив строк.
    /// - Parameters:
    ///   - length: Количество символов, на которое будет разбита строка.
    /// - Returns: Массив строк.
    func split(by length: Int = 2) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        return results.map { String($0) }
    }
}
