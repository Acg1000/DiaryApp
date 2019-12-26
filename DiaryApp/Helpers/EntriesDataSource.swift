//
//  EntriesDataSource.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/21/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class EntriesDataSource: NSObject, UITableViewDataSource {
    private let tableView: UITableView
    private let fetchedResultsController: EntriesFetchedResultsController
    
    init(fetchRequest: NSFetchRequest<Entry>, managedObjectContext context: NSManagedObjectContext, tableView: UITableView) {
        self.tableView = tableView
        self.fetchedResultsController = EntriesFetchedResultsController(request: fetchRequest, context: context)
        super.init()
        
        self.fetchedResultsController.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        cell.setDate(date: entry.date)
        cell.descriptionLabel.text = entry.entryDescription
        
        // Photo Implementation
        if entry.photo != nil {
//            let croppingSize = CGSize(width: 80, height: 80)

            cell.mainImageView.isHidden = false
            cell.mainImageView.image = entry.photo
//            cell.mainImageView.image = entry.photo?.resizeAndRotate(to: croppingSize, withOrientation: .right)
            cell.mainImageView.layer.cornerRadius = 40
            cell.mainImageView.layer.masksToBounds = true
            
        } else {
            cell.mainImageView.image = #imageLiteral(resourceName: "icn_image")
        }
        
        // Status Implementation
        if let status = entry.status {
            let statusEnum = Status(rawValue: status)
            cell.statusIcon.isHidden = false

            
            switch statusEnum {
            case .happy: cell.statusIcon.image = #imageLiteral(resourceName: "icn_happy")
            case .average: cell.statusIcon.image = #imageLiteral(resourceName: "icn_average")
            case .bad: cell.statusIcon.image = #imageLiteral(resourceName: "icn_bad")
            case .none:
                cell.statusIcon.isHidden = true
            }
            
        } else {
            cell.statusIcon.isHidden = true
        }
        
        
        // Location implementation
        if let location = entry.location {
            cell.locationLabel.isHidden = false
            cell.locationIcon.isHidden = false
            cell.locationLabel.text = location
        } else {
            cell.locationLabel.isHidden = true
            cell.locationIcon.isHidden = true
//            cell.locationLabel.removeFromSuperview()
//            cell.locationIcon.removeFromSuperview()
//
//            if (cell.descriptionLabel.bounds.height) >= 80 {
//                cell.descriptionLabelBottomConstraint.constant = 16
//
//            } else {
//                cell.mainImageView.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1, constant: 16))
//
//            }
            
        }
        
        return cell
    }
}


extension EntriesDataSource: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}


extension EntriesDataSource {
    var entries: [Entry] {
        guard let objects = fetchedResultsController.sections?.first?.objects as? [Entry] else {
            return []
        }
        
        return objects
    }
}
