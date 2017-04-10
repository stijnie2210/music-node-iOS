//
//  LoadViewController.swift
//  Music Node
//
//  Created by Stijn Mommersteeg on 10/04/2017.
//  Copyright © 2017 chocomel. All rights reserved.
//

import Foundation
import UIKit

class LoadViewController : UIViewController {
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        loadIndicator.startAnimating()
        if(UserDefaults.standard.value(forKey: "token") == nil) {
            performSegue(withIdentifier: "tologin", sender: self)
        } else {
            performSegue(withIdentifier: "toplaylists", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toplaylists") {
            
            let navController = segue.destination as? UINavigationController
            
            let playlistView = navController?.viewControllers.first as! PlaylistViewController
            
            playlistView.token = UserDefaults.standard.string(forKey: "token")
            

        }
    }
    
}
