//
//  PlaylistDetailController.swift
//  Music Node
//
//  Created by Stijn Mommersteeg on 07/04/2017.
//  Copyright © 2017 chocomel. All rights reserved.
//

import Foundation
import UIKit

class PlaylistDetailController : UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameEditField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var name:String?
    var id:String?
    var token:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
        
        nameLabel.text = "\(name!) aanpassen"
        nameEditField.placeholder = "\(name!)"
    }
    
    
    @IBAction func onEdit(_ sender: Any) {
        if(nameEditField.text != "") {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    
    
    
    
    
}
