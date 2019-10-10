//
//  UIImage+extension.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 09/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImageFrom(Url urlString:String) {
        self.alpha = 0
        guard let url = URL(string: urlString) else { return }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: url) { (data, urlResponse, responseError) in
            guard let imageData = data, responseError == nil else  { return }
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, animations: {
                    self.alpha = 1
                    self.image = UIImage(data: imageData)
                })
            }
            }.resume()
    }
}
