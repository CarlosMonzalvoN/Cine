//
//  MovieScreeningTime.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 09/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import Foundation

struct MovieScreeningTime {

    var hour: Int = 0
    var minute: Int = 0

    // This assign a numerical value basing off the timing to later sort it with this value
    var sortValue: Float {
        return (Float(hour) + 1) * 1000 + Float(minute)
    }

    var timeStamp: String {
        let hourString = hour < 10 ? "0\(hour)": "\(hour)"
        let minuteString = minute < 10 ? "0\(minute)": "\(minute)"
        return hourString + ":" + minuteString
    }

    static func random() -> MovieScreeningTime {
        let screening = MovieScreeningTime(hour: Int.random(in: 0...23), minute:Int.random(in: 0...59))
        return screening
    }

    static func getMovieScreeningTime(_ numberOfScreenings: Int)-> [MovieScreeningTime] {
        var screenings: [MovieScreeningTime] = []
        for _ in 0..<numberOfScreenings {
            screenings.append(MovieScreeningTime.random())
        }
        return screenings.sorted {
            $0.sortValue < $1.sortValue
        }
    }
}
