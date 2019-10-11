//
//  TicketCell.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 10/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit

protocol TicketCellProtocol {
    func ticketView(ticketsAvailable: [MovieTicket])
}

class TicketCell: UITableViewCell {
    @IBOutlet weak var picketHour: UIPickerView!
    @IBOutlet weak var ticketAdultTextField: UITextField!
    @IBOutlet weak var ticketChildTextField: UITextField!
    @IBOutlet weak var selectedMovieHour: UILabel!
    var totalA = 0.0 , totalC = 0.0

    var ticket = MovieTicket()
    var delegate: TicketCellProtocol?

    var purchasedAdultTickets: [MovieTicket] = []
    var purchasedChildTickets: [MovieTicket] = []

    func add(adultTickets: Int){
        purchasedAdultTickets = []
        for _ in 0..<adultTickets {
            ticket.isForChild = false
            purchasedAdultTickets.append(ticket)
        }
    }

    func add(childTickets: Int){
        purchasedChildTickets = []
        for _ in 0..<childTickets {
            ticket.isForChild = true
            purchasedChildTickets.append(ticket)
        }
    }

    func update(with movie: MovieModel) {
        ticket.movie = movie
        picketHour.delegate = self
        picketHour.dataSource = self
        autoSelectTime()

    }
}

extension TicketCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let movie = ticket.movie, let movieCount = movie.screeningTimes?.count else {
            return 0
        }
        return movieCount
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let movie = ticket.movie else {
            return
        }
        ticket.screeningTime = movie.screeningTimes?[row]
        selectedMovieHour.text = ticket.screeningTime?.timeStamp ?? ""
    }

    func autoSelectTime() {
        guard let movie = ticket.movie, (movie.screeningTimes?.count ?? 0) > 0 else { return }
        pickerView(picketHour, didSelectRow: 0, inComponent: 0)
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let movie = ticket.movie, let screening = movie.screeningTimes?[row] else {
            return NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }

        return NSAttributedString(string: screening.timeStamp, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }



    @IBAction func stepperAdult(_ sender: UIStepper) {
        ticketAdultTextField.text = Int(sender.value).description
        add(adultTickets: Int(sender.value))
        delegate?.ticketView(ticketsAvailable: purchasedChildTickets + purchasedAdultTickets)
    }
    @IBAction func stepperChild(_ sender: UIStepper) {
        ticketChildTextField.text = Int(sender.value).description
        add(childTickets: Int(sender.value))
        delegate?.ticketView(ticketsAvailable: purchasedChildTickets + purchasedAdultTickets)
    }
}

