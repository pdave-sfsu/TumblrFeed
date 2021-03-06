//
//  PhotosCell.swift
//  TumblrFeed
//
//  Created by Poojan Dave on 1/15/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

//PhotoCell represents the cell in the tableView of the PhotosViewController
class PhotosCell: UITableViewCell {

    //photoImageView
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
