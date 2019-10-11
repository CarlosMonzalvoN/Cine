//
//  TitleCell.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 10/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit


class TitleCell: UITableViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func update(with movie: MovieModel) {
        titleLabel.text = movie.title
        guard let imageUrl = CineAppManager.shared.moviePosterFullPath(forMovie: movie, isThumbnail: true) else {  return }
        thumbnailView.downloadImageFrom(Url: imageUrl)
    }
}
