//
//  MovieListViewModel.swift
//  interview
//
//  Created by macbook on 6.05.2021.
//

import Foundation

class MovieListViewModel {
  
  var moviesData: MoviesData?
  
  var movieList: [Movie] {
    get {
      let movies = AppUserDefaults.MovieInfo.movieList
      return movies
    }
    set(newValue) {
      let containValue = newValue.allSatisfy(AppUserDefaults.MovieInfo.movieList.contains)
      if !containValue {
        AppUserDefaults.MovieInfo.movieList = newValue
      }
    }
  }
  
  var filteredMovieList: [Movie] = []
  var nextPage: Int = 1

  var updateMovieList: ((_ moviesData: [Movie]) -> Void)?
  
  func movies(_ searching: Bool) -> [Movie] {
    return searching ? filteredMovieList : movieList
  }
  
  // MARK: - REST Call
  func fetchMovies(with page: Int) {
      Network.request(req: MovieListRequest(nextPage: page)) { (result) in
          switch result {
          case .success(let response):
            DispatchQueue.main.async {
              self.moviesData = response
              if let movies = response.results {
                  self.movieList.append(contentsOf: movies)
                self.updateMovieList?(self.movieList)
              }
            }
          case .failure(let err):
            print(err ?? "Failed to load")
          }
      }
  }
  
}
