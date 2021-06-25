//
//  NewRestaurantController.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/13/21.
//

import UIKit
import CoreData

class NewRestaurantController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var nameTF: RoundedTextField!{
        didSet{
            nameTF.becomeFirstResponder()
            configureTextFields(textField: nameTF, tag: 1)
        }
    }
    @IBOutlet weak var typeTF   : RoundedTextField!{didSet{configureTextFields(textField: typeTF, tag: 2)}}
    @IBOutlet weak var addressTF: RoundedTextField!{didSet{configureTextFields(textField: addressTF, tag: 3)}}
    @IBOutlet weak var phoneTF  : RoundedTextField!{didSet{configureTextFields(textField: phoneTF, tag: 4)}}
    
    @IBOutlet weak var descriptionTV: UITextView!{
        didSet{
            descriptionTV.tag = 5
            descriptionTV.layer.cornerRadius = 5.0
            descriptionTV.layer.masksToBounds = true
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
    }
    
    //MARK: - setup UI
    
    private func configureNavBar(){
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if let customFont = UIFont(name: "Rubik-Medium", size: 35.0){
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont ]
        }
    }
    
    private func configureTableView(){
        tableView.tableFooterView = UIView()
        tableView.separatorStyle  = .none
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType    = .camera
                    self.present(imagePicker, animated: true)
                }
            }
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType    = .photoLibrary
                    imagePicker.delegate      = self
                    self.present(imagePicker, animated: true)
                }
            }
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            self.present(photoSourceRequestController, animated: true)
        }
    }
    
    //MARK: - Helper
    
    private func configureTextFields(textField: RoundedTextField , tag:Int){
        textField.tag      = tag
        textField.delegate = self
    }
    
   private func saveRestaurantLocally(){
        let object = NSEntityDescription.insertNewObject(forEntityName: "RestaurantEntity", into: context) as! RestaurantMO
        object.name      = nameTF.text
        object.type      = typeTF.text
        object.summary   = descriptionTV.text
        object.isVisited = false
        object.image     = photoImageView.image?.pngData()
        object.location  = addressTF.text
        object.phone     = phoneTF.text
        
        context.insert(object)
        do {
            try context.save()
            print("Saving data to context ")
        } catch{
            print(error.localizedDescription)
        }
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if nameTF.text == "" || typeTF.text == "" || addressTF.text == "" || phoneTF.text == "" || descriptionTV.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        saveRestaurantLocally()
        dismiss(animated: true, completion: nil)
    }
    
}

extension NewRestaurantController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextTF = view.viewWithTag( textField.tag + 1){
            textField.resignFirstResponder()
            nextTF.becomeFirstResponder()
        }
        return true
    }
}

extension NewRestaurantController: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            photoImageView.image = selectedPhoto
            dismiss(animated: true)
        }
    }
}
