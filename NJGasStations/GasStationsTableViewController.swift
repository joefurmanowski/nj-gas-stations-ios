//
//  GasStationsTableViewController.swift
//  NJGasStations
//
//  Created by Joseph T. Furmanowski on 10/5/22.
//

import UIKit

class GasStationsTableViewController: UITableViewController {
    
    let gasStationsModel = NJGasStationModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.00
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gasStationsModel.gasStations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gasStationCell", for: indexPath) as! GasStationTableViewCell

        // Configure the cell...
        let thisGasStation = gasStationsModel.gasStations[indexPath.row]
        
        cell.name.text = thisGasStation.name
        cell.city.text = thisGasStation.city
        cell.price.text = String(format: "$%.2f", thisGasStation.price!)
        
        let logoFileName = thisGasStation.logo
        
        if let logoFilePath = Bundle.main.path (forResource: "/logos/" + logoFileName!, ofType: "") {
            cell.logo.image = UIImage(contentsOfFile: logoFilePath)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailsSegue", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destination_VC = segue.destination as! GasStationDetailViewController
        let id = gasStationsModel.gasStations[tableView.indexPathForSelectedRow!.row].id
        destination_VC.gasStationID = id
    }

}
