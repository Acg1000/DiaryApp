//
//  EntriesFetchedResultsController.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/21/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import CoreData

class EntriesFetchedResultsController: NSFetchedResultsController<Entry> {
    init(request: NSFetchRequest<Entry>, context: NSManagedObjectContext) {
        super.init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetch()
    }
    
    func fetch() {
        do {
            try performFetch()
        } catch {
            fatalError()
        }
    }
}

