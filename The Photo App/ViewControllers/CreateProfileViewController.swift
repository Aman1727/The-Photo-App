//
//  CreateProfileViewController.swift
//  The Photo App
//
//  Created by Aman on 24/11/21.
//

import UIKit
import FirebaseAuth

class CreateProfileViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func confirmTapped(_ sender: Any) {
        
//        Check that there is a user logged in
        guard Auth.auth().currentUser != nil else {
            
//            No user logged in
            return
        }
        
        
//        Get the username
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//        Check it against whitespaces, new lines, illegal character etc
        
        if username == nil || username == ""{
//          Show the error message
            let alertController =  UIAlertController(title: "Alert", message: "Username is Empty", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }else{
            //        Call the user service to create the profile
            UserService.createProfile(userId: Auth.auth().currentUser!.uid, username: username!){ user in
                //        Check if it was created successfully
                if user != nil {
                    //        If so, go to the tab bar controller
                    
//                    Save the user to local storage
                    LocalStorageService.saveUser(userId: user!.userId, username: user!.username)
                    
                    let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.tabBarController)
                    self.view.window?.rootViewController = tabBarVC
                    self.view.window?.makeKeyAndVisible()
                }else {
                    //        If not, display error
                    
                }
            } 
        }
        
        

        
    }
    
}
