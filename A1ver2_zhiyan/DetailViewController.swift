//
//  DetailViewController.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 2/9/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var sightName: UITextField!
    
    @IBOutlet weak var sightImage: UIImageView!
    
    @IBOutlet weak var sightDesc: UITextView!
    
    @IBOutlet weak var locMap: MKMapView!
    //  @IBOutlet weak var backBtn: UIButton!
    // @IBOutlet weak var mapBtn: UIBarButtonItem!
    
   //  @IBOutlet weak var bar: UINavigationItem!
    var selectedSight : SightEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
          locMap.delegate = self
          changeValue()
        // Do any additional setup after loading the view.
     
    }
 
   
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
        
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



