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

final class Logger: EventMonitor {

    
    // Event called whenever a DataRequest has parsed a response.
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        debugPrint("Finished:response \(response)")
        debugPrint("Headers:response \(response.response?.allHeaderFields ?? [:])")
        debugPrint("Body:response \(response.data?.debugDescription ?? "nil")")
        debugPrint("Error:response \(response.error?.localizedDescription ?? "nil")")
        debugPrint("Result:response \(response.result)")
    }

    // Event called when any type of Request is resumed.
    func requestDidResume(_ request: Request) {
        print("Resuming:request \(request)")
        debugPrint("Headers:request \(request.request?.allHTTPHeaderFields ?? [:])")
        debugPrint("Body:request \(request.request?.httpBody?.debugDescription ?? "nil")")
    }
}


class ApiService {  

    let tokenProvider: UserTokenProvider

    init(tokenProvider: UserTokenProvider) {
        self.tokenProvider = tokenProvider
    }
    
    func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = []

        if let currentToken = tokenProvider.token  {
            headers.add(
                .authorization("bearer \(currentToken)")
            )
            print("token added to headers \(currentToken.contains("\n"))")
        }

        return headers
    }

    func getRequest<T: Decodable>(
        type: T.Type,
        url: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        completion: @escaping (Result<T, Error>
    ) -> Void) {
        prepareRequest(url: url, parameters: parameters, encoding: encoding)
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
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default
    ) -> DataRequest {
        return Alamofire.AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers()
        )
        .validate()
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        
    }
    
    
    func getRequestAsync<T : Decodable>(
        type: T.Type,
        url: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default
    ) async throws -> T  {
        return try await prepareRequest(
            url: url, 
            parameters: parameters,
            encoding: encoding
        )
        .responseDebugLog()
        .serializingDecodable(T.self)
        .value
    }

    func postRequest<T: Decodable>(
        url: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
       prepareRequest(
            url: url, 
            method: .post, 
            parameters: parameters, 
            encoding: encoding
        ).responseDecodable(of: T.self) { response in
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
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default
    ) async throws -> T  {
        return try await prepareRequest(
            url: url, 
            method: .post, 
            parameters: parameters,
            encoding: encoding
        )
        .requestDebugLog()
        .responseDebugLog()
        .serializingDecodable(T.self)
        .value
    }

    func postRequestAsyncUnit(
        url: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default
    ) async -> HTTPURLResponse? {
        return await withCheckedContinuation({ continuation in
            prepareRequest(
                url: url,
                method: .post,
                parameters: parameters,
                encoding: encoding
            ).requestDebugLog()
                .responseDebugLog()
                .responseData { data in
                    continuation.resume(returning: data.response)
                }
        })
    }
    

    func putRequest<T: Decodable>(
        url: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        completion: @escaping (Result<T, Error>
    ) -> Void) {
        prepareRequest(url: url, method: .put, parameters: parameters, encoding: encoding)
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
        return try await prepareRequest(url: url, method: .put, parameters: parameters)
            .requestDebugLog()
            .responseDebugLog()
            .serializingDecodable(T.self)
            .value
    }

    func putRequestAsyncUnit(
        url: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default
    ) async -> HTTPURLResponse? {
        return await withCheckedContinuation({ continuation in
            prepareRequest(
                url: url,
                method: .put,
                parameters: parameters,
                encoding: encoding
            ).requestDebugLog()
                .responseDebugLog()
                .responseData { data in
                    continuation.resume(returning: data.response)
                }
        })
    }

    func deleteRequest<T: Decodable>(
        url: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        completion: @escaping (Result<T, Error>
    ) -> Void) {
        prepareRequest(url: url, method: .delete, parameters: parameters , encoding: encoding)
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
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default
    ) async throws -> T  {
        return try await prepareRequest(
            url: url, 
            method: .delete,
            parameters: parameters,
            encoding: encoding
        ).serializingDecodable(T.self).value
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

extension DataRequest {
    func responseDebugLog() -> Self {
        return responseString(completionHandler: { response in
            debugPrint("")
            debugPrint("---------Response-------")
            debugPrint("Finished:response \(response)")
            debugPrint("Headers:response \(response.response?.allHeaderFields ?? [:])")
            debugPrint("Body:response \(response.data?.debugDescription ?? "nil")")
            debugPrint("Error:response \(response.error?.localizedDescription ?? "nil")")
            debugPrint("Error:response \(response.error?.failureReason ?? "nil")")
            debugPrint("Result:response \(response.result)")
            debugPrint("----------------")
            debugPrint("")
        })
    }

    
    func requestDebugLog() -> Self {
        return onURLRequestCreation(perform: { urlRequest  in
            debugPrint("")
            debugPrint("--------Request--------")
            debugPrint("Request: \(urlRequest)")
            debugPrint("Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
            debugPrint("Body: \(urlRequest.httpBody?.debugDescription ?? "nil")")
            debugPrint("----------------")
            debugPrint("")
        })
    }
    
}
