//
//  NetworkManager.swift
//  AppStore
//
//  Created by Langpeu on 12/29/25.
//

import Alamofire
import Foundation

final class NetworkManager {
    private let session: Session = {
        let config = URLSessionConfiguration.default
        
        config.requestCachePolicy = .returnCacheDataElseLoad
        return Session(configuration: config)
    }()
    
    func fetchData<T: Decodable>(url: String,
                   method: HTTPMethod,
                   parameter: Parameters? = nil,
                   encoding: ParameterEncoding = URLEncoding.default) async
    -> Result<[T], NetworkError> {
    
        guard let url = URL(string: url) else { return .failure(.urlError)}
        
        let result = await session.request(url, method: method, parameters: parameter, encoding: encoding)
            .validate().serializingData().response
        
        if result.error != nil {
            return .failure(NetworkError.requestFail)
        }
        
        guard let data = result.data else { return .failure(.dataNil)}
        guard let response = result.response else { return .failure(.invalid)}
        
        if 200..<400 ~= response.statusCode {
            do {
                let networkResponse = try JSONDecoder().decode(NetworkResponse<T>.self, from: data)
                
                return .success(networkResponse.results)
            } catch {
                return .failure(.failToDecode)
            }
        }else {
            return .failure(.serverError(response.statusCode))
        }
    }
}

struct NetworkResponse<T: Decodable>: Decodable {
    let resultCount: Int
    let results: [T]
}

enum NetworkError: Error {
    case urlError
    case requestFail
    case dataNil
    case invalid
    case serverError(Int)
    case failToDecode
}
