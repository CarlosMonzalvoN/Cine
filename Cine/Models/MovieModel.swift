//
//  MovieModel.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 09/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import Foundation

struct MovieModel: Codable {
    var poster_path: String?
    var adult: Bool!
    var overview: String!
    var release_date: String!
    var id: Int!
    var original_title: String!
    var title: String!

    var screeningTimes: [MovieScreeningTime]? = []

    func clone(addingTestScreeningTimes screeningTimes: [MovieScreeningTime]) -> MovieModel {
        let movie = MovieModel(poster_path: poster_path, adult: adult, overview: overview, release_date: release_date, id: id, original_title: original_title, title: title, screeningTimes: screeningTimes)
        return movie
    }

}

struct Dates: Codable {
    var maximum: String!
    var minimum: String!
}

struct MovieServiceResultModel: Codable {
    var page: Int!
    var results: [MovieModel]!
    var dates: Dates?
    var total_pages: Int!
    var total_results: Int!
}



