//
//  EntriesDataSource.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/21/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//
//  FUNCTION: Serves as the DATASOURCE for the MainPageController

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

            cell.mainImageView.isHidden = false
            cell.mainImageView.image = entry.photo
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
