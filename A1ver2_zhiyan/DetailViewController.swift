//
//  DetailViewController.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 2/9/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate ,DatabaseListener{
    func onSightListChange(change: DatabaseChange, sightsDB: [SightEntity]) {
    
    }
    
   
   
    @IBOutlet weak var sightName: UITextField!
    
    @IBOutlet weak var sightImage: UIImageView!
    
    @IBOutlet weak var sightDesc: UITextView!
    
    @IBOutlet weak var locMap: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    //  @IBOutlet weak var backBtn: UIButton!
    // @IBOutlet weak var mapBtn: UIBarButtonItem!
    
   //  @IBOutlet weak var bar: UINavigationItem!
    var selectedSight : SightEntity?
    
    weak var addSightDelegate: AddSightDelegate?
    weak var databaseController : DatabaseProtocol?  //coredata
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController   //coredata
        
        
        
          locMap.delegate = self
        
        // Do any additional setup after loading the view.
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
       
        
        changeValue()
        if selectedSight != nil {
        getAddressFromLatLon(pdblLatitude: selectedSight!.latitude!, withLongitude: selectedSight!.longitude!)
        }
       // print(selectedSight!.name, "detail1 \n")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
        
    }
    
    var listenerType = ListenerType.sight
   
  //  @IBAction func backBtn(_ sender: Any) {
//        let homeScreen = storyboard?.instantiateViewController(withIdentifier: "homeScreen") as! HomeViewController
//        present(homeScreen, animated: true, completion: nil)
//    }
    
    
    func changeValue()  {
        //let homeScreen = storyboard?.instantiateViewController(withIdentifier: "homeScreen") as! HomeViewController
      //  homeScreen.sightSelectDelegate = self
        if selectedSight != nil {
            let tapedSight = selectedSight!
         //    bar.title = tapedSight.name
            
            sightName.text = tapedSight.name
            sightDesc.text = tapedSight.desc
            sightImage.image = UIImage(data: tapedSight.image! as Data)
             addSightAnnotation(sight: tapedSight)
             if let lat = Double(tapedSight.latitude!), let lon = Double(tapedSight.longitude!) {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
             zoomToLocation(with: coordinate)
        }
    }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyLocAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MyLocAnnotation")
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
       
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        configureDetailView(annotationView: annotationView!)
        
        return annotationView
    }
    
    func configureDetailView(annotationView: MKAnnotationView) {
        let width = 150
        let height = 100
        
        let snapshotView = UIView()
        let views = ["snapshotView": snapshotView]
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(150)]", options: [], metrics: nil, views: views))
        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(100)]", options: [], metrics: nil, views: views))
        
        let options = MKMapSnapshotter.Options()
        options.size = CGSize(width: width, height: height)
        options.mapType = .satelliteFlyover
        options.camera = MKMapCamera(lookingAtCenter: annotationView.annotation!.coordinate, fromDistance: 250, pitch: 65, heading: 0)
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if snapshot != nil {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                imageView.image = snapshot!.image
                snapshotView.addSubview(imageView)
            }
        }
        
        annotationView.detailCalloutAccessoryView = snapshotView
    }
    
    private func zoomToLocation(with coordinate : CLLocationCoordinate2D) {
        
        let zoomRegion = MKCoordinateRegion(center: coordinate,latitudinalMeters: 500,longitudinalMeters: 500)
        locMap.setRegion(locMap.regionThatFits(zoomRegion), animated: true)
    }
    
    private func addSightAnnotation(sight: SightEntity) {
        let myAnnotation = MKPointAnnotation()
        myAnnotation.title = sight.name
        //myAnnotation.subtitle = sight.desc
        if let lat = Double(sight.latitude!), let lon = Double(sight.longitude!) {
            myAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            print("invalid coordinate")
            return
        }
        
        locMap.addAnnotation(myAnnotation)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editSightSegue" {
            let destination = segue.destination as! EditSightViewController
           // destination.editSightDelegate = self
            destination.sight = selectedSight
    }
        
    }
    
    // https://stackoverflow.com/questions/41358423/swift-generate-an-address-format-from-reverse-geocoding
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    
                    if pm.subThoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality!
                    }
                   // print(addressString)
                    self.addressLabel.text = addressString
                }
        })
        
    }
}



    


 



