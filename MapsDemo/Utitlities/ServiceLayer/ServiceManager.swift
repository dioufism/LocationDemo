//
//  ServiceManager.swift
//  MapsDemo
//
//  Created by ousmane diouf on 10/20/20.
//  Copyright © 2020 ExaData. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case serverError
    case decodingFailed
}

class ServiceManager {
    
    static let manager = ServiceManager()
    
    private init() {}
    
    func request<T: Decodable>( type: T.Type, withRequest urlRequest: URLRequest, completion: @escaping (Result<T, CustomError>) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, (response.statusCode == 200) else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(obj))
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed))
                }
            }
        }
        task.resume()
    }
}
