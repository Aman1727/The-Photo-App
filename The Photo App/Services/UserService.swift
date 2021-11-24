//
//  UserService.swift
//  The Photo App
//
//  Created by Aman on 24/11/21.
//

import Foundation
import FirebaseFirestore

class UserService {
    
    static func createProfile(userId: String , username: String, completion: @escaping (PhotoUser?)->Void){
  
        let profileData = ["username": username]
        
//        Get db reference
        let db = Firestore.firestore()
        
//        Create the document
        db.collection("users").document(userId).setData(profileData) { error in
            if error == nil {
//                Profile Created successfully
//                Create and return a photo user
                var u = PhotoUser()
                u.username = username
                u.userId = userId
                
                completion(u)
            }
            else{
//                Something went wrong
                completion(nil)
//                Return nil
            }
        }
    }
    
    static func retrieveProfile(userId: String, completion: @escaping (PhotoUser?) -> Void) {
        
//        Get a firestore reference
        let db = Firestore.firestore()
//        Check for a profile, given the user Id
        db.collection("users").document(userId).getDocument { snapshot, error in
            
            if error != nil || snapshot == nil {
//                Something wrong happened
                return
            }
            
            if let profile = snapshot!.data() {
//                Profile was found, create a new Photo User
                var u = PhotoUser()
                u.userId = snapshot!.documentID
                u.username = profile["username"] as? String
                
//                Return the user
                completion(u)
            }
            else {
//                Couldn't get profile, no profile
                completion(nil)
//                Return nil
            }
            
        }
    }
    
    
}
