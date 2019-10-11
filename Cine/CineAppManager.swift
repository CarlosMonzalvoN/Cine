//
//  CineAppManager.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 09/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import Foundation

enum CineAppService: Int {
    case movies = 0, food
}

class CineAppManager {

    static let shared = CineAppManager()

    private let key = "5aa9f9d04ab72a31b70f56ef9db4b81e"
    private let lang = "en-US"
    private let baseUrl = "https://api.themoviedb.org/3"
    private let gistBaseUrl = "https://gist.githubusercontent.com/CarlosMonzalvoN/"
    private let imageBaseUrl = "https://image.tmdb.org/t/p/"

    var movies: [MovieModel] = []
    var foodMenu: FoodServiceResponseModel?

    lazy var jsonDecoder = JSONDecoder()

    func updateIsNecessary(forService service: CineAppService) -> Bool {
        switch service {
        case .movies:
            return !(movies.count > 0)
        case .food:
            return (foodMenu == nil)
        }
    }

    func updateMovieAvailability(adding availability: Int, toMovie movie: MovieModel){
        for currentMovieIndex in 0..<movies.count {
            if movies[currentMovieIndex].title == movie.title {
                let updatedMovie = movie.clone(addingAvailability: availability)
                movies[currentMovieIndex] = updatedMovie
                break
            }
        }
    }

    func updateFoodMenu(_ completion: @escaping (Bool)->()) {
        let endpoint = "6c79d7b9df0dc349ab4756ce7b5d6a0f/raw/209fe0eb63033f233cd9ac841f260f40ea736d69/foodService.json"
        guard let url = URL(string: gistBaseUrl + endpoint), updateIsNecessary(forService: .food) else {
            completion(false)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(false)
                return
            }
            guard let data = data, let foodData = try? self.jsonDecoder.decode(FoodServiceResponseModel.self, from: data) else {
                // parsing error handling
                completion(false)
                return
            }
            self.foodMenu = foodData
            completion(true)
        }
        task.resume()
    }

    func updateMovies(_ completion: @escaping (Bool)->()) {
        let endpoint = "/movie/popular?"
        let params = "api_key=\(self.key)&language=\(self.lang)"
        guard let url = URL(string: baseUrl + endpoint + params), updateIsNecessary(forService: .movies) else {
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
            guard let data = data, let moviesData = try? self.jsonDecoder.decode(MovieServiceResultModel.self, from: data) else {
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

class OrderManager {

    static var shared = OrderManager()
    var tickets: [MovieTicket] = []
    var movie: MovieModel?
    var foodItems: [FoodModel] = []
    func getTicketSpecifiedNumbers() -> (adultNumber: Int, childNumber: Int) {
        var adultNumber = 0; var childNumber = 0
        for ticket in tickets {
            adultNumber += (ticket.isForChild ?? false) ? 0 : 1
            childNumber += (ticket.isForChild ?? false) ? 1 : 0
        }
        return (adultNumber, childNumber)
    }

    func purgeOrder() {
        tickets = []
        movie = nil
        foodItems = []
    }

    func generateAnID() -> String {
        let cinemaName = "CINETICKET"
        let orderID = Int.random(in: 1000...9999)
        let functionName = movie?.title.capitalized.trimmingCharacters(in: .whitespaces) ?? "NANDERROR"
        return cinemaName + "\(orderID)" + functionName
    }

    func getTotalPrice() -> Float {
        var price: Float = 0.0
        let tickets = getTicketSpecifiedNumbers()
        price += 70.0 * Float(tickets.adultNumber)
        price += 60.0 * Float(tickets.childNumber)

        for item in foodItems {
            price += Float(item.price ?? "") ?? 0
        }
        return price
    }

    func getNumberOfSameFoodItemOfKind(kind: String) -> Int {
        var numberOfSameFoodItem = 0
        for item in foodItems {
            if item.name ?? "" == kind {
                numberOfSameFoodItem += 1
            }
        }
        return numberOfSameFoodItem
    }

    func getUniqueFoodItems() -> [FoodModel] {
        var uniqueFoodItems: [FoodModel] = []
        for item in foodItems {
            var itemWasFoundInUniqueArray = false
            for uniqueItem in uniqueFoodItems {
                if item.name == uniqueItem.name {
                    itemWasFoundInUniqueArray = true
                }
            }
            if !itemWasFoundInUniqueArray {
                uniqueFoodItems.append(item)
            }
        }
        return uniqueFoodItems
    }
}
