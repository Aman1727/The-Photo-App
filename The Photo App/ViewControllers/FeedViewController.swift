//
//  FeedViewController.swift
//  The Photo App
//
//  Created by Aman on 24/11/21.
//

import UIKit

class FeedViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Add pull to refresh
        addRefreshControl()
        
        
        
        
        //        Call the PhotoService to retrieve the photos
        PhotoService.retrievePhotos { retrievedPhotos in
            self.photos = retrievedPhotos
            self.tableView.reloadData()
        }
        
    }
    
    func addRefreshControl() {
        //        Create refresh control
        let refresh = UIRefreshControl()
        
        //        Set target
        refresh.addTarget(self, action: #selector(refreshFeed(refreshControl:)), for: .valueChanged)
        //        Add to tableview
        self.tableView.addSubview(refresh)
        
    }
    
    @objc func refreshFeed(refreshControl: UIRefreshControl) {
        //        Call the photo service
        PhotoService.retrievePhotos { newPhotos in
            //            Assign new photos to out photos property
            self.photos = newPhotos
            DispatchQueue.main.async {
                //            Refresh tableview
                self.tableView.reloadData()
                //            Stop the spinner
                refreshControl.endRefreshing()
            }
        }
    }
}


extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        Get a Photo Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.photoCellId, for: indexPath) as? PhotoCell
        //        Get the photo this cell is displaying
        let photo = self.photos[indexPath.row]
        //        Call display photo method of the cell
        cell?.displayPhoto(photo: photo)
        //        Return the cell
        return cell!
        
    }
    
}
