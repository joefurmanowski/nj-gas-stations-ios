//
//  NJGasStationModel.swift
//  NJGasStations
//
//  Created by Joseph T. Furmanowski on 10/5/22.
//

import Foundation

struct GasStation: Codable {
    var id: Int?
    var name: String?
    var city: String?
    var price: Double?
    var latitude: Double?
    var longitude: Double?
    var logo: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "OBJECTID"
        case name = "SITE_NAME"
        case city = "CITY"
        case price = "PRICE"
        case latitude = "LATITUDE"
        case longitude = "LONGITUDE"
    }
    
}

class NJGasStationModel {
    
    static let shared = NJGasStationModel()
    
    var gasStations:[GasStation] = []
    
    let gasStationLogos:[String:String] = [
        "76":"76.png",
        "bp":"bp.jpg",
        "chevron":"chevron.jpg",
        "citgo":"citgo.jpeg",
        "delta":"delta.jpeg",
        "exxonmobil":"exxonmobil.jpeg",
        "exxon":"exxon.png",
        "getty":"getty.png",
        "gulf":"gulf.jpeg",
        "lukoil":"lukoil.jpeg",
        "marathon":"marathon.png",
        "mobil":"mobil.jpg",
        "philips":"philips.jpg",
        "quick chek":"quickchek.jpeg",
        "shell":"shell.jpg",
        "speedway":"speedway.png",
        "sunoco":"sunoco.jpeg",
        "texaco":"texaco.png",
        "wawa":"wawa.jpeg",
    ]
    
    init() {
        readGasStationsData()
        setGasStationLogos()
    }
    
    func readGasStationsData() {
        if let filename = Bundle.main.path(forResource: "NJGasStations", ofType: "json") {
            do {
                let jsonStr = try String(contentsOfFile: filename)
                let jsonData = jsonStr.data(using: .utf8)!
                gasStations = try! JSONDecoder().decode([GasStation].self, from: jsonData)
            }
            catch {
                print("This file could not be loaded")
            }
        }
    }
    
    func getGasStationLogo(brandName: String) -> String {
        let logoKeys = Array(gasStationLogos.keys)
        var logo = "other.jpg" // default logo (used in case we do not have a specific logo)
        
        if let index = logoKeys.firstIndex(where: { brandName.lowercased().contains($0) }) {
            logo = gasStationLogos[logoKeys[index]]!
        }
        
        return logo
    }
    
    func setGasStationLogos() {
        var index = 0 // we need to keep track of index so we can mutate GasStation objects in the array
        for gasStation in gasStations {
            gasStations[index].logo = getGasStationLogo(brandName: gasStation.name!)
            index += 1
        }
    }
    
    func findGasStation (withID id: Int) -> GasStation? {
        var gasStation: GasStation?
        if let index = gasStations.firstIndex(where: {$0.id == id}) {
            gasStation = gasStations[index]
        }
        return gasStation
    }
    
    func updateGasStation (withID id: Int, newPrice price: Double) {
        if let index = gasStations.firstIndex(where: {$0.id == id}) {
            gasStations[index].price = price
        }
    }
    
}

