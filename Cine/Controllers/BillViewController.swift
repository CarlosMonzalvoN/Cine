//
//  CuentaViewController.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 10/7/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit

class BillViewController: UIViewController {

    @IBOutlet weak var moviePosterView: UIImageView!
    @IBOutlet weak var movieTitleLable: UILabel!
    @IBOutlet weak var movieScreeningTimeLabel: UILabel!
    @IBOutlet weak var childTicketsLabel: UILabel!
    @IBOutlet weak var adultTicketLabel: UILabel!
    @IBOutlet weak var noOrderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieBackgroundView: UIImageView!
    @IBOutlet weak var totalButton: UIButton!

    var orderManager = OrderManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Anda en Cuenta")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }

    func updateView() {
        noOrderView.alpha = self.orderManager.movie != nil ? 0 : 1
        let tickets = orderManager.tickets
        let ticketNumbers = orderManager.getTicketSpecifiedNumbers()
        guard let movie = orderManager.movie, let moviePosterUrl = CineAppManager.shared.moviePosterFullPath(forMovie: movie, isThumbnail: true), let anyTicket = tickets.first else { return }
        movieBackgroundView.downloadImageFrom(Url: moviePosterUrl)
        movieTitleLable.text = movie.title
        moviePosterView.downloadImageFrom(Url: moviePosterUrl)
        movieScreeningTimeLabel.text = anyTicket.screeningTime?.timeStamp
        childTicketsLabel.text = "Boletos de niños: \(ticketNumbers.childNumber)"
        adultTicketLabel.text = "Boletos de adulto: \(ticketNumbers.adultNumber)"
        totalButton.setTitle("Pagar \(orderManager.getTotalPrice()) MXN", for: .normal)
        tableView.reloadData()
    }

    @IBAction func deleteCart() {
        self.presentUserActionRequestAlert(withMessage: "Estas seguro de borrar tu orden?") { (_) in
            if let movie = OrderManager.shared.movie {
                let tickets = OrderManager.shared.tickets
                CineAppManager.shared.updateMovieAvailability(adding: tickets.count, toMovie: movie)
            }
            OrderManager.shared.purgeOrder()
            self.updateView()
        }
    }

    @IBAction func buy() {
        self.presentUserActionRequestAlert(withMessage: "Estas seguro de comprar tu orden. El costo total es de " + "\(orderManager.getTotalPrice()) MXN") { (_) in
            OrderManager.shared.purgeOrder()
            self.updateView()
            self.presentDefaultAlert(withMessage: "Excelente presenta este codigo en taquillas: " + OrderManager.shared.generateAnID())
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BillViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foodItem = orderManager.getUniqueFoodItems()[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "foodBillCell") as? FoodBillCell else {
            return UITableViewCell()
        }
        cell.update(with: foodItem, andCuantity: orderManager.getNumberOfSameFoodItemOfKind(kind: foodItem.name ?? ""))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let foodArray = orderManager.getUniqueFoodItems()
        return foodArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
