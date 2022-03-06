//
//  ViewController.swift
//  testForCuberto
//
//  Created by Roman on 01.03.2022.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var emailBar: UIScrollView!
    
    @IBOutlet var loginImage: UIImageView!
    
  
    
    private var verification: (Verification?)
    private let domains = EmailProviders.getProviders()


    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
    
        setUpElement()
        showDomains()
    }
    
    
 
    
   
    private func setUpElement() {
        emailTextField.leftViewMode = .always
        let imageView = UIImageView()
        let image = UIImage(systemName: "envelope.circle")
        imageView.image = image
        imageView.frame = CGRect(x: 5, y: 0,
                                 width: emailTextField.frame.height,
                                 height: emailTextField.frame.width)
        imageView.tintColor = UIColor.white
        
        emailTextField.leftView = imageView
        
        
        
        
        loginImage.layer.cornerRadius = loginImage.frame.height / 2
        loginImage.layer.borderWidth = 2
        loginImage.layer.borderColor = UIColor.white.cgColor
        
        infoLabel.alpha = 0
        infoLabel.textColor = .white
        
        
        emailTextField.returnKeyType = .done
        emailTextField.textColor = .white
        Utilities.styleTextField(emailTextField)
    }
    
    
    
    private func fetchInfo() {
        NetworkManager.shared.fetch(dataType: Verification.self, email: emailTextField.text ?? "") { [weak self] result in
            switch result {
                
            case .success(let result):
                self?.verification = result
                 if self?.verification?.didYouMean != nil {
                    self?.showAlert(title: "Invalid Domain", message: "Did you mean \(self?.verification?.didYouMean ?? "")?")
                } else if self?.verification?.result == "undeliverable" {
                    self?.infoLabel.textColor = .red
                    self?.displayWarningLabel(with: "Invalid email")
                } else {
                    self?.infoLabel.textColor = .white
                    self?.displayWarningLabel(with: "Your email is OK")
                }
                    
                
            case .failure(let error):
                self?.infoLabel.textColor = .red
                self?.displayWarningLabel(with: "Invalid email")
                print(error)
            }
        }
    }

    
   
    
    
    private func displayWarningLabel(with text: String) {
        infoLabel.text = text
    
        UIView.animate(withDuration: 8, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 3, options: .curveEaseInOut) { [weak self] in
            self?.infoLabel.alpha = 1
        } completion: { [weak self] complete in
            self?.infoLabel.alpha = 0
        }
    }
    
    
}


//MARK: - Alert Method

extension LoginViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] _ in
            self?.emailTextField.text = self?.verification?.didYouMean
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
            self?.emailTextField.text = nil
        }
        
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

//MARK: - TextField Methods

extension LoginViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with:event)
        view.endEditing(true)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchInfo()
        view.endEditing(true)
        return false
    }
}


extension LoginViewController {

    func showDomains() {
        emailTextField.inputAccessoryView = emailBar
        emailBar.isHidden = true
        var lastX: CGFloat = 8.0
        for domain in domains {
            let button = UIButton()
            button.setTitle(domain, for: .normal)
            button.setTitleColor(UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0), for: .normal)
            button.addTarget(self, action: #selector(appendEmailProvider(_:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
            button.sizeToFit()
            button.frame.origin = CGPoint(x: lastX, y: 4.0)
            emailBar.addSubview(button)
            lastX += button.frame.width + 20
        }

        emailBar.contentSize = CGSize(width: lastX, height: 32.0)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

    }

    @objc func textFieldDidChange() {
        if emailTextField.text?.contains("@") == true {
            emailBar.contentOffset.x = 0
            emailBar.isHidden = false
            emailBar.backgroundColor = UIColor(red: 205/255, green: 207/255, blue: 213/255, alpha: 100/255)
        } else {
            emailBar.isHidden = true
        }
    }

    @objc func appendEmailProvider(_ sender: UIButton) {

        if let provider = sender.title(for: .normal) {
            let text = emailTextField.text ?? ""
            let index = text.firstIndex(of: "@") ?? text.endIndex
            let begginning = text[..<index]
            let newText = String(begginning)

            emailTextField.text = ("\(newText)@\(provider)")

        }
    }
}



