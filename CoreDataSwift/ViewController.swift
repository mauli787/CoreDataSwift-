//
//  ViewController.swift
//  CoreDataSwift
//
//  Created by Dnyaneshwar Shinde on 13/04/18.
//  Copyright © 2018 Dnyaneshwar Shinde. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var userPhoneText: UITextField!
    @IBOutlet weak var userAddressText: UITextField!
    @IBOutlet weak var userEmailText: UITextField!
    
    @IBOutlet weak var baseScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         baseScroll.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + 100)
        
        userNameText.delegate = self
        userAddressText.delegate = self
        userEmailText.delegate = self
        userPhoneText.delegate = self 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        baseScroll.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height + 20
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        baseScroll.contentInset.bottom = 0
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return  textField.resignFirstResponder()
    }
    @IBAction func saveButtonClickAction(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "UserDetails", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(self.userNameText.text, forKey: "userName")
        newUser.setValue(self.userEmailText.text, forKey: "userEmail")
        newUser.setValue(self.userPhoneText.text , forKey: "userPhone")
        newUser.setValue(self.userAddressText.text , forKey: "userAddress")
        
        do {
            
            try context.save()
            
        } catch {
            
            print("Failed saving")
        } 
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
        })
        editAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
        })
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}

