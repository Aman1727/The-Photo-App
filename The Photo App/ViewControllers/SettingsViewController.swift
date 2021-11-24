//
//  SettingsViewController.swift
//  The Photo App
//
//  Created by Aman on 24/11/21.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        
//        Sign out with Firebase Auth
        do {
            
//            Try to sign out the user
            try Auth.auth().signOut()
            
//        Clear local storage
            LocalStorageService.clearUser()
            
//        Transition to authentication flow
            
            let loginNavVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginNavController)
            self.view.window?.rootViewController = loginNavVC
            self.view.window?.makeKeyAndVisible()
            
        }catch {
            
        }
    }
    
}
