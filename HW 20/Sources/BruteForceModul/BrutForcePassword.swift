//
//  BrutForcePassword.swift
//  HW 20
//
//  Created by Ольга on 27.03.2022.
//

import Foundation

class BruteForcePassword: Operation {
    
    private var password: String

    // MARK: - Init
    
    init(password: String) {
        self.password = password
    }
    
    override func main() {
        super.main()
        if isCancelled {
            return
        }
        bruteForce(passwordToUnlock: password)
    }
    
    /// Метод подбора пароля.
    /// - Parameters:
    ///   - passwordToUnlock: Строка(String), которую нужно подобрать.
    /// - Returns: Строка, точно совпадающая со входящей строкой.
    func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password = ""

        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: allowedCharacters)
            print(password)
        }
        print(password)
    }
    
    /// Метод перебора символов для строки(String).
    /// - Parameters:
    ///   - string: Строка(String), которую нужно подобрать.
    ///   - array: Массив символов, по которым происходит перебор совпадающих символов.
    /// - Returns: Строка, точно совпадающая со входящей строкой.
    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var password = string

        if password.count <= 0 {
            password.append(characterAt(index: 0, array))
        }
        else {
            password.replace(at: password.count - 1,
                        with: characterAt(index: (indexOf(character: password.last ?? "1", array) + 1) % array.count, array))

            if indexOf(character: password.last ?? "1", array) == 0 {
                password = String(generateBruteForce(String(password.dropLast()), fromArray: array)) + String(password.last ?? "1")
            }
        }
        return password
    }
    
    /// Метод получение индекса заданного символа.  Возвращает -1, если не удается найти символ.
    /// - Parameters:
    ///   - character: Символ, который может быть в данном массиве.
    ///   - array: Массив строк, который может содержать заданный символ.
    /// - Returns: Индекс символа в массиве.
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character)) ?? Int()
    }

    /// Метод получения символа на позиции заданного индекса.
    /// - Parameters:
    ///   - index: Индекс в заданном массиве.
    ///   - array: Массив строк, который может содержать символ по заданному индексу.
    /// - Returns: Символ, найденый по индексу.
    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }
}
