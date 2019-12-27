//
//  EntryCell.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//
//  FUNCTION: Sets up the cell on the main screen with its attributes

import UIKit

class EntryCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var descriptionLabelBottomConstraint: NSLayoutConstraint!
    
    
    func setDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        let formattedDate = Array(dateFormatter.string(from: date))
        
        titleLabel.text = String(formattedDate.dropLast(6))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withDate date: Date, description: String, photo: UIImage?, status: String?, location: String?) {
        
        setDate(date: date)
        descriptionLabel.text = description
        
        
        // Photo Implementation
        if photo != nil {
            mainImageView.isHidden = false
            mainImageView.image = photo
            mainImageView.layer.cornerRadius = 40
            mainImageView.layer.masksToBounds = true
            
        } else {
            mainImageView.image = #imageLiteral(resourceName: "icn_image")
        }
        
        
        // Status Implementation
        if let status = status {
            let statusEnum = Status(rawValue: status)
            statusIcon.isHidden = false
            
            switch statusEnum {
            case .happy: statusIcon.image = #imageLiteral(resourceName: "icn_happy")
            case .average: statusIcon.image = #imageLiteral(resourceName: "icn_average")
            case .bad: statusIcon.image = #imageLiteral(resourceName: "icn_bad")
            case .none:
                statusIcon.isHidden = true
            }
            
        } else {
            statusIcon.isHidden = true
        }
        
        
        // Location implementation
        if let location = location {
            locationLabel.isHidden = false
            locationIcon.isHidden = false
            locationLabel.text = location
        } else {
            locationLabel.isHidden = true
            locationIcon.isHidden = true
        }
    }
}
