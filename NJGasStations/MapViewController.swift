//
//  MapViewController.swift
//  NJGasStations
//
//  Created by Joseph T. Furmanowski on 10/17/22.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    
    let gasStationsModel = NJGasStationModel.shared
    
    var gasStationAnnotations:[GasStationAnnotation] = []
    var selectedGasStation: GasStation?

    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        myMapView.showsUserLocation = true
        myMapView.delegate = self
        myMapView.mapType = .standard
        checkLocationServices()
        
        /* When the map first loads, fill the gasStationAnnotations array with the annotations and add them to the map view.
         We only want to call this function once. */
        addGasStations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* If a gas station was chosen from the map, this makes sure that its annotation is up-to-date.
         By adding the annotation back to the map view, the price change (if any) will be reflected in the gas station's annotation. */
        if let gasStation = selectedGasStation {
            myMapView.addAnnotation(GasStationAnnotation(gasStation.latitude!, longitude: gasStation.longitude!, title: gasStation.name!, subTitle: gasStation.city!, id: gasStation.id!))
            selectedGasStation = nil // We are done dealing with this gas station.
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    // Location Manager methods
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // user did not turn on location services
        }
    }
    
    func checkLocationAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        switch authorizationStatus {
        case .authorizedWhenInUse:
            myMapView.showsUserLocation = true
            followUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show alert
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func followUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
            myMapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let myLocation = locations.last {
            _ = MKCoordinateRegion(center: myLocation.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
            print(myLocation)
            /* The code below puts the user's location at the center of region every time there is a location change.
             We want the user to be able to move the map around without it always jumping back to their location. */
            // myMapView.setRegion(region, animated: true)
        }
    }
    
    // Add annotations of gas stations to the map view
    func addGasStations() {
        for gasStation in gasStationsModel.gasStations {
            let annotation = GasStationAnnotation(gasStation.latitude!, longitude: gasStation.longitude!, title: gasStation.name!, subTitle: gasStation.city!, id: gasStation.id!)
            gasStationAnnotations.append(annotation)
        }
        
        myMapView.addAnnotations(gasStationAnnotations)
    }
    
    // Delegate methods to provide annotationView for mapView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKMarkerAnnotationView()
        
        let identifier = "gasStation"
        
        guard annotation is GasStationAnnotation else { return nil }
        
        let thisAnnotation = annotation as! GasStationAnnotation
        
        annotationView.clusteringIdentifier = nil
        
        if let dequedAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            annotationView = dequedAnnotation
        } else {
            if let thisGasStation = gasStationsModel.findGasStation(withID: thisAnnotation.gasStationID) {
                annotationView.markerTintColor = thisGasStation.price! > 5.00 ? UIColor.red : UIColor.green
                annotationView.glyphImage = UIImage(systemName: "fuelpump.fill")
                annotationView.animatesWhenAdded = true
                annotationView.canShowCallout = true
                annotationView.calloutOffset = CGPoint(x: -5.0, y: 5.0)
                
                let logoFileName = thisGasStation.logo
                let gasStationButton = UIButton (frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 50.0, height: 50.0)))
                
                if let logoFilePath = Bundle.main.path (forResource: "/logos/" + logoFileName!, ofType: "") {
                    gasStationButton.setBackgroundImage(UIImage(contentsOfFile: logoFilePath), for: UIControl.State())
                }
                
                annotationView.leftCalloutAccessoryView = gasStationButton
                
                let mapButton = UIButton (frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 50.0, height: 50.0)))
                mapButton.setBackgroundImage(UIImage(systemName: "car"), for: UIControl.State())
                annotationView.rightCalloutAccessoryView = mapButton
            }
        }
        return annotationView
    }
    
    // Accessory callout
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let thisLocation = view.annotation as! GasStationAnnotation
        if view.rightCalloutAccessoryView == control {
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            // invoke the Apple Maps application with current locations coordinate and address set as MKMapItem
            thisLocation.mapItem().openInMaps(launchOptions: launchOptions)
        } else if view.leftCalloutAccessoryView == control {
            selectedGasStation = gasStationsModel.findGasStation(withID: thisLocation.gasStationID)
            
            // The selected annotation is removed from the map temporarily and re-added to the map in viewWillAppear.
            myMapView.removeAnnotation(thisLocation)
            performSegue(withIdentifier: "mapToGasStationDetailsSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! GasStationDetailViewController
        dvc.gasStationID = selectedGasStation?.id
    }
    
}
