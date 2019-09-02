//
//  DetailViewController.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 2/9/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, SightSelectDelegate {

    
    @IBOutlet weak var sightName: UITextField!
    
    @IBOutlet weak var sightImage: UIImageView!
    
    @IBOutlet weak var sightDesc: UITextView!
    
    @IBOutlet weak var mapBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func mapBtn(_ sender: Any) {
        let homeScreen = storyboard?.instantiateViewController(withIdentifier: "homeScreen") as! HomeViewController
        homeScreen.sightSelectDelegate = self
        present(homeScreen, animated: true, completion: nil)
    }
    
    func didSightSelect(_ tapedSight: SightEntity) {
        sightName.text = tapedSight.name
        sightDesc.text = tapedSight.desc
        sightImage.image = UIImage(data: tapedSight.image! as Data)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

