//
//  PhotoDetailViewController.swift
//  TumblrFeed
//
//  Created by Poojan Dave on 2/1/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

//PhotoDetailViewController is the detail view
class PhotoDetailViewController: UIViewController {
    
    //ImageView
    @IBOutlet weak var postImageView: UIImageView!
    
    //Property that stores the url for the photo
    var photoURL: URL?

    //viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets the imageView to the photo
        postImageView.setImageWith(photoURL!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
