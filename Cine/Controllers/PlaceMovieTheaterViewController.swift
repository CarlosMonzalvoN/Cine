//
//  CinesViewController.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 10/7/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit

class PlaceMovieTheaterViewController: UIViewController {

    @IBOutlet weak var imagePlace: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Anda en Cines")
        imagePlace.image = UIImage(named: "mapa")
        // Do any additional setup after loading the view.
    }

}
