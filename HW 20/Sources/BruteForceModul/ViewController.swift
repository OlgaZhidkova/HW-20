//
//  ViewController.swift
//  HW 20
//
//  Created by Ольга on 27.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordGenerationButton: UIButton!
    @IBOutlet weak var passwordGuessingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordLabel: UILabel!
    
    //MARK: - Properties
    private let queue = OperationQueue()
 
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
        startPasswordGuessing()
        
        // В переменную password передается  значение из textField
        let password = passwordTextField.text ?? ""
        
        // Строка с паролем делится на массив из строк по 2 символа
        let splitedPassword = password.split()
        
        var arrayBruteForcePassword = [BruteForcePassword]()
        
        // Каждая мини строка из массива отправляется в операцию
        splitedPassword.forEach { i in
            arrayBruteForcePassword.append(BruteForcePassword(password: i))
        }

        // Каждая операция отправляется в очередь
        arrayBruteForcePassword.forEach { operation in
            queue.addOperation(operation)
        }

        queue.addBarrierBlock { [unowned self] in
            OperationQueue.main.addOperation {
                passwordGuessed()
            }
        }
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
        passwordTextField.placeholder = "Пароль"
        passwordGuessingIndicator.hidesWhenStopped = true
        passwordTextField.isSecureTextEntry = true
        passwordLabel.text = "Ваш пароль: \n ..."
    }
    
    func startPasswordGuessing() {
        passwordTextField.text = String.random()
        passwordTextField.isEnabled = false
        passwordTextField.isSecureTextEntry = true
        passwordGenerationButton.isEnabled = false
        passwordGuessingIndicator.startAnimating()
    }
    
    func passwordGuessed() {
        passwordTextField.isSecureTextEntry = false
        passwordTextField.isEnabled = true
        passwordLabel.text = "Ваш пароль: \n \(self.passwordTextField.text ?? "Error")"
        passwordGuessingIndicator.stopAnimating()
        passwordGenerationButton.isEnabled = true
    }
}




