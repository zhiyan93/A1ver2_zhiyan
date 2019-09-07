//
//  NewSightViewController.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 30/8/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import UIKit
import MapKit

protocol AddSightDelegate : AnyObject {
    func addSight(newSight : Sight) -> Bool
}

class NewSightViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,UITextViewDelegate {

   // weak var addSightDelegate: AddSightDelegate?
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var sightDesc: UITextView!
    @IBOutlet weak var sightName: UITextField!
     var sightLat: String?
     var sightLon: String?
    @IBOutlet weak var sightImage: UIImageView!
    @IBOutlet weak var sightIcon: UITextField!
    
    @IBOutlet weak var AddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        // Do any additional setup after loading the view.
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        sightName.delegate = self
        sightDesc.delegate = self
        AddressTextField.delegate = self
        AddressTextField.text = "Melbourne"
       // sightLat.delegate = self
       // sightLon.delegate = self
        
    }
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
     var locationFormAdd : CLLocationCoordinate2D?  //
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last!
        currentLocation = location.coordinate
    }
    
    @IBAction func currentLocBtn(_ sender: Any) {
        if let currentLocation = currentLocation {
            sightLat = "\(currentLocation.latitude)"
            sightLon = "\(currentLocation.longitude)"
            getAddressFromLatLon(pdblLatitude: sightLat!, withLongitude: sightLon!)
        }
        else {
            let alertController = UIAlertController(title: "Location Not Found", message: "The location has not yet been determined.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func confirmAddBtn(_ sender: Any) {
        _ = setGeoCode(address: AddressTextField.text ?? "Melbourne" )
        
    }
    @IBAction func selectIconBtn(_ sender: Any) {
         showActionSheet()
    }
    @IBAction func addSightBtn(_ sender: Any) {
        
        if self.locationFormAdd == nil {
            displayMessage(title: "invalid location address !", message: "please click the Confirm first")
            return
        }
        
        if sightName.text != "" && sightDesc.text != "" && sightImage.image != nil{
            let name = sightName.text!
            let desc = sightDesc.text!
            let image = sightImage.image!
           // let lat = sightLat
          //  let lon = sightLon
            let lat : String = String(self.locationFormAdd!.latitude) //lantitude!
            let lon :  String = String(self.locationFormAdd!.longitude)//longitude!
            let icon = sightIcon.text!
           // let sight = Sight(image: image, name: name, desc: desc, lat: lat, lon: lon,icon: icon)
          //  let _ = addSightDelegate!.addSight(newSight: sight)
            let _ = databaseController!.addSight(name: name, desc: desc, image: image, lat: lat, lon: lon, icon: icon)
    
            navigationController?.popViewController(animated: true)
            return
        }
        var errorMsg = "Please ensure all fields are filled:\n"
        if sightName.text == "" {
            errorMsg += "- Must provide a name\n"
        }
        if sightDesc.text == "" {
            errorMsg += "- Must provide description"
        }
        displayMessage(title: "Not all fields filled", message: errorMsg)
        
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
        
        sightImage.image = pickedImage
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    func getAddress() {
//    let geocoder = CLGeocoder()
//    geocoder.reverseGeocodeLocation(CLLocation) { (placemarksArray, error) in
//
//    if (placemarksArray?.count)! > 0 {
//
//    let placemark = placemarksArray?.first
//    let number = placemark!.subThoroughfare
//    let bairro = placemark!.subLocality
//    let street = placemark!.thoroughfare
//
//    self.addressLabel.text = "\(street!), \(number!) - \(bairro!)"
//    }
//    }
//    }
    
   private func setGeoCode ( address: String) -> CLLocationCoordinate2D? {
        let geocoder = CLGeocoder()
        var coordinates:CLLocationCoordinate2D?
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error as Any)
                self.locationFormAdd = nil
                self.AddressTextField.backgroundColor = UIColor.red
            }
            if let placemark = placemarks?.first {
                coordinates = placemark.location!.coordinate
                
                //print(coordinates?.latitude)
                self.locationFormAdd = coordinates
               self.AddressTextField.backgroundColor = UIColor.white
            }
        })
        
        return coordinates
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
                    self.AddressTextField.text = addressString
                }
        })
        
    }

}

extension NewSightViewController: CLLocationManagerDelegate {
    
}



