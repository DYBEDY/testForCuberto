//
//  Verification.swift
//  testForCuberto
//
//  Created by Roman on 01.03.2022.
//

import Foundation

struct Verification: Decodable {
    let result: String?
    let reason: String?
    let didYouMean: String?
    let email: String?
    let domain: String?
    let success: Bool
    

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case reason = "reason"
        case didYouMean = "did_you_mean"
        case email = "email"
        case domain = "domain"
        case success = "success"
        
    }
    
   
  
}
