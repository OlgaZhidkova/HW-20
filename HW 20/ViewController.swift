//
//  ViewController.swift
//  HW 20
//
//  Created by Ольга on 27.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordGenerationButton: UIButton!
    @IBOutlet weak var passwordGuessingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordLabel: UILabel!
    
    lazy var password = ""
    var queue = DispatchQueue(label: "brut", qos: .userInitiated)
 
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
                self.passwordGuessingIndicator.color = .white
            } else {
                self.view.backgroundColor = .white
                self.passwordGuessingIndicator.color = .black
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func startGuessing(_ sender: Any) {
        let password = passwordTextField.text ?? ""
        let passwordToUnlock: String
        if password.isEmpty {
            prepareForPasswordGuessing()
            passwordToUnlock = generatePassword()
            passwordTextField.text = passwordToUnlock
        } else {
            passwordToUnlock = password
            prepareForPasswordGuessing()
        }
        let startGuessing = DispatchWorkItem {
            self.bruteForce(passwordToUnlock: passwordToUnlock)
        }
        queue.async(execute: startGuessing)
    }
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - Functions
    
    func setupView() {
        passwordGuessingIndicator.hidesWhenStopped = true
        passwordTextField.isSecureTextEntry = true
        passwordLabel.text = "Ваш пароль: \n ..."
    }
    
    func prepareForPasswordGuessing() {
        password = ""
        passwordTextField.isEnabled = false
        passwordTextField.isSecureTextEntry = true
        passwordGenerationButton.isEnabled = false
        passwordGuessingIndicator.startAnimating()
    }
    
    func generatePassword() -> String {
        let characters = String().printable.map { String($0)}
        
        for _ in 0..<3 {
            password += characters.randomElement() ?? ""
        }
        return password
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            DispatchQueue.main.async {
                self.passwordLabel.text = "Ваш пароль: \n \(password)"
            }
            print(password)
        }
        DispatchQueue.main.async {
            self.passwordTextField.isSecureTextEntry = false
            self.passwordTextField.isEnabled = true
            self.passwordLabel.text = "Ваш пароль: \n \(password)"
            self.passwordGuessingIndicator.stopAnimating()
            self.passwordGenerationButton.isEnabled = true
        }
        print(password)
    }
    
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }

    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }
        return str
    }
}




