//
//  RESTManager.swift
//  interview
//
//  Created by macbook on 6.05.2021.
//

import Foundation

protocol Requestable {

    associatedtype ResponseType: Codable

    var endpoint: String { get }
    var method: Network.Method { get }
    var query:  Network.QueryType { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var baseUrl: URL { get }

    // We did not have to add these variables (timeout and cachePolicy) to protocol but i like to have control while coding to make codebase scalable
    var timeout : TimeInterval { get }
    var cachePolicy : NSURLRequest.CachePolicy { get }
}

extension Requestable {

    var defaultJSONHeader : [String: String] {
        return ["accept" : "application/json" ,"Content-Type" : "application/json"]
    }
}

enum NetworkResult<T> {
    case success(T)
    case failure(Error?)
}

class Network {

    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    public enum QueryType {
        case json, path
    }

    static func request<T: Requestable>(req: T, completionHandler: @escaping (NetworkResult<T.ResponseType>) -> Void) {

        let appendingUrl = req.baseUrl.appendingPathComponent(req.endpoint).absoluteString.removingPercentEncoding
        let checkurl = appendingUrl?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        guard let appendedUrl = checkurl else { return }
        guard let url = URL(string: appendedUrl) else { return }

        let request = prepareRequest(for: url, req: req)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let data = data {
                DispatchQueue.main.async {
                    let decoder = JSONDecoder()
                    do {
                        let object = try decoder.decode(T.ResponseType.self, from: data)
                        completionHandler(NetworkResult.success(object))
                    } catch let error {
                        completionHandler(NetworkResult.failure(error))
                    }
                }
            } else {
                completionHandler(NetworkResult.failure(error))
            }
        }.resume()
    }
}

extension Network {

    private static func prepareRequest<T: Requestable>(for url: URL, req: T) -> URLRequest {

        var request : URLRequest? = nil

        switch req.query {
        case .json:
            request = URLRequest(url: url, cachePolicy: req.cachePolicy,
                                 timeoutInterval: req.timeout)
            if let params = req.parameters {
                do {
                    let body = try JSONSerialization.data(withJSONObject: params, options: [])
                    request!.httpBody = body
                } catch {
                    assertionFailure("Error : while attemping to serialize the data for preparing httpBody \(error)")
                }
            }
        case .path:
            var query = ""

            req.parameters?.forEach { key, value in
                query = query + "\(key)=\(value)&"
            }

            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.query = query
            request = URLRequest(url: components.url!, cachePolicy: req.cachePolicy, timeoutInterval: req.timeout)
        }

        request!.allHTTPHeaderFields = req.headers
        request!.httpMethod = req.method.rawValue

        return request!
    }
}
