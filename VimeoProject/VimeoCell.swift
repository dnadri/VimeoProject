//
//  VimeoCell.swift
//  VimeoProject
//
//  Created by David Nadri on 9/18/16.
//  Copyright © 2016 David Nadri. All rights reserved.
//

import UIKit

class VimeoCell: UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var numberOfPlaysLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    
//    let videoTitleLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.text = ""
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupViews() {
//        addSubview(videoTitleLabel)
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": videoTitleLabel]))
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": videoTitleLabel]))
//    }
    
}
