//
//  MainPageController.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import UIKit
import CoreData

class MainPageController: UITableViewController {

    var container: NSPersistentContainer!
    var entries: [Entry] = []
    let dateFormatter = DateFormatter()
    let context = CoreDataStack().managedObjectContext
    
    @IBOutlet weak var entryTextField: UITextField!

    
    lazy var dataSource: EntriesDataSource = {
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        return EntriesDataSource(fetchRequest: request, managedObjectContext: context, tableView: self.tableView)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.dataSource = dataSource
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entry")
//
//        do {
//            entries = try managedContext.fetch(fetchRequest)
//
//        } catch let error as NSError {
//            print("could not fetch. \(error), \(error.userInfo)")
//        }
//    }

//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return entries.count
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let entry = entries[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryCell
//
////        let date = entry.value(forKey: "date") as? Date
////        dateFormatter.dateStyle = .full
//        let date = entry.date
//        cell.setDate(date: date)
//
////        let description = entry.value(forKey: "entryDescription") as? String
//        let description = entry.entryDescription
//        cell.descriptionLabel.text = description
//
////        if let date = date, let description = description {
////            cell.titleLabel.text = dateFormatter.string(from: date)
////            cell.descriptionLabel.text = description
////
////            return cell
////
////        } else {
////            fatalError()
////        }
//        return cell
//    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        if let text = entryTextField.text {
//            save(description: text)
            
            print("save pressed")
            
            let _ = Entry.with(text, status: .happy, location: nil, photo: nil, in: context)
            context.saveChanges()
            tableView.reloadData()
        }
    }
    
//    func save(description: String) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let entity = NSEntityDescription.entity(forEntityName: "Entry", in: managedContext)!
//
//        let entry = NSManagedObject(entity: entity, insertInto: managedContext)
//
//        entry.setValue(Date(), forKey: "date")
//        entry.setValue(description, forKey: "entryDescription")
//
//        do {
//            try managedContext.save()
//            entries.append(entry)
//
//        } catch let error as NSError {
//            print("Count not save. \(error), \(error.userInfo)")
//        }
//    }
}
