//
//  PhotoViewController.swift
//  Tumblr
//
//  Copyright © 2018 jmaciel. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var posts: [[String: Any]] = []
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PhotoViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        retrievePhotos()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        retrievePhotos()
    }
    
    func retrievePhotos(){
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let post = posts[indexPath.section]
        
        if let photos = post["photos"] as? [[String: Any]] {
            
            // 1.
            let photo = photos[0]
            // 2.
            let originalSize = photo["original_size"] as! [String: Any]
            // 3.
            let urlString = originalSize["url"] as! String
            // 4.
            let url = URL(string: urlString)
            
            cell.tumblrImageView.af_setImage(withURL: url!)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
        
        let cell = sender as! UITableViewCell
        
        let indexPath = tableView.indexPath(for: cell)!
        
        photoDetailsViewController.post =  posts[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        // Add a UILabel for the date here
        // Use the section number to get the right URL
        // let label = ...
        
        let label = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 30))
        let post = posts[section]
        label.text = post["date"] as? String
        headerView.addSubview(label)
        
        return headerView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
