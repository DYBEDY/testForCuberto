//
//  NetworkManager.swift
//  testForCuberto
//
//  Created by Roman on 01.03.2022.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    private var apikey = "test_ad5a03b3496782395f5c2ef5ea048169f57f8d7bb4e3cedeaac0871eade6bb2d"
//    "live_690aef95446940d099f0afc5dba6dc9b9bfc3ef976953cfffdf83b116e551798"
//    "test_ad5a03b3496782395f5c2ef5ea048169f57f8d7bb4e3cedeaac0871eade6bb2d"
    
    
    private init() {}
    

    func fetch<T: Decodable>(dataType: T.Type, email: String, completion: @escaping(Result<T, NetworkError>) -> Void) {

        guard let url = URL(
            string: "https://api.kickbox.com/v2/verify?email=\(email)&apikey=\(apikey)") else {
        //        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No description")
                return
            }
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    print(type)
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    
    
}






//     func validate(_ email: String) {
//
//        guard let url = URL(
//            string: "https://api.kickbox.com/v2/verify?email=\(email)&apikey=\(apikey)") else { return }
//
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data else {
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//
//            do {
//                let _ = try JSONDecoder().decode(Verification.self, from: data)
//
//            } catch {
//                print(String(describing: error))
//            }
//        }.resume()
//    }
//
