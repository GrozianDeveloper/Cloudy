//
//  MapVC.swift
//  Cloudy
//
//  Created by Bogdan Grozyan on 18.01.2021.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var keyForRequest = UserDefaults.standard.string(forKey: "key")
    
    var locationNameForNext = ""
    
    var coordsForCarousel  = [String]()
    
    var pages: [locationParam] = (UserDefaults.standard.array(forKey: "pages") as? [locationParam] ?? [locationParam(name: "", lat: "", lon: "")])
    

        //UserDefaults.standard.removeObject(forKey: "pages")
        //UserDefaults.standard.set(pages, forKey: "pages")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decodePages()
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
    }
    
    func decodePages() {
        if let pagesw = UserDefaults.standard.data(forKey: "pages") {
            let decoder = JSONDecoder()
            if let decodedPages = try? decoder.decode([locationParam].self, from: pagesw) {
                self.pages = decodedPages
            }
        }
    }
    func encodePages() {
        let a = locationParam(name: locationNameForNext, lat: coordsForCarousel.first ?? "", lon: coordsForCarousel.last ?? "")
        if a.name != "" && a.lat != "" && a.lon !=  "" {
        pages.append(a)
        let encoder = JSONEncoder()
        if let encodedPages = try? encoder.encode(pages) {
            UserDefaults.standard.set(encodedPages, forKey: "pages")
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAllPagesVC" {
                encodePages()
        }
    }

    @objc func longTap(sender: UIGestureRecognizer){
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            addAnnotation(location: locationOnMap)
        }
    }

    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        
        annotation.coordinate = location
        //let geocoder = CLGeocoder()
        //let clLocation = CLLocation(latitude: location.latitude, longitude: location.latitude)
        //geocoder.reverseGeocodeLocation(clLocation, completionHandler: { [self] placemarks, error in
           // if error == nil {
                //let firstLocation = placemarks?[0]
                CurrentWeatherbitByCoords(with: "\(location.latitude)", lon: "\(location.latitude)")
                
                
                let lat = "\(location.latitude)"
                let lon = "\(location.longitude)"
                self.coordsForCarousel = [lat, lon]
                annotation.title = self.locationNameForNext
            //}
        //})
    
        self.mapView.addAnnotation(annotation)
    }
    //MARK: Request for location name
    func CurrentWeatherbitByCoords(with lat: String, lon: String) {
        var myURLComponents = URLComponents()
        myURLComponents.scheme = "https"
        myURLComponents.host = "api.weatherbit.io"
        myURLComponents.path = "/v2.0/current"
        myURLComponents.queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "key", value: keyForRequest)
        ]
        
        URLSession.shared.dataTask(with: myURLComponents.url!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("somethingWentWrongCurrent")
                return
            }
            var json: LocationName?
            do {
                json = try JSONDecoder().decode(LocationName.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            guard let result = json else {
                return
            }
            self.locationNameForNext = result.data.first!.city_name
        }).resume()
    }
    
    }



//extension ViewController: MKMapViewDelegate{
//
//func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//    guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
//
//    let reuseId = "pin"
//    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//
//    if pinView == nil {
//        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        pinView!.canShowCallout = true
//        pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
//        pinView!.pinTintColor = UIColor.black
//    }
//    else {
//        pinView!.annotation = annotation
//    }
//    return pinView
//}
//
//func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//    print("tapped on pin ")
//}
//
//func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//    if control == view.rightCalloutAccessoryView {
//        if let doSomething = view.annotation?.title! {
//           print("do something")
//        }
//    }
//  }
//}
