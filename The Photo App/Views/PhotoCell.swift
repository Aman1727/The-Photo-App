//
//  PhotoCell.swift
//  The Photo App
//
//  Created by Aman on 25/11/21.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var photo: Photo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    func displayPhoto(photo: Photo) {
        
//        Reset the image
        self.photoImageView.image = nil
//        Set photo property
        self.photo = photo
        
//        Set the username
        usernameLabel.text = photo.byUsername
        
//        Set the date
        dateLabel.text = photo.date
//        Download the image
//        Check that there is a valid download url
        if photo.url == nil {
            return
        }
        
//        Check if the image is in our image cache, if it is, use it
        if let cachedImage = ImageCacheService.getImage(url: photo.url!){
            
//            Use the cached image
            self.photoImageView.image = cachedImage
            
//            Return because we no longer need to download the image
            return
        }
        
        
        let url = URL(string: photo.url!)
//        Check that url object was created
        
        if url == nil{
            return
        }
        
//        Use url session to donwload image ansynchronously
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error == nil && data != nil{
                
//                Check that the image data we downloaded matches the photo this cell is currently supposed to display
                
//                Set the image view
                let image = UIImage(data: data!)
                                
//                Store the image data in cache
                ImageCacheService.saveImage(url: url!.absoluteString, image: image)
                
                if url!.absoluteString != self.photo?.url!{
//                    The url we downloaded doesn't match the url
                    return
                }

                
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            }
        }
        
        dataTask.resume()
        
    }
    
}
