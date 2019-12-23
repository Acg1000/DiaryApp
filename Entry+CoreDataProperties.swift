//
//  Entry+CoreDataProperties.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/21/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        request.sortDescriptors = [sortDescriptor]
        return request

    }

    @NSManaged public var date: Date
    @NSManaged public var entryDescription: String
    @NSManaged public var location: String?
    @NSManaged public var photoData: Data?
    @NSManaged public var status: String?

}

extension Entry {
    static var entityName: String {
        return String(describing: Entry.self)
    }
    
    @nonobjc class func with(_ description: String, status: Status?, location: String?, photo: UIImage?, in context: NSManagedObjectContext) -> Entry {
        
        print("in the with function")
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: Entry.entityName, into: context) as! Entry
        
        entry.date = Date()
        entry.entryDescription = description
        
        if let photo = photo {
            photo.jpegData(compressionQuality: 1.0)
        } else {
            entry.photoData = nil
        }
        
        if let status = status {
            entry.status = status.rawValue
        } else {
            entry.status = nil
        }
        
        entry.location = location
        return entry
    }
}

extension Entry {
    var photo: UIImage? {
        guard let photoData = photoData else { return nil }
        return UIImage(data: photoData)
    }
}