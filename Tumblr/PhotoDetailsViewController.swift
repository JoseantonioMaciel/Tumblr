//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Copyright © 2018 jmaciel. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var tumblrImageView: UIImageView!
    var post: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            if let photos = post["photos"] as? [[String: Any]] {
                let photo = photos[0]
                let originalSize = photo["original_size"] as! [String: Any]
                let urlString = originalSize["url"] as! String
                let url = URL(string: urlString)
                
                tumblrImageView
                    .af_setImage(withURL: url!)
            }
        }
    }
}
