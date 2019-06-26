//
//  PictureTableViewCell.swift
//  Picturama
//
//  Created by Duong Dinh on 6/25/19.
//  Copyright © 2019 DuongDH. All rights reserved.
//

import UIKit
import SDWebImage

class PictureTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    static let cellIdentifier = "PictureTableViewCell"
}

// MARK: - Life Cycle
extension PictureTableViewCell {
    
    override func prepareForReuse() {
        configureCell(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pictureImageView.layer.borderColor = UIColor.gray.cgColor
        pictureImageView.layer.borderWidth = 1.0
        pictureImageView.contentMode = .scaleAspectFit
        loadingIndicator.hidesWhenStopped = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// MARK: - Configure cells
extension PictureTableViewCell {
    
    func configureCell(with pictureRecord: Picture?) {
        if let record = pictureRecord {
            loadingIndicator.stopAnimating()
            pictureImageView.isHidden = false
            imageTitleLabel.isHidden = false
            imageTitleLabel?.text = record.tags
            if let previewImageURL = record.previewImageURL {
                pictureImageView?.sd_setImage(with: previewImageURL, completed: nil)
            }
        } else {
            pictureImageView.isHidden = true
            imageTitleLabel.isHidden = true
            loadingIndicator.startAnimating()
        }
    }
}
