//
//  FoodCollectionViewCell.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 09/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageFood : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    func update(with foodItem: FoodModel) {
        guard let foodURL = foodItem.image else { return }
        imageFood.downloadImageFrom(Url: foodURL)
        imageFood.contentMode = .scaleAspectFill
        nameLabel.text = foodItem.name
        priceLabel.text = foodItem.price
    }
}
