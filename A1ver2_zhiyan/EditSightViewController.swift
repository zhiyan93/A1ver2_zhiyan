//
//  EditSightViewController.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 5/9/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import UIKit
import MapKit



class EditSightViewController:  UIViewController , UIImagePickerControllerDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,UITextViewDelegate  {

    weak var databaseController: DatabaseProtocol?
    weak var addSightDelegate: AddSightDelegate?
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var descTV: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var sightIcon: UITextField!
    // @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    var lantitude: String?
    
      var longitude: String?
    
    var sight : SightEntity?
   
    var locationFormAdd : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeValue()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        name.delegate = self
        descTV.delegate  = self
        addressTextField.delegate = self
        if (lantitude != nil) && (longitude != nil) {
        getAddressFromLatLon(pdblLatitude: lantitude!, withLongitude: longitude!)
        }
     //   lantitude.delegate = self
    //    longitude.delegate = self
        
       
    }
    
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last!
        currentLocation = location.coordinate
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // https://stackoverflow.com/questions/26600359/dismiss-keyboard-with-a-uitextview
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
  
    @IBAction func currentLocBtn(_ sender: Any) {
        if let currentLocation = currentLocation {
            lantitude = "\(currentLocation.latitude)"
            longitude = "\(currentLocation.longitude)"
            
            getAddressFromLatLon(pdblLatitude: lantitude!, withLongitude: longitude!)
        }
        else {
            let alertController = UIAlertController(title: "Location Not Found", message: "The location has not yet been determined.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func checkAddBtn(_ sender: Any) {
        _ = setGeoCode(address: addressTextField.text ?? "Melbourne" )
    }
    @IBAction func saveBtn(_ sender: Any) {
       
     //
        if self.locationFormAdd == nil {
            displayMessage(title: "invalid location address !", message: "please click the Confirm first")
            return
        }
          if name.text != "" && descTV.text != "" && imageView.image != nil{
            let name = self.name.text!
            let desc = descTV.text!
            let image = imageView.image!
            
            
            let lat : String = String(self.locationFormAdd!.latitude) //lantitude!
            let lon :  String = String(self.locationFormAdd!.longitude)//longitude!
            let icon = sightIcon.text ?? "museum"
            //    sightIcon.text!
            // let sight = Sight(image: image, name: name, desc: desc, lat: lat, lon: lon,icon: icon)
            //  let _ = addSightDelegate!.addSight(newSight: sight)
            
          let newSight =  databaseController!.addSight(name: name, desc: desc, image: image, lat: lat, lon: lon, icon: icon)
            
            //print(newSight.name, "edit \n")
            databaseController!.deleteSight(sight: sight!)
    //       editSightDelegate?.editSight(newSight: newSight)
           // showDetailScreen()
            let detailScreen = storyboard?.instantiateViewController(withIdentifier: "Sight Detail") as! DetailViewController
            detailScreen.selectedSight = newSight
            present(detailScreen, animated: true, completion: nil)
            return
        }
        
       
        
        var errorMsg = "Please ensure all fields are filled:\n"
        if name.text == "" {
            errorMsg += "- Must provide a name\n"
        }
        if descTV.text == "" {
            errorMsg += "- Must provide descriptions"
        }
        displayMessage(title: "Not all fields filled", message: errorMsg)
        
    }
    
    func setGeoCode ( address: String) -> CLLocationCoordinate2D? {
        let geocoder = CLGeocoder()
        var coordinates:CLLocationCoordinate2D?
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error as Any)
                self.locationFormAdd = nil
                self.addressTextField.backgroundColor = UIColor.red
            }
            if let placemark = placemarks?.first {
                coordinates = placemark.location!.coordinate
               
             //   print(coordinates?.latitude, " 1")
                self.locationFormAdd = coordinates
                self.addressTextField.backgroundColor = UIColor.white
            }
        })
        
        return coordinates
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
   //     editSightDelegate?.editSight(newSight: sight!)
        let detailScreen = storyboard?.instantiateViewController(withIdentifier: "Sight Detail") as! DetailViewController
        detailScreen.selectedSight = sight!
        present(detailScreen, animated: true, completion: nil)
     //   showDetailScreen()
        return
    }
    
    @IBAction func cameraBtn(_ sender: Any) {
        
        let imagePicker: UIImagePickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .savedPhotosAlbum
        }
        
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    func showDetailScreen() {
        let detailScreen = storyboard?.instantiateViewController(withIdentifier: "Sight Detail") as! DetailViewController
        present(detailScreen, animated: true, completion: nil) }
    
   
    
    @IBAction func selectIconBtn(_ sender: Any) {
        showActionSheet()
    }
    
    
    func displayMessage(title: String, message: String) {
        // Setup an alert to show user details about the Person
        // UIAlertController manages an alert instance
        let alertController = UIAlertController(title: title, message: message, preferredStyle:
            UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler:
            nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageView.image = pickedImage
    }
    
//    func showActionSheet() {
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let cancel  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let icon1 = UIAlertAction(title: "icon1", style: .default) { action in self.sightIcon.text = "icon1"}
//        let icon2 = UIAlertAction(title: "icon2", style: .default) { action in self.sightIcon.text = "icon2"}
//        let icon3 = UIAlertAction(title: "icon3", style: .default) { action in self.sightIcon.text = "icon3"
//            
//        }
//        actionSheet.addAction(cancel)
//        actionSheet.addAction(icon1)
//        actionSheet.addAction(icon2)
//        actionSheet.addAction(icon3)
//        
//        present(actionSheet,animated: true, completion: nil)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func changeValue()  {
        //let homeScreen = storyboard?.instantiateViewController(withIdentifier: "homeScreen") as! HomeViewController
        //  homeScreen.sightSelectDelegate = self
        if sight != nil {
            let editSight = sight!
            //    bar.title = tapedSight.name
            
            name.text = editSight.name
            descTV.text = editSight.desc
            imageView.image = UIImage(data: editSight.image! as Data)
            self.lantitude = editSight.latitude
            self.longitude = editSight.longitude
            //addSightAnnotation(sight: tapedSight)
          //  if let lat = Double(tapedSight.latitude!), let lon = Double(tapedSight.longitude!) {
         //       let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        //        zoomToLocation(with: coordinate)
            }
        }
    
    // https://stackoverflow.com/questions/41358423/swift-generate-an-address-format-from-reverse-geocoding
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        
        let lon: Double = Double("\(pdblLongitude)")!
        
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
                    self.addressTextField.text = addressString
                }
        })
        
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let museum = UIAlertAction(title: "museum", style: .default) { action in self.sightIcon.text = "museum"}
        let tank = UIAlertAction(title: "tank", style: .default) { action in self.sightIcon.text = "tank"}
        let rocket = UIAlertAction(title: "rocket", style: .default) { action in self.sightIcon.text = "rocket"}
        let navy = UIAlertAction(title: "navy", style: .default) { action in self.sightIcon.text = "navy"}
        let school = UIAlertAction(title: "school", style: .default) { action in self.sightIcon.text = "school"}
        let music = UIAlertAction(title: "music", style: .default) { action in self.sightIcon.text = "music"}
        
        actionSheet.addAction(cancel)
        actionSheet.addAction(museum)
        actionSheet.addAction(tank)
        actionSheet.addAction(rocket)
        actionSheet.addAction(navy)
        actionSheet.addAction(school)
        actionSheet.addAction(music)
        present(actionSheet,animated: true, completion: nil)
    }
    }



