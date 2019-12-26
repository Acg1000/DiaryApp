//
//  CreateEntryController.swift
//  DiaryApp
//
//  Created by Andrew Graves on 12/22/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData



class CreateEntryController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var navigationSaveButton: UIBarButtonItem!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var trashItem: UIBarButtonItem!
    
    var photoPickerManager: PhotoPickerManager!
    let dateFormatter = DateFormatter()
    let imagePickerController = UIImagePickerController()
    var delegate: WasDismissedDelegate?
    lazy var locationManager: LocationManager = {
        return LocationManager(delegate: self, permissionsDelegate: nil)
    }()

    // Creation Variables
    var currentDate = Date()
    var currentLocation: Location? = nil
    var context: NSManagedObjectContext!
    var status: Status? = nil {
        didSet {
            print("STATUS SET TO: \(status)")
        }
    }
    var isEditingEntry = false
    var imagePickerSource: UIImagePickerController.SourceType? = nil
    var image: UIImage? {
        didSet {
            if image != nil {
                imageButton.layer.cornerRadius = 50
                imageButton.layer.masksToBounds = true
//                imageButton.setImage(image?.resized(to: CGSize(width: 50, height: 50)), for: .normal)
                
                imageButton.setImage(image, for: .normal)

                
//                switch imagePickerController.sourceType {
//                case .camera:
//                    imageButton.setImage(image?.resizeAndRotate(to: CGSize(width: 50, height: 50), withOrientation: .right), for: .normal)
//                case .photoLibrary, .savedPhotosAlbum:
//                    imageButton.setImage(image?.resized(to: CGSize(width: 50, height: 50)), for: .normal)
//
//                }
            }
        }
    }
    
    // EDITING VARIABLES
    var editingDateString: String!
    var editingImage: UIImage? = nil
    var editingStatus: Status? = nil
    var editingLocation: String? = nil
    var editingDescription: String!
    var editingEntry: Entry? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Checks to see what the current mode is...
        if isEditingEntry {
            setupViewForEditing()
            trashItem.isEnabled = true
            navigationBarTitle.title = "Editing Entry"
        
        } else {
            setupView()
            trashItem.isEnabled = false
        }
        
        self.photoPickerManager = PhotoPickerManager(presentingViewController: self, delegate: self)
        addLocationButton.setTitle("", for: .disabled)
    }
    
    
    func setupView() {
        dateFormatter.dateStyle = .full
        let formattedDate = Array(dateFormatter.string(from: currentDate))
        dateLabel.text = String(formattedDate.dropLast(6))
    }
    
    func setupViewForEditing() {
        print("Setting up the view for editing")
        // DATE
        dateLabel.text = editingDateString
        
        // IMAGE
        image = editingImage
        
        // DESCRIPTION
        textView.text = editingDescription
        
        // STATUS
        status = editingStatus
        
        if let status = status {
            switch status {
            case .happy: statusImage.image = #imageLiteral(resourceName: "icn_happy")
            case .average: statusImage.image = #imageLiteral(resourceName: "icn_average")
            case .bad: statusImage.image = #imageLiteral(resourceName: "icn_bad")
            }
        }
        
        // LOCATION
        if let editingLocation = editingLocation {
            locationLabel.text = editingLocation
            addLocationButton.setTitle("", for: .normal)
        }
    }
    
    func prepareViewWith(_ entry: Entry) {
        print("preparing the view with attributes")
        isEditingEntry = true
        editingEntry = entry
        
        dateFormatter.dateStyle = .full
        let formattedDate = Array(dateFormatter.string(from: entry.date))
        editingDateString = String(formattedDate.dropLast(6))
        
        editingImage = entry.photo
        editingDescription = entry.entryDescription
        editingLocation = entry.location
        
        if let statusString = entry.status, let status = Status(rawValue: statusString) {
            editingStatus = status
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func didPickCamera() {
        photoPickerManager.presentPhotoPicker(animated: true, for: .camera)
        imagePickerSource = .camera
    }
    
    func didPickLibrary() {
        photoPickerManager.presentPhotoPicker(animated: true, for: .photoLibrary)
        imagePickerSource = .photoLibrary
    }
    
    
    // MARK: Button Functions...
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        
        // Ask the user if they would like to use a camera or pick from their library
        let alertView = UIAlertController(title: "Preferred Action", message: "Would you like to complete this action using the Camera or your Photo Library?", preferredStyle: .actionSheet)
        
        alertView.addAction(UIAlertAction(title: "Camera", style: .default) { action in self.didPickCamera() })
        alertView.addAction(UIAlertAction(title: "Library", style: .default) { action in self.didPickLibrary() })
        present(alertView, animated: true, completion: nil)

    }
    
    // MARK: Save Pressed
    // function for both save buttons
    @IBAction func savePressed(_ sender: Any) {
        guard let description = textView.text else  { return }

        if isEditingEntry {
            if let editingEntry = editingEntry {
                
                // DESCRIPTION
                if description.isEmpty {
                    let alertController = UIAlertController(title: "Invalid description", message: "Please enter a valid description to save this entry.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
                    present(alertController, animated: true, completion: nil)
                } else {
                    editingEntry.setValue(description, forKey: "entryDescription")

                }
                
                // LOCATION
                if let editingLocation = editingLocation {
                    editingEntry.setValue(editingLocation, forKey: "location")
                }
                
                // PHOTODATA
                if let photo = editingImage {
                    editingEntry.setValue(photo.jpegData(compressionQuality: 1.0), forKey: "photoData")
                }
                
                // STATUS
                if let status = editingStatus {
                    editingEntry.setValue(status.rawValue, forKey: "status")
                }
                
                context.saveChanges()
                dismiss(animated: true, completion: nil)
                delegate?.wasDismissed()
            }

            
        } else {
            
            if description.isEmpty {
                let alertController = UIAlertController(title: "Invalid description", message: "Please enter a valid description to save this entry.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                
            } else {
                let entry = Entry.with(description, status: status, location: currentLocation?.placemark, photo: image, in: context)
                print(entry)
                context.saveChanges()
                
                dismiss(animated: true, completion: nil)
                delegate?.wasDismissed()
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.wasDismissed()
    }
    
    @IBAction func trashPressed(_ sender: Any) {
        if let editingEntry = editingEntry {
            
            dismiss(animated: true, completion: nil)
            delegate?.wasDismissed()
            context.delete(editingEntry)
            context.saveChanges()

        } else {
            // Should never happen
            fatalError("Entry does not exist")
        }
    }
    
    
    @IBAction func addLocationPressed(_ sender: Any) {
        locationManager.requestLocation()
        addLocationButton.setTitle("Retrieving location...", for: .normal)
    }
    
    @IBAction func happyPressed(_ sender: Any) {
        if isEditingEntry {
            self.editingStatus = .happy
        } else {
            self.status = .happy
        }
        
        statusImage.image = #imageLiteral(resourceName: "icn_happy")
    }
    
    @IBAction func averagePressed(_ sender: Any) {
        if isEditingEntry {
            self.editingStatus = .average
        } else {
            self.status = .average
        }
        
        statusImage.image = #imageLiteral(resourceName: "icn_average")
    }
    
    @IBAction func sadPressed(_ sender: Any) {
        if isEditingEntry {
            self.editingStatus = .bad
        } else {
            self.status = .bad
        }
        
        statusImage.image = #imageLiteral(resourceName: "icn_bad")
    }
}


// MARK: Extension for PhotoPickerManagerDelegate

extension CreateEntryController: PhotoPickerManagerDelegate {
    
    func didSelect(image: UIImage?) {
        let size = CGSize(width: 80, height: 80)
        

        switch imagePickerSource {
        case .camera:
            print("Its camera")
            let image = image?.resizeAndRotate(to: size, withOrientation: .right)
            self.image = image
            
            if isEditingEntry {
                self.editingImage = image
            }
            
        case .photoLibrary, .savedPhotosAlbum:
            print("Its not camera")
            let image = image?.resized(to: size)
            self.image = image
            
            if isEditingEntry {
                self.editingImage = image
            }
            
        case .none:
            print("none")
            let image = image?.resized(to: size)
            self.image = image
            
            if isEditingEntry {
                self.editingImage = image
            }
        }
    }
}

protocol WasDismissedDelegate {
    func wasDismissed()
}

extension CreateEntryController: LocationManagerDelegate {
    func obtainedLocation(_ location: Location) {

        currentLocation = location
        addLocationButton.isEnabled = false
        
        if let name = location.placemark.name, let locality = location.placemark.locality {
            locationLabel.text = "\(name), \(locality)"
        }
//        locationLabel.text = "\(location.placemark.name), \(location.placemark.locality)"
        
    }
    
    func failedWithError(_ error: LocationError) {
        let alertView = UIAlertController(title: "Error Getting Location", message: "There was a problem getting your location. Make sure you have your internet / data turned on.", preferredStyle: .alert)
        
        switch error {
        case .disallowedByUser: print("disallowed by user")
        case .unableToFindLocation: print("unable to find location")
        case .unknownError: print("unknown error")
        }
//        print("\(error) \n \(error.localizedDescription)")
        alertView.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alertView, animated: true, completion: nil)
        
    }
}

