//
//  EntryCell.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

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

}
