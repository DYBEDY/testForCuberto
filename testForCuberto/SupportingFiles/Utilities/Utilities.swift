//
//  Utilities.swift
//  testForCuberto
//
//  Created by Roman on 02.03.2022.
//

import Foundation
import UIKit

class Utilities {
    static func styleTextField(_ textField: UITextField) {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: 30, width: textField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
    }
}
