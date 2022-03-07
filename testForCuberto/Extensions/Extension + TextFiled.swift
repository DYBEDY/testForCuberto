//
//  Extension + TextFiled.swift
//  testForCuberto
//
//  Created by Roman on 07.03.2022.
//

import UIKit

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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            start = (string == "@" ? range.location : start)
            
            var text = String()
            
            if range.location >= start {
                let startIndex = updatedText.index(updatedText.startIndex, offsetBy: start)
                let textTest = updatedText[startIndex...]
                text = String(textTest)
            }
            
            var lastX: CGFloat = 8.0
            
            emailBar.subviews.forEach { $0.removeFromSuperview() }
            
            for domain in domains {
                let button = UIButton()
                if  domain.contains(text) {
                    button.setTitle(domain, for: .normal)
                    button.setTitleColor(UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 1.0), for: .normal)
                    button.addTarget(self, action: #selector(appendEmailProvider(_:)), for: .touchUpInside)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
                    button.sizeToFit()
                    button.frame.origin = CGPoint(x: lastX, y: 4.0)
                    emailBar.addSubview(button)
                    lastX += button.frame.width + 20
                }
            }
            emailBar.contentSize = CGSize(width: lastX, height: 32.0)
            emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        return true
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
        
        if let domain = sender.title(for: .normal) {
            let text = emailTextField.text ?? ""
            let index = text.firstIndex(of: "@") ?? text.endIndex
            let begginning = text[..<index]
            let newText = String(begginning)
            
            emailTextField.text = ("\(newText)\(domain)")
            print(domain)
        }
    }
    
    
    
    
    
}



