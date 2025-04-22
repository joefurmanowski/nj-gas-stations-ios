//
//  GasStationDetailViewController.swift
//  NJGasStations
//
//  Created by Joseph T. Furmanowski on 10/6/22.
//

import UIKit

class GasStationDetailViewController: UIViewController {

    let gasStationsModel = NJGasStationModel.shared
    var gasStationID: Int?
    var selectedGasStation: GasStation?

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedGasStation = gasStationsModel.findGasStation(withID: gasStationID!)
        self.title = selectedGasStation?.name
        sliderValue.text = String(format: "%.2f", (selectedGasStation?.price! ?? "0.00"))
        slider.value = Float((selectedGasStation?.price ?? 0.00) * 100)
    }

  
    @IBAction func sliderValueSet(_ sender: UISlider) {
        let value = sender.value/100.00
        sliderValue.text = String (format: "%.2f", value)
    }
    
    @IBAction func updateGasStationDetails(_ sender: UIButton) {
        let newPrice = Double(sliderValue.text!)
        gasStationsModel.updateGasStation(withID: gasStationID!, newPrice: newPrice!)
        self.navigationController?.popViewController(animated: true)
    }

}
