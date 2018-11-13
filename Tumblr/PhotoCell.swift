//
//  PhotoCell.swift
//  Tumblr
//
//  Copyright © 2018 jmaciel. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet weak var tumblrLabel: UILabel!
    
    
    @IBOutlet weak var tumblrImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
