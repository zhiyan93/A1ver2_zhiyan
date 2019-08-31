//
//  Sight.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 30/8/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import UIKit

class Sight: NSObject {

    var image : UIImage
    var name : String
    var desc : String
    var lat : String
    var lon : String

    
    init(image: UIImage,name : String,desc: String,lat : String, lon : String) {
        self.image = image
        self.name = name
        self.desc = desc
        self.lat = lat
        self.lon = lon
    }
}
