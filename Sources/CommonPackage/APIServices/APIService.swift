//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation
import RxSwift

public protocol APIService: AnyObject {
    var session: URLSession! { get }
    var baseURL: URL! { get }
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }
    var headers: [String: String] { get }
    var sessionTask: SessionTask { get }
}

public extension APIService {
    
    var session: URLSession! {
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForRequest = 10
        urlSessionConfiguration.timeoutIntervalForResource = 10
        return .init(configuration: urlSessionConfiguration)
    }
    
    func call(endpoint: APICall) -> Completable {
        let response: Single<AnyDecodable?> = callOptional(endpoint: endpoint)
        return response.asCompletable()
    }
    
    func call<Value: Decodable>(endpoint: APICall) -> Single<Value> {
        let response: Single<Response<Value>> = callAPI(endpoint: endpoint)
        return response.flatMap { res in
            if let error = res.error {
                throw error
            }
            if let data = res.data {
                return .just(data)
            }
            throw APIError.defaultError()
        }
    }
    
    func callOptional<Value: Decodable>(endpoint: APICall) -> Single<Value?> {
        let response: Single<Response<Value>> = callAPI(endpoint: endpoint)
        return response.flatMap { res in
            if let error = res.error {
                throw error
            }
            return .just(res.data)
        }
    }
    
    private func callAPI<Value: Decodable>(endpoint: APICall) -> Single<Value> {
        return Single.create { single in
            let request = endpoint.urlRequest(baseURL: self.baseURL, encoder: self.encoder, headers: self.headers)
            
            let task = self.session.dataTask(with: request) { data, response, error in
                self.logData(url: response?.url?.absoluteString ?? "", data: data)

                if let error = error {
                    log.error("\(response?.url?.absoluteString ?? "") - \(error)")
                    single(.failure(error))
                    return
                }
                guard let data = data else {
                    single(.failure(NSError(domain: "Default error", code: -1)))
                    return
                }
                do {
                    let object = try self.decoder.decode(Value.self, from: data)
                    single(.success(object))
                } catch {
                    log.error("\(response?.url?.absoluteString ?? "") - \(error)")
                    single(.failure(error))
                }
            }
            task.resume()
//            self.sessionTask.add(task: task)
            return Disposables.create {
//                self.sessionTask.remove(taskIdentifier: task.taskIdentifier)
                task.cancel()
            }
        }
    }
    
    private func logData(url: String, data: Data?) {
        if let json = data?.toDictionary?.json {
            log.info("RESPONSE: \(url) \nBODY: \(json)")
        } else if let data = data {
            log.info("RESPONSE: \(url) \nBODY: \(String(describing: String(data: data, encoding: .utf8)))")
        } else {
            log.info("RESPONSE: \(url) \nBODY: Empty!!!")
        }
    }
}

public class SessionTask {
    
    private var tasks: [URLSessionTask]
    
    public init() {
        tasks = [URLSessionTask]()
    }
    
    func add(task: URLSessionTask) {
        self.tasks.append(task)
    }
    
    func remove(taskIdentifier: Int) {
        guard let index = tasks.firstIndex(where: { $0.taskIdentifier == taskIdentifier }) else {
            return
        }
        tasks.remove(at: index)
    }
}
