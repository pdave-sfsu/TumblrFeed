//
//  PhotosViewController.swift
//  TumblrFeed
//
//  Created by Poojan Dave on 1/15/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [NSDictionary] = []
    let refreshControl = UIRefreshControl()
    var isMoreDataLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 240

        // Do any additional setup after loading the view.
        refreshControl.addTarget(self, action: #selector(fetchPosts), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchPosts()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
            }
        }
    }
    
    func fetchPosts() {
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
        });
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotosCell
        
        cell.selectionStyle = .none
        
        let post = posts[indexPath.row]
        
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageURLString = (photos[0].value(forKeyPath: "original_size.url") as? String)!
            
            let imageURL = URL(string: imageURLString)
            
            cell.photoImageView.setImageWith(imageURL!)
        }
        
        return cell
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        var vc = segue.destination as! PhotoDetailViewController
        
        var indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
        let post = posts[(indexPath?.row)!]
        
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageURLString = (photos[0].value(forKeyPath: "original_size.url") as? String)!
            
            let imageURL = URL(string: imageURLString)
            
            vc.photoURL = imageURL
            
        }
        
    }
    
}
