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
        configureBackground()
    }

    func configureBackground() {
        guard let movie = movie, let urlString = CineAppManager.shared.moviePosterFullPath(forMovie: movie, isThumbnail: false) else { return }
        movieBackgroundView.downloadImageFrom(Url: urlString)
        movieBackgroundView.contentMode = .scaleAspectFill
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
        guard let cellType = TicketsViewCells(rawValue: indexPath.row) else { return 0 }

        switch cellType {
        case .title:
           return 248
        case .description:
            guard let movieDescription = movie?.overview else { return 0 }
            let height = DescriptionCell.heightForCell(withString: movieDescription, withWidth: self.view.frame.width)
            return height
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



