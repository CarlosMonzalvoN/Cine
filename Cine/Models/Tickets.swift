//
//  Tickets.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 09/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import Foundation

class MovieTicket {
    var isForChild: Bool?
    var movie: MovieModel?
    var screeningTime: MovieScreeningTime?
    var seat: String?
    var location: Location?

    init() {}

    func createNewTicketFromCurrentData() -> MovieTicket {
        let ticket = MovieTicket()
        ticket.isForChild = isForChild
        ticket.movie = movie
        ticket.screeningTime = screeningTime
        ticket.seat = seat
        ticket.location = location
        return ticket
    }
}

struct Location {
    var lat: String?
    var lon: String?
}



