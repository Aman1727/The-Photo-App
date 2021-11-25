//
//  CameraViewController.swift
//  The Photo App
//
//  Created by Aman on 24/11/21.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
//      Hide and reset all elements
        progressBar.alpha = 0
        progressBar.progress = 0
        
        
        doneButton.alpha = 0
        progressLabel.alpha = 0
    }
    
    
    func savePhoto(image:UIImage) {
        
//        Call the photo service to store the photo
        PhotoService.savePhoto(image: image) { pct in
//            Update the progress bar
            
            DispatchQueue.main.async {
                self.progressBar.alpha = 1
                self.progressBar.progress = Float(pct)
    //            Update the label
                let roundedPct = Int(pct * 100)
                self.progressLabel.text = "\(roundedPct) %"
                self.progressLabel.alpha = 1
                
    //            Check if it's done
                if roundedPct == 100 {
                    self.doneButton.alpha = 1
                }
            }
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
//        Get a reference to the tab bar controller
        let tabBarVC = self.tabBarController as? MainTabBarController
        
        if let tabBarVC = tabBarVC {
//            Call go to feed
            tabBarVC.goToFeed()
        }
        
    }
    
}
