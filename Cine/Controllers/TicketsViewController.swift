//
//  BoletosViewController.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 09/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit

enum TicketsViewCells: Int {
    case title = 0, description, ticketInfo
}

struct TicketsViewCellsIdentifiers {
    static var title = "titleCell"
    static var description = "descCell"
    static var ticketInfo = "infoCell"
}

class TicketsViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var movie: MovieModel?
    @IBOutlet weak var movieBackgroundView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = "0.0"
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }


}

extension TicketsViewController: TicketCellProtocol, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = TicketsViewCells(rawValue: indexPath.row) ?? .title

        switch cellType {
        case .title:
           return 248
        case .description:
            return 93
        case .ticketInfo:
            return 360
        }
    }
    func ticketView(ticketsAvailable: [MovieTicket]) {
        var total: Float = 0.0
        for ticket in ticketsAvailable {
            let isForChild = ticket.isForChild ?? false
            total += isForChild ? 60.0 : 70.0
        }
        totalLabel.text = "\(total)"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = TicketsViewCells(rawValue: indexPath.row) ?? .title
        var cell: UITableViewCell?
        guard let movie = movie else {
            return UITableViewCell()
        }

        switch cellType {
        case .title:
            cell = tableView.dequeueReusableCell(withIdentifier: TicketsViewCellsIdentifiers.title)
            (cell as? TitleCell)?.update(with: movie)
        case .description:
            cell = tableView.dequeueReusableCell(withIdentifier: TicketsViewCellsIdentifiers.description)
            (cell as? DescriptionCell)?.update(with: movie)
        case .ticketInfo:
            cell = tableView.dequeueReusableCell(withIdentifier: TicketsViewCellsIdentifiers.ticketInfo)
            (cell as? TicketCell)?.update(with: movie)
            (cell as? TicketCell)?.delegate = self
        }

        return cell ?? UITableViewCell()
    }
}


class TitleCell: UITableViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func update(with movie: MovieModel) {
        titleLabel.text = movie.title
        guard let imageUrl = CineAppManager.shared.moviePosterFullPath(forMovie: movie, isThumbnail: true) else {  return }
        thumbnailView.downloadImageFrom(Url: imageUrl)
    }
}

class DescriptionCell: UITableViewCell {
    @IBOutlet weak var descriptionTag: UILabel!

    func update(with movie: MovieModel) {
        descriptionTag.text = movie.overview
    }
}

protocol TicketCellProtocol {
    func ticketView(ticketsAvailable: [MovieTicket])
}

class TicketCell: UITableViewCell {
    @IBOutlet weak var picketHour: UIPickerView!
    @IBOutlet weak var ticketAdultTextField: UITextField!
    @IBOutlet weak var ticketChildTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
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

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let movie = ticket.movie, let screening = movie.screeningTimes?[row] else {
            return ""
        }

        return screening.timeStamp
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

