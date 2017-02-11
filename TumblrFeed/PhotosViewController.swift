//
//  PhotosViewController.swift
//  TumblrFeed
//
//  Created by Poojan Dave on 1/15/17.
//  Copyright © 2017 Poojan Dave. All rights reserved.
//

import UIKit
//import AFNetworking
import AFNetworking

//import the UITableViewDelegate, UITableViewDataSource, and UIScrollViewDelegate
class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    //tableView outlet
    @IBOutlet weak var tableView: UITableView!
    
    //posts: property of array of NSDictionaries that holds the photos
    var posts: [NSDictionary] = []
    
    //refreshControl
    let refreshControl = UIRefreshControl()
    
    //boolean value to see if more data is loading
    var isMoreDataLoading = false
    
    //An instance of infiniteScrollActivityView
    var loadingMoreView:InfiniteScrollActivityView?

    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the dataSource and delegate to the viewController
        tableView.dataSource = self
        tableView.delegate = self
        
        //setting the height of the cells
        tableView.rowHeight = 240

        //Adding the refreshControl target; Binding the action to the refresh control
        refreshControl.addTarget(self, action: #selector(fetchPosts), for: UIControlEvents.valueChanged)
        
        //Inserting the refreshControl subview
        tableView.insertSubview(refreshControl, at: 0)
        
        //Calling fetchPosts() to retrieve the photos
        fetchPosts()
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }

    //fetchPosts(): Network call to retrieve the photos
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
                        
                        //Parsing through the dictionary
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        //Retrieving the actual post and saving it in posts property
                        self.posts += responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        //Reloading tableViewData
                        self.tableView.reloadData()
                        
                        //RefreshControl: Ending Refreshing
                        self.refreshControl.endRefreshing()
                        
                        //more data is no longer loading, the property is set to false
                        self.isMoreDataLoading = false
                        
                        self.loadingMoreView!.stopAnimating()
                    }
                }
        });
        task.resume()
    }

    //numberOfRowsInSSection: The number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Returning the number of posts
        return posts.count
    }
    
    //cellForRowAt: Creating the content for the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Creating a cell and casting it as a PhotosCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotosCell
        
        //Making sure the cell is not selected
        cell.selectionStyle = .none
        
        //Finding the particular post to display
        let post = posts[indexPath.row]
        
        //Parsing through post dictionary and finding the photo
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            
            //Getting the url of the photo to display
            //Process: Get first photo in the array and then finding the url of the original size
            let imageURLString = (photos[0].value(forKeyPath: "original_size.url") as? String)!
            
            //Coverting the URL to the proper type.
            let imageURL = URL(string: imageURLString)
            
            //Positng the image in the cell
            cell.photoImageView.setImageWith(imageURL!)
        }
        
        return cell
    }
    
    //scrollViewDidScroll(): Called when the the user scrolls
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //If more data is not loading, then find more data
        //If more data is loading, then do nothing
        //Avoids continuously calling this method and making 100s of network calls
        if (!isMoreDataLoading) {
            
            //Get the height of the content
            let scrollViewContentHeight = tableView.contentSize.height
            
            //Get particular location where we want to load more data
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            //If the contentOffset is greater than the threshold AND the user is dragging, then load more data
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                //Change the value to true
                isMoreDataLoading = true
                
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //Call network request to get more posts
                fetchPosts()
            }
        }
    }
    
    //prepareForSegue: Segue to another viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        //Creating an instance of the PhotoDetailViewController
        let vc = segue.destination as! PhotoDetailViewController
        
        //Getting the appropriate index
        var indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
        //Retrieving the proper post using the indexPath
        let post = posts[(indexPath?.row)!]
        
        //Retrieving the proper photo and url
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageURLString = (photos[0].value(forKeyPath: "original_size.url") as? String)!
            
            let imageURL = URL(string: imageURLString)
            
            //Setting the photoURL property in the PhotoDetailViewController to imageURL
            vc.photoURL = imageURL
        }
        
        //Deselects the cell with animation
        tableView.deselectRow(at: indexPath!, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }
    
    func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }
}
