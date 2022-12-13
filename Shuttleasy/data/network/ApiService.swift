//
//  ApiService.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 7.12.2022.
//

import Foundation
import Alamofire

protocol UserTokenProvider {
    var token: String? { get }
}

class ApiService {  

    let tokenProvider: UserTokenProvider

    init(tokenProvider: UserTokenProvider) {
        self.tokenProvider = tokenProvider
    }
    
    func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = []

        if let currentToken = tokenProvider.token  {
            headers.add(.authorization(bearerToken: currentToken))
        }
        
        return headers
    }

    func getRequest<T: Decodable>(
        type: T.Type,
        url: String,
        parameters: Parameters? = nil,
        completion: @escaping (Result<T, Error>
    ) -> Void) {
        prepareRequest(url: url, parameters: parameters)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    private func  prepareRequest(
        url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil
    ) -> DataRequest {
        return AF.request(
            url,
            method: method,
            parameters: parameters,
            headers: headers()
        )
        .validate()
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
    }
    
    
    func getRequestAsync<T : Decodable>(
        type: T.Type,
        url: String,
        parameters: Parameters? = nil
    ) async throws -> T  {
        return try await prepareRequest(url: url, parameters: parameters).serializingDecodable(T.self).value
    }

    func postRequest<T: Decodable>(
        url: String,
        parameters: Parameters? = nil,
        completion: @escaping (Result<T, Error>
    ) -> Void) {
       prepareRequest(url: url, method: .post, parameters: parameters)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

   func postRequestAsync<T : Decodable>(
        type: T.Type,
        url: String,
        parameters: Parameters? = nil
    ) async throws -> T  {
        return try await prepareRequest(url: url, method: .post, parameters: parameters).serializingDecodable(T.self).value
    }

    func putRequest<T: Decodable>(
        url: String,
        parameters: Parameters? = nil,
        completion: @escaping (Result<T, Error>
    ) -> Void) {
        prepareRequest(url: url, method: .put, parameters: parameters)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func putRequestAsync<T : Decodable>(
        type: T.Type,
        url: String,
        parameters: Parameters? = nil
    ) async throws -> T  {
        return try await prepareRequest(url: url, method: .put, parameters: parameters).serializingDecodable(T.self).value
    }

    func deleteRequest<T: Decodable>(
        url: String,
        parameters: Parameters? = nil,
        completion: @escaping (Result<T, Error>
    ) -> Void) {
        prepareRequest(url: url, method: .delete, parameters: parameters)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func deleteRequestAsync<T : Decodable>(
        type: T.Type,
        url: String,
        parameters: Parameters? = nil
    ) async throws -> T  {
        return try await prepareRequest(url: url, method: .delete, parameters: parameters).serializingDecodable(T.self).value
    }

    func prepareUpload(
        url: String,
        data: Data,
        name : String,
        fileName :String,
        mimeType : String
    ) -> UploadRequest {
       return  AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(
                    data,
                    withName: name,
                    fileName: fileName,
                    mimeType: mimeType
                )
            },
            to: url,
            method: .post,
            headers: headers()
        )
        .validate()
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
    }

    func uploadRequest<T: Decodable>(
        url: String,
        data: Data,
        name : String,
        fileName :String,
        mimeType : String,
        completion: @escaping (Result<T, Error>
    ) -> Void) {
        prepareUpload(url: url, data: data, name: name, fileName: fileName, mimeType: mimeType)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }

    func uploadRequestAsync<T : Decodable>(
        url: String,
        data: Data,
        name : String,
        fileName :String,
        mimeType : String
    ) async throws -> T  {
        let responseT: T = try await withCheckedThrowingContinuation({continuation in
            prepareUpload(url: url, data: data, name: name, fileName: fileName, mimeType: mimeType)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        })

        return responseT
    }
}
