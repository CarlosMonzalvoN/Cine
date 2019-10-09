//
//  AnimationViewController.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 10/5/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit
import Lottie

class AnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        animation()
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { (Timer) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "cuenta")
            self.present(controller, animated: true, completion: nil)
        }
    }
    func animation(){
        let animationView = AnimationView(name: "cinema-animation")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        
        view?.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.play()
    }


}
