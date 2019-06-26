//
//  MapViewController.swift
//  Deno
//
//  Created by WSR on 25/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    @IBOutlet var btns: [UIButton]!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var bookView: UIView!
    var carId = 0
    var mode = "Minute"
    
    var userLocation: CLLocation!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        
        print(Int(Date().timeIntervalSince1970))
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
        
        fetchData()
    }
    
    func fetchData() {
        guard let url = URL(string: "http://cars.areas.su/cars") else { return }
        
        Alamofire.request(url, method: .get).validate().responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print(json)
                do {
                    let cars = try JSONDecoder().decode([Car].self, from: response.data!)
                    self.addAnntotation(cars: cars)
                } catch {
                    print(error)
                }
               
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addAnntotation(cars: [Car]) {
        for car in cars {
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(car.lat)!), longitude: CLLocationDegrees(Double(car.long)!))
              annotation.title = car.model
              annotation.subtitle  = car.id
//            annotation.image = art.image
            
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    @IBAction func booking(_ sender: Any) {
        guard let url = URL(string: "http://cars.areas.su/book") else { return }
        
        
        let params: Parameters = ["idCar" : String(carId) , "modePay" : mode, "timeNow" : Int(Date().timeIntervalSince1970), "token" : UserDefaults.standard.string(forKey: "Token")]

        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                
                UserDefaults.standard.set(json["notice"]["idBook"].stringValue, forKey: "idBook")
                print(json)
              self.performSegue(withIdentifier: "Timer", sender: self)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func minute(_ sender: Any) {
        mode = "Minute"
    }
    
    @IBAction func hour(_ sender: Any) {
        mode = "Hour"
    }
    
    @IBAction func day(_ sender: Any) {
        mode = "Day"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnClick(_ sender: UIButton) {
        
        for btn in btns {
            btn.backgroundColor = UIColor(red: 52/255, green: 58/255, blue: 80/255, alpha: 1)
        }
        
        sender.backgroundColor = UIColor(red: 255/255, green: 185/255, blue: 0, alpha: 1)
    }
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        userLocation = locations.last
        
        
        let region = MKCoordinateRegion(center: userLocation!.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        carId = Int(((view.annotation?.subtitle)!)!)!
        bookView.isHidden = false
        mapView.removeOverlays(mapView.overlays)
        view.image = UIImage(named: "selectedCar")
        carName.text = view.annotation?.title!
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: view.annotation!.coordinate))
        request.requestsAlternateRoutes = true
        request.transportType = .walking
        
        let direction = MKDirections(request: request)
        direction.calculate { (response, error) in
            guard let response = response else {
                let alert = UIAlertController(title: "Rout cant be build", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            for rout in response.routes {
                self.mapView.addOverlay(rout.polyline)
                self.mapView.setVisibleMapRect(rout.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        bookView.isHidden = true
        view.image = UIImage(named: "car-yellow")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        render.strokeColor = .blue
        render.lineWidth = 2
        return render
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation.title == "My Location" {
            return nil
        }

        let identifier = "marker"
        var view: MKAnnotationView
   


        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier){
            dequeuedView.annotation = annotation
            view = dequeuedView as! MKAnnotationView
        } else {

            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)

            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.image = UIImage(named: "car-yellow")

//            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 200)))
//
//            if let url = URL(string: anno.image) {
//                do {
//                    let data = try Data(contentsOf: url)
//
//                    let image = UIImage(data: data)
//                    view.leftCalloutAccessoryView = imageView
//                    imageView.image = image
//                } catch {
//                    print(error)
//                }
//            }






            //

//            let detailLabel = UILabel()
//            detailLabel.numberOfLines = 0
//            detailLabel.font = detailLabel.font.withSize(12)
//            detailLabel.text = anno.subtitle
//            view.detailCalloutAccessoryView = detailLabel

            //                let vw = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 400))
            //                vw.backgroundColor = .black
            //                vw.addSubview(textView)
            //                view.detailCalloutAccessoryView = imageView


        }
        return view
    }
    
    
    
    //    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //        let location = view.annotation
    //
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
