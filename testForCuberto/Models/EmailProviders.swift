//
//  EmailProviders.swift
//  testForCuberto
//
//  Created by Roman on 05.03.2022.
//

import Foundation

struct EmailProviders {
    var providers: [String]
    
    static func getProviders() -> [String] {
        let emailProviders = ["@gmail.com", "@yahoo.com",
                              "@hotmail.com", "@outlook.com",
                              "@yandex.ru", "@mail.ru",
                              "@icloud.com", "@rambler.ru",
                              "@inbox.com", "@zoho.com"]
        return emailProviders
    }
}
