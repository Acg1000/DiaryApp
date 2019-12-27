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
    private let fetchedResultsController: NSFetchedResultsController<Entry>
    
    init(fetchRequest: NSFetchRequest<Entry>, managedObjectContext context: NSManagedObjectContext, tableView: UITableView) {
        self.tableView = tableView
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Fetch request or context was invalid.")
        }
        
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
        cell.configure(withDate: entry.date, description: entry.entryDescription, photo: entry.photo, status: entry.status, location: entry.location)
        
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
