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
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    
    var name:String?
    var id:String?
    var token:String?
    var tempViewController:PlaylistViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlaylistDetailController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        
        nameLabel.text = "\(name!) aanpassen"
        nameEditField.placeholder = "\(name!)"
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onEdit(_ sender: Any) {
        if(nameEditField.text != "") {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Gelukt!", message:
            "Afspeellijst opgeslagen!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Oké", style: UIAlertActionStyle.default) { action in
                self.performSegue(withIdentifier: "backToPlaylists", sender: self)
            })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "backToPlaylists") {
            if let playlists = segue.destination as? PlaylistViewController {
                playlists.token = self.token
            }
        }
    }
    
    @IBAction func onSave(_ sender: Any) {
        self.loadIndicator.startAnimating()
        self.saveButton.isEnabled = false
        
        let playlist_url = "https://music-node-api.herokuapp.com/api/playlists/\(id!)/name"
        let postData: NSDictionary = NSMutableDictionary()
        
        postData.setValue(nameEditField.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), forKey: "name")
        
        let url:URL = URL(string: playlist_url)!
        var request = URLRequest(url: url)
        request.setValue("JWT \(token!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        var paramString = ""
        
        for (key, value) in postData
        {
            paramString = paramString + (key as! String) + "=" + (value as! String)
        }
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, err in
            
            
            DispatchQueue.main.async {
                self.loadIndicator.stopAnimating()
                self.saveButton.isEnabled = true
                self.tempViewController?.reloadtableView()
                self.showAlert()
            }
            
        }
        
        task.resume()

        //self.showAlert()
    }
    
    
}
