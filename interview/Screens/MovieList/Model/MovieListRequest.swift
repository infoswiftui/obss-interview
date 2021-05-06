//
//  MovieListRequest.swift
//  interview
//
//  Created by macbook on 6.05.2021.
//

import Foundation

final class MovieListRequest: Requestable {
    
    typealias ResponseType = MoviesData
    
    private var nextPage : Int

    init(nextPage: Int) {
        self.nextPage = nextPage
    }
    
    var baseUrl: URL {
        return URL(string: BASE_URL)!
    }
    
    var endpoint: String {
        return "popular?language=en-US&\(apiKey)&page=\(String(self.nextPage))"
    }
    
    var method: Network.Method {
        return .get
    }
    
    var query: Network.QueryType {
        return .json
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var headers: [String : String]? {
        return defaultJSONHeader
    }
    
    var timeout: TimeInterval {
        return 20.0
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }
}
