//
//  OrderManager.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 11/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit


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
