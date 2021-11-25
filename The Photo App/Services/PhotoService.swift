//
//  PhotoService.swift
//  The Photo App
//
//  Created by Aman on 25/11/21.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class PhotoService {
    
    
    static func retrievePhotos(completion: @escaping ([Photo])->Void) {
        
//        Get a database reference
        let db = Firestore.firestore()
        
//        Get all the documents from the photos collection
        db.collection("photos").getDocuments { snapshot, error in
            if error != nil {
//                Error in retrieving photos
                return
            }
            
//            Get all the documents
            let documents = snapshot?.documents
            
            if let documents = documents {
//                Create an array to hold all of our Photo structs
                var photoArray = [Photo]()
                
//                Loop through the documents, create a photo struct for each
                for doc in documents {
                    
                    let p = Photo(snapshot: doc)
                    
                    if p != nil {
//                        Store it in a array
                        photoArray.insert(p!, at: 0)
                    }
                }
                
//                Pass back the photo array
                completion(photoArray)
                
                
            }
        }
    }
    
    
    
    
    static func savePhoto(image : UIImage, progressUpdate: @escaping (Double)->Void) {
        
//        Check that there's a user logged in
        if Auth.auth().currentUser == nil {
            return
        }
        
        
//        Get the data representation of the UIImage
        let photoData = image.jpegData(compressionQuality: 0.1)
        guard photoData != nil else{
            return
        }
//        Create a filename
        let filename = UUID().uuidString
//        Get the user id of the current user
        let userId = Auth.auth().currentUser!.uid
//        Create a firebase storage path
        let ref = Storage.storage().reference().child("images/\(userId)/\(filename).jpg")
//        Upload the data
        let uploadTask = ref.putData(photoData!, metadata: nil) { metadata, error in
//            Check if upload was successful
            if error == nil {
                //            Upon successful upload, create the database entry
                self.createDatabaseEntry(ref: ref)
            }
        }
        
        uploadTask.observe(.progress) { taskSnapshot in
           let pct =  Double(taskSnapshot.progress!.completedUnitCount) / Double(taskSnapshot.progress!.totalUnitCount)
            progressUpdate(pct)
        }
        
        
    }
    
    
    private static func createDatabaseEntry(ref:StorageReference) {
//        Download url
        ref.downloadURL { url, error in
            if error == nil {
                //        Photo id
                let photoId = ref.fullPath
                //        User id
                let photoUser = LocalStorageService.loadUser()
                
//                User id
                let userId = photoUser?.userId
                //        Username
                let username = photoUser?.username
                
                //        Date
                let df = DateFormatter()
                df.dateStyle = .full
                let dateString = df.string(from: Date())
                
//                Create a dictionary of the photo metadata
                let metadata = ["photoId":photoId, "byId":userId!, "byUsername": username!, "date": dateString, "url":url!.absoluteString]
                
                
//                Save the metadata to the firestore database
                let db = Firestore.firestore()
                
                db.collection("photos").addDocument(data: metadata) { error in
//                    Check if the saving of data was successful
                    if error == nil {
//                        Successfully created database entry for the photo
                    }
                }
                
                
            }
        }
    }
    
    
    
}
