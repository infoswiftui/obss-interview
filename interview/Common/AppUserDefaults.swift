//
//  AppUserDefaults.swift
//  interview
//
//  Created by macbook on 6.05.2021.
//

import Foundation

struct AppUserDefaults {}

extension AppUserDefaults {
  struct MovieInfo {
    
    static var movieList: [Movie] {
      get {
        return UserDefaults.standard.decode(for: [Movie].self, using: Keys.Movies.movieList) ?? []
      }
      set(newValue) {
        UserDefaults.standard.encode(for: newValue, using: Keys.Movies.movieList)
      }
    }
  }
}

extension UserDefaults {
    func decode<T: Codable>(for type: T.Type, using key: String) -> T? {
        let defaults = UserDefaults.standard
        guard let data = defaults.object(forKey: key) as? Data else { return nil }
        let decodedObject = try? PropertyListDecoder().decode(type, from: data)
        return decodedObject
    }
    func encode<T: Codable>(for type: T, using key: String) {
      let defaults = UserDefaults.standard
      let encodedData = try? PropertyListEncoder().encode(type)
      defaults.set(encodedData, forKey: key)
      defaults.synchronize()
    }
}
