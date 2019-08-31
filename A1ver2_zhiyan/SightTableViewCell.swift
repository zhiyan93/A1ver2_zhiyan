//
//  SightTableViewCell.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 30/8/19.
//  Copyright © 2019 steven liu. All rights reserved.
//

import UIKit

class SightTableViewCell: UITableViewCell {

    @IBOutlet weak var sightImage: UIImageView!
    @IBOutlet weak var sightName: UILabel!
    
    @IBOutlet weak var sightDesc: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
