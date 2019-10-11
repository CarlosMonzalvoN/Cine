//
//  FoodBillCell.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 10/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit

class FoodBillCell: UITableViewCell {
    @IBOutlet weak var foodIconView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var cuantityTF: UITextField!

    func update(with foodItem: FoodModel, andCuantity cuantity: Int) {
        foodNameLabel.text = foodItem.name
        cuantityTF.text = String(cuantity)
        guard let foodImageURL = foodItem.image else { return }
        foodIconView.downloadImageFrom(Url: foodImageURL)
    }
}

