//
//  BoletosViewController.swift
//  Cine
//
//  Created by Pedro Carlos Monzalvo Navarro on 09/10/19.
//  Copyright © 2019 Pedro Carlos Monzalvo Navarro. All rights reserved.
//

import UIKit

class TicketsViewController: UIViewController {

    @IBOutlet weak var ticketAdultTextField: UITextField!
    @IBOutlet weak var ticketChildTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    var totalA = 0.0 , totalC = 0.0
    @IBOutlet weak var picketHour: UIPickerView!
    var movie: MovieModel?
    var screeningTimes: [MovieScreeningTime] = []
    var selectedScreeningTime: MovieScreeningTime?
    @IBOutlet weak var selectedMovieHour: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var movieBackgroundView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = "0.0"
        screeningTimes = MovieScreeningTime.getMovieScreeningTime(Int.random(in: 3...10))
        autoSelectTime()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        autoSelectTime()
    }

    func autoSelectTime() {
        guard screeningTimes.count > 0 else { return }
        pickerView(picketHour, didSelectRow: 0, inComponent: 0)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepperAdult(_ senderAdult: UIStepper) {
        ticketAdultTextField.text = Int(senderAdult.value).description
        totalA = (senderAdult.value * 70)
        totalLabel.text = "\(totalA + totalC)"
        
    }
    @IBAction func stepperChild(_ senderChild: UIStepper) {
        ticketChildTextField.text = Int(senderChild.value).description
        totalC = (senderChild.value * 60)
        totalLabel.text = "\(totalA + totalC)"
    }
}

extension TicketsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return screeningTimes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let screening = screeningTimes[row]
        return screening.timeStamp
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedScreeningTime = screeningTimes[row]
        selectedMovieHour.text = selectedScreeningTime?.timeStamp ?? ""
    }

}


