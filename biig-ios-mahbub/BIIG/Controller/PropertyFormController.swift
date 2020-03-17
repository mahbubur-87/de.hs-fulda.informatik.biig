//
//  PropertyFormController.swift
//  BIIG
//
//  Created by mahbub on 4/6/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import UIKit
import CoreImage

class PropertyFormController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, EngineDelegate {

    let app = CoreEngine()
    
    var formFieldNames = ["Title", "Price", "Overview", "Description", "Size", "Rooms", "Furnishing", "House", "Street", "PLZ", "City", "State", "Country", "Image 1", "Image 2", "Image 3"]
    
    var imagePickerTag: Int? = nil
    var propertyDictionary = [String : Any?]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var propertyFormTable: UITableView!
    
    @IBAction func updatePropertyDictionary(_ sender: UITextField) {
        
        let propDicKey = self.formFieldNames[sender.tag]
        
        do {
            switch propDicKey {
                
                case "Price":
                    
                    self.propertyDictionary[propDicKey] = try Double.parseDouble(from: sender.text!)
                    break
                
                case "Size":
                    
                    self.propertyDictionary[propDicKey] = try Int.parseInt(from: sender.text!)
                    break
                
                case "Rooms":
                    
                    self.propertyDictionary[propDicKey] = try Int.parseInt(from: sender.text!)
                    break
                
                case "PLZ":
                    
                    self.propertyDictionary[propDicKey] = try Int.parseInt(from: sender.text!)
                    break
                
                default:
                    self.propertyDictionary[propDicKey] = sender.text
            }
            
        } catch DataTypeError.INVALID_INT(let reason) {
            
            if let intValue = self.propertyDictionary[propDicKey] as? Int {
            
                sender.text = "\(intValue)"
            } else {
                
                sender.text = nil
            }
            
            self.processDidAbort(reason: reason)
            
        } catch DataTypeError.INVALID_DOUBLE(let reason) {
            
            if let doubleValue = self.propertyDictionary[propDicKey] as? Double {
                
                sender.text = "\(doubleValue)"
            } else {
                
                sender.text = nil
            }
            
            self.processDidAbort(reason: reason)
            
        } catch {
            
            sender.text = self.propertyDictionary[propDicKey] as? String
            self.processDidAbort(reason: error.localizedDescription)
        }
    }
    
    @IBAction func saveProperty(_ sender: UIButton) {
        
        self.activityIndicator.startAnimating()
        
        guard self.propertyDictionary["Price"] != nil else {
            
            self.activityIndicator.stopAnimating()
            self.processDidAbort(reason: "Please input Price field.")
            return
        }
        
        guard self.propertyDictionary["Size"] != nil else {
            
            self.activityIndicator.stopAnimating()
            self.processDidAbort(reason: "Please input Size field.")
            return
        }
        
        guard self.propertyDictionary["Rooms"] != nil else {
            
            self.activityIndicator.stopAnimating()
            self.processDidAbort(reason: "Please input Rooms field.")
            return
        }
        
        guard self.propertyDictionary["PLZ"] != nil else {
            
            self.activityIndicator.stopAnimating()
            self.processDidAbort(reason: "Please input PLZ field.")
            return
        }
        
        guard self.propertyDictionary["Image 1"] != nil else {
            
            self.activityIndicator.stopAnimating()
            self.processDidAbort(reason: "Please upload a property image in Image 1 field.")
            return
        }
        
        let image1 = self.propertyDictionary["Image 1"]! as! (fileName: String, format: String, image: UIImage)
        let image1Base64 = self.generateBase64(from: image1.image, format: image1.format)
        
        var image2Base64: String? = nil
        var image2Format: String? = nil
        
        var image3Base64: String? = nil
        var image3Format: String? = nil
        
        if let image2Tuple = self.propertyDictionary["Image 2"],
            let image2 = image2Tuple as? (fileName: String, format: String, image: UIImage) {
            
            image2Format = image2.format
            image2Base64 = self.generateBase64(from: image2.image, format: image2Format!)
        }
        
        if let image3Tuple = self.propertyDictionary["Image 3"],
            let image3 = image3Tuple as? (fileName: String, format: String, image: UIImage) {
            
            image3Format = image3.format
            image3Base64 = self.generateBase64(from: image3.image, format: image3Format!)
        }
        
        let propertyDto = PropertyDTO(
            employeeId: 11,
            title: self.propertyDictionary["Title"]! as! String,
            price: self.propertyDictionary["Price"]! as! Double,
            overview: self.propertyDictionary["Overview"]! as! String,
            desc: self.propertyDictionary["Description"]! as! String,
            size: self.propertyDictionary["Size"]! as! Int,
            numberofrooms: self.propertyDictionary["Rooms"]! as! Int,
            furnishingstate: self.propertyDictionary["Furnishing"]! as! Int,
            streetname: self.propertyDictionary["Street"]! as! String,
            housenumber: self.propertyDictionary["House"]! as! String,
            country: self.propertyDictionary["Country"]! as! String,
            state: self.propertyDictionary["State"]! as! String,
            plz: self.propertyDictionary["PLZ"]! as! Int,
            city: self.propertyDictionary["City"]! as! String,
            image1: image1Base64,
            image1Format: image1.format,
            image2: image2Base64,
            image2Format: image2Format,
            image3: image3Base64,
            image3Format: image3Format
        )
        
        self.app.addProperty(propertyDto)
    }  
    
    @IBAction func uploadPropertyImage(_ sender: UIButton) {
        
        self.presentImagePicker(sender)
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let homeButton = UIBarButtonItem(title: "HOME", style: .plain, target: self, action: #selector(UIViewController.goToHome(_:)))
        self.navigationItem.rightBarButtonItem = homeButton
        
        self.propertyFormTable.delegate = self
        self.propertyFormTable.dataSource = self
        
        app.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.formFieldNames.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerFrame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40)
        let headerView = UIView(frame: headerFrame)
        headerView.backgroundColor = UIColor.lightGray
        
        let headerTitle = UILabel(frame: headerFrame)
        headerTitle.font = UIFont.systemFont(ofSize: CGFloat(20), weight: .semibold)
        headerTitle.text = "  Add Property:"
        
        headerView.addSubview(headerTitle)

        let saveButton = UIButton(frame: CGRect(x: tableView.bounds.size.width - 100, y: 5, width: 70, height: 40))
        saveButton.backgroundColor = UIColor.blue
        saveButton.setTitle("Save", for: UIControlState.normal)
        saveButton.addTarget(self, action: #selector(PropertyFormController.saveProperty(_:)), for: UIControlEvents.touchUpInside)
        
        headerView.addSubview(saveButton)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyFormCell", for: indexPath)
        
        cell.subviews.forEach { subView in
            
            subView.removeFromSuperview()
        }
        
        let fieldTitle = UILabel(frame: CGRect(x: 15, y: 12, width: 110, height: 50))
        
        fieldTitle.text = self.formFieldNames[indexPath.row]
        fieldTitle.font = UIFont.systemFont(ofSize: CGFloat(18), weight: .semibold)
        cell.addSubview(fieldTitle)
        
        switch indexPath.row {

            case 0 ... 5:

                let fieldComponent = UITextField(frame: CGRect(x: 122, y: 12, width: tableView.bounds.size.width - 150, height: 50))
                fieldComponent.borderStyle = .roundedRect
                fieldComponent.tag = indexPath.row
                fieldComponent.addTarget(self, action: #selector(PropertyFormController.updatePropertyDictionary(_:)), for: .editingDidEnd)
                
                cell.addSubview(fieldComponent)

                break

            case 6:

                let pickerView = UIPickerView(frame: CGRect(x: 122, y: 12, width: 200, height: 90))
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.selectRow(UIView.furnishingStates.count / 2, inComponent: 0, animated: true)

                cell.addSubview(pickerView)

                break

            case 7 ... 12:

                let fieldComponent = UITextField(frame: CGRect(x: 122, y: 12, width: tableView.bounds.size.width - 150, height: 50))
                fieldComponent.borderStyle = .roundedRect
                fieldComponent.tag = indexPath.row
                fieldComponent.addTarget(self, action: #selector(PropertyFormController.updatePropertyDictionary(_:)), for: .editingDidEnd)
                
                cell.addSubview(fieldComponent)

                break

            case 13 ... 15:

                let uploadImageButton = UIButton(frame: CGRect(x: 122, y: 12, width: 150, height: 50))
                uploadImageButton.backgroundColor = UIColor.lightGray
                uploadImageButton.setTitle("Upload Image", for: UIControlState.normal)
                uploadImageButton.tag = indexPath.row
                uploadImageButton.addTarget(self, action: #selector(PropertyFormController.uploadPropertyImage(_:)), for: UIControlEvents.touchUpInside)

                cell.addSubview(uploadImageButton)
                
                let uploadImageLabel = UILabel(frame: CGRect(x: 280, y: 12, width: tableView.bounds.size.width - 150, height: 50))
                uploadImageLabel.backgroundColor = UIColor.clear
                uploadImageLabel.tag = indexPath.row
                
                cell.addSubview(uploadImageLabel)
                
                break

            default:
                print("No Match")
        }
        
        if let propertyFieldValue = self.propertyDictionary[self.formFieldNames[indexPath.row]],
            let existingValue = propertyFieldValue {
            
            cell.subviews.forEach { subView in
                
                switch subView {
                    
                    case let textField as UITextField:
                        
                        var textValue: String? = nil
                        
                        switch existingValue {
                            
                            case let intValue as Int:
                                
                                textValue = "\(intValue)"
                                break
                            
                            case let doubleValue as Double:
                        
                                textValue = "\(doubleValue)"
                                break
                            
                            default:
                                textValue = existingValue as! String
                        }
                        
                        textField.text = textValue
                        break
                    
                    case let valuePicker as UIPickerView:
                        
                        let valueId = existingValue as! Int
                        let rowIndex = UIView.furnishingStates.index(where: { $0.id == valueId })!
                        valuePicker.selectRow(rowIndex, inComponent: 0, animated: true)
                        break
                    
                    case let textLabel as UILabel where textLabel.tag > 0 && textLabel.tag == indexPath.row:
    
                        let imageTuple = existingValue as! (fileName: String, format: String, image: UIImage)
                        textLabel.text = imageTuple.fileName
                        break
                    
                    default:
                        print("No Match")
                }
            }
        }
        
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return UIView.furnishingStates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return UIView.furnishingStates[row].value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.propertyDictionary["Furnishing"] = UIView.furnishingStates[row].id
    }
    
    func processDidComplete(then dto: Any) {
        
        DispatchQueue.main.async {
            
            switch dto {
                
                case let property as Property:

                    self.activityIndicator.stopAnimating()
                    
                    let successMessage = UIAlertController(title: "Successful", message: "Property is saved.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Done", style: .cancel)
                    successMessage.addAction(okAction)
                    
                    self.present(successMessage, animated: true)
                    
                    break
                
                default:
                    print("No Match")
            }
        }
    }
    
    func processDidAbort(reason message: String) {
        
        DispatchQueue.main.async {
            
            let abortAlert = UIAlertController(title: "Process is aborted.", message: "Reason: " + message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            abortAlert.addAction(cancelAction)
            self.present(abortAlert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let formFieldIndex = self.imagePickerTag {
        
            let imageUrl = info[UIImagePickerControllerImageURL] as? URL
            var imageFileName = "taken-photo.jpeg"
            var imageFormat = "jpeg"
            
            if imageUrl != nil {
                
                imageFileName = imageUrl!.pathComponents[imageUrl!.pathComponents.count - 1]
                imageFormat = imageUrl!.pathExtension
            }
            
            if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.propertyDictionary[self.formFieldNames[formFieldIndex]] = (fileName: imageFileName, format: imageFormat, image: selectedPhoto)
            
                let imageUploadCell = self.propertyFormTable.cellForRow(at: IndexPath(row: formFieldIndex, section: 0))
                
                imageUploadCell?.subviews.filter({ $0.tag == formFieldIndex }).forEach { subView in
                    
                    if let uploadImageLabel = subView as? UILabel {
                        
                        uploadImageLabel.text = imageFileName
                    }
                }
                
                self.dismiss(animated: true)
            }
        }
    }
    
    func presentImagePicker(_ sender: UIButton) {
        
        let imagePickerActionSheet = UIAlertController(title: "Please upload Property Image.", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraButton = UIAlertAction(title: "Take Photo", style: .default) { (alert) -> Void in
                                                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                self.imagePickerTag = sender.tag
                self.present(imagePicker, animated: true)
            }
            
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        let libraryButton = UIAlertAction(title: "Choose Existing", style: .default) { (alert) -> Void in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.imagePickerTag = sender.tag
            self.present(imagePicker, animated: true)
        }
        
        imagePickerActionSheet.addAction(libraryButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        
        if let popoverController = imagePickerActionSheet.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(imagePickerActionSheet, animated: true)
    }
    
    func generateBase64(from image: UIImage, format: String) -> String {
        
        var imageBase64: String? = nil
        
        switch format {
            
            case "jpeg":
                
                let imgData = UIImageJPEGRepresentation(image, 1.0)
                imageBase64 = imgData?.base64EncodedString()
                break
            
            case "jpg":
                
                let imgData = UIImageJPEGRepresentation(image, 1.0)
                imageBase64 = imgData?.base64EncodedString()
                break
            
            case "png":

                let imgData = UIImagePNGRepresentation(image)
                imageBase64 = imgData?.base64EncodedString()
                break

            default:
                print("No Match")
        }
        
        return imageBase64!
    }
    
}
