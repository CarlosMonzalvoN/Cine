//
//  DescriptionCell.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 10/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {
    @IBOutlet weak var descriptionTag: UILabel!

    static func heightForCell(withString string: String, withWidth width: CGFloat) -> CGFloat {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width - 40, height: 500))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        label.text = string
        label.font = UIFont(name: "System", size: 17)
        view.addSubview(label)
        label.numberOfLines = 0
        label.sizeToFit()
        return label.frame.height + 50
    }

    func update(with movie: MovieModel) {
        descriptionTag.text = movie.overview
    }
}
