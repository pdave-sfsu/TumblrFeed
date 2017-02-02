//
//  PhotoDetailViewController.swift
//  TumblrFeed
//
//  Created by Poojan Dave on 2/1/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    var photoURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postImageView.setImageWith(photoURL!)

        // Do any additional setup after loading the view.
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
