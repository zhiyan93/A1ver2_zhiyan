//
//  HomeViewController.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 1/9/19.
//  Copyright © 2019 steven liu. All rights reserved.
//
// reference: https://www.youtube.com/watch?v=SayMogu530A&list=PLwh-fNUJO9t56qDQP8HzbNjVuNkGzZT5c


import UIKit
import MapKit

class HomeViewController: UIViewController {

    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        configureLocationServices()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func configureLocationServices() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if  status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    private func beginLocationUpdates(locationManager : CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLatestLocation(with coordinate : CLLocationCoordinate2D) {
        
        let zoomRegion = MKCoordinateRegion(center: coordinate,latitudinalMeters: 10000,longitudinalMeters: 10000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    private func addAnnotations() {
        let myAnnotation = MKPointAnnotation()
        myAnnotation.title = "Parliament House of Victoria"
        myAnnotation.coordinate = CLLocationCoordinate2D(latitude: -37.832380, longitude: 144.960430)
        
        mapView.addAnnotation(myAnnotation)
    }
}

extension HomeViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let latestLocation = locations.first else { return}
       
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnnotations()
        }
        
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
    
}

extension HomeViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        
        if annotation.title == "Parliament House of Victoria" {
            //annotationView?.image = resizeImage(iniImage: #imageLiteral(resourceName: "Public Record Office Victoria"))
           
            
            annotationView?.image = #imageLiteral(resourceName: "Victoria's Parliament House")
            annotationView?.frame.size = CGSize(width: 60, height: 40)
        
        }  else if annotation === mapView.userLocation {
                annotationView?.image = #imageLiteral(resourceName: "avatar")
            annotationView?.frame.size = CGSize(width: 50, height: 50)
            }
        
        annotationView?.canShowCallout = true
        
        return annotationView
        }
    
        
    func resizeImage(iniImage : UIImage) -> UIImage {
        // Resize image
        let pinImage = iniImage
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        return resizedImage!
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}
