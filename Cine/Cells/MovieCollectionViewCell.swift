//
//  PeliculaCollectionViewCell.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 08/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagenPelicula: UIImageView!

    func update(with movie: MovieModel) {
        guard let imageUrl = CineAppManager.shared.moviePosterFullPath(forMovie: movie, isThumbnail: false) else {
            // default image
            return
        }
        imagenPelicula.downloadImageFrom(Url: imageUrl)
    }
}

enum CineImageSizes: String {
    case thumbnail = "w200"
    case detail = "w500"
}


