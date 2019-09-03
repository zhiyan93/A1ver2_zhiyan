//
//  DetailViewController.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 2/9/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var sightName: UITextField!
    
    @IBOutlet weak var sightImage: UIImageView!
    
    @IBOutlet weak var sightDesc: UITextView!
    
  //  @IBOutlet weak var backBtn: UIButton!
    // @IBOutlet weak var mapBtn: UIBarButtonItem!
    
   //  @IBOutlet weak var bar: UINavigationItem!
    var selectedSight : SightEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        }
     
        
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



