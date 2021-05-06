//
//  MovieListResponse.swift
//  interview
//
//  Created by macbook on 6.05.2021.
//

import Foundation

public struct MoviesData: Codable {
    let results: [Movie]?
    let page, totalResults, totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

public struct Movie: Codable, Hashable {
    let voteCount: Int?
    let id: Int?
    let originalTitle: String?
    let title: String?
    let overview: String?
    let posterPath: String?
    var starred: Bool?
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id
        case originalTitle
        case title
        case overview
        case posterPath = "poster_path"
        case starred
    }
}
