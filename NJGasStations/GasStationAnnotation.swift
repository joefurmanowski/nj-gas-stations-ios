//
//  GasStationAnnotation.swift
//  NJGasStations
//
//  Created by Joseph T. Furmanowski on 10/17/22.
//

import Foundation
import MapKit
import Contacts

class GasStationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var gasStationID: Int
    
    init (_ latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, subTitle: String, id: Int) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.title = title
        self.subtitle = subTitle
        self.gasStationID = id
    }
    
    func mapItem() -> MKMapItem {
        let destinationTitle = title! + ", " + subtitle! // name, city
        let addrDict = [CNPostalAddressCityKey: destinationTitle]
        let placemark = MKPlacemark (coordinate: coordinate, addressDictionary: addrDict)
        let mapItem = MKMapItem (placemark: placemark)
        return mapItem
        
    }
    
}
