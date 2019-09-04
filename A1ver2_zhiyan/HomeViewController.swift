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
import CoreData

//protocol SightSelectDelegate {
//   func didSightSelect(_ tapedSight : SightEntity)
//}


class HomeViewController: UIViewController, DatabaseListener {

    func onSightListChange(change: DatabaseChange, sightsDB: [SightEntity]) {
        sights = sightsDB
    }
    
  //  var sightSelectDelegate : SightSelectDelegate?
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    var selectedSight : SightEntity?
    var sights : [SightEntity] = []
    weak var databaseController : DatabaseProtocol?
    weak var addSightDelegate: AddSightDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController   //coredata
        
        mapView.delegate = self
        configureLocationServices()
        // Do any additional setup after loading the view.
           //detail page
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     */ override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    var listenerType = ListenerType.sight
    
   
    
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
        
        let zoomRegion = MKCoordinateRegion(center: coordinate,latitudinalMeters: 15000,longitudinalMeters: 15000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    private func addAnnotations() {
//        let myAnnotation = MKPointAnnotation()
//        myAnnotation.title = "Parliament House of Victoria"
//        myAnnotation.coordinate = CLLocationCoordinate2D(latitude: -37.832380, longitude: 144.960430)
        
      //  mapView.addAnnotation(myAnnotation)
        for s in sights {
             addSightAnnotation(sight: s)
        }
       
    }
    
    private func addSightAnnotation(sight: SightEntity) {
        let myAnnotation = MKPointAnnotation()
        myAnnotation.title = sight.name
        myAnnotation.subtitle = sight.desc
        if let lat = Double(sight.latitude!), let lon = Double(sight.longitude!) {
               myAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            print("invalid coordinate")
            return
        }
        
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
        
        
//        if annotation.title == "Parliament House of Victoria" {
//            //annotationView?.image = resizeImage(iniImage: #imageLiteral(resourceName: "Public Record Office Victoria"))
//
//
//            annotationView?.image = #imageLiteral(resourceName: "Victoria's Parliament House")
//            annotationView?.frame.size = CGSize(width: 60, height: 40)
//
//        }  else
        for s in sights {
            if annotation.title == s.name {
               let image = UIImage(data: s.image! as Data)
                annotationView?.image = image
                configureDetailView(annotationView: annotationView!, image: image!)
                configureRightView(annotationView: annotationView!,tagNum: sights.firstIndex(of: s) ?? 0 )
                annotationView?.frame.size = CGSize(width: 60, height: 40)
                break
            }
        }
//        annotationView?.image = #imageLiteral(resourceName: "Victoria's Parliament House")
//        annotationView?.frame.size = CGSize(width: 60, height: 40)
        
            if annotation === mapView.userLocation {
                annotationView?.image = #imageLiteral(resourceName: "avatar")
            annotationView?.frame.size = CGSize(width: 50, height: 50)
            }
        
        annotationView?.canShowCallout = true
        
      
      
        
//        configureDetailView(annotationView: annotationView!)
        return annotationView
        }
    
    func configureDetailView(annotationView: MKAnnotationView, image : UIImage) {
        
        let detailView = UIImageView( image: image)
        
//        let descView = UITextView.init()
//        descView.text = "sfjsklfjdslfjdlsfkjdslfjdkls"
//        detailView.addSubview(descView)
       
        let views = ["snapshotView": detailView]
        detailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(300)]", options: [], metrics: nil, views: views))
        detailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(200)]", options: [], metrics: nil, views: views))
    
        annotationView.detailCalloutAccessoryView = detailView
    }
    
    func configureRightView(annotationView: MKAnnotationView, tagNum : Int){
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.tag = tagNum
        annotationView.rightCalloutAccessoryView = rightButton
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let buttonNum = control.tag
//        let detailScreen = storyboard?.instantiateViewController(withIdentifier: "Sight Detail") as! DetailViewController
//        present(detailScreen, animated: true, completion: nil)
        selectedSight = sights[buttonNum]
     //   print(selectedSight!.name)
//        self.sightSelectDelegate = DetailViewController()
       if selectedSight != nil {
//            sightSelectDelegate?.didSightSelect(selectedSight!)
         //dismiss(animated: true, completion: nil)
        let detailScreen = storyboard?.instantiateViewController(withIdentifier: "Sight Detail") as! DetailViewController
        detailScreen.selectedSight = selectedSight!
            present(detailScreen, animated: true, completion: nil)
    //  dismiss(animated: true, completion: nil)
//    }
        }
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
    
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//
//    }
    
}


  
    


    
   

