//
//  CineAppManager.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 09/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import Foundation

class CineAppManager {

    static let shared = CineAppManager()

    private let key = "5aa9f9d04ab72a31b70f56ef9db4b81e"
    private let lang = "en-US"
    private let baseUrl = "https://api.themoviedb.org/3"
    private let imageBaseUrl = "https://image.tmdb.org/t/p/"

    var movies: [MovieModel] = []

    func updateIsNecessary() -> Bool {
        return !(movies.count > 0)
    }

    func updateMovies(_ completion: @escaping (Bool)->()) {
        let endpoint = "/movie/popular?"
        let params = "api_key=\(self.key)&language=\(self.lang)"
        guard let url = URL(string: baseUrl + endpoint + params), updateIsNecessary() else {
            // url couldnot be constructed or update is not necessary error handling
            completion(false)
            return
        }

        // Con esto parceamos el json
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in

            guard error == nil else {
                // server error handling
                completion(false)
                return
            }

            let jsonDecoder = JSONDecoder()

            guard let data = data, let moviesData = try? jsonDecoder.decode(MovieServiceResultModel.self, from: data) else {
                // parsing error handling
                completion(false)
                return
            }

            self.movies = moviesData.results
            self.addTestingScreeningTimes(enabled: true)
            completion(true)
        }
        task.resume()
    }

    func addTestingScreeningTimes(enabled: Bool) {
        if enabled {
            var mockMovies: [MovieModel] = []
            for movie in self.movies {
                let mockMovie = movie.clone(addingTestScreeningTimes: MovieScreeningTime.getMovieScreeningTime(Int.random(in: 3...10)))
                mockMovies.append(mockMovie)
            }
            self.movies = mockMovies
        }
    }

    func moviePosterFullPath(forMovie movie: MovieModel, isThumbnail: Bool) -> String?  {
        guard let posterPath = movie.poster_path else { return nil }
        let size: CineImageSizes = isThumbnail ? .thumbnail : .detail
        return imageBaseUrl + size.rawValue + posterPath
    }

}
