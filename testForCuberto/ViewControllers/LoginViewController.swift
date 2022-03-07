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
    let domains = EmailProviders.getProviders()
    var start = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        
        setUpElement()
        
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
        
        
        emailTextField.inputAccessoryView = emailBar
        emailBar.isHidden = true
        
        loginImage.layer.cornerRadius = loginImage.frame.height / 2
        loginImage.layer.borderWidth = 2
        loginImage.layer.borderColor = UIColor.white.cgColor
        
        infoLabel.alpha = 0
        infoLabel.textColor = .white
        
        
        emailTextField.returnKeyType = .done
        emailTextField.textColor = .white
        Utilities.styleTextField(emailTextField)
    }
    
    
    func fetchInfo() {
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



