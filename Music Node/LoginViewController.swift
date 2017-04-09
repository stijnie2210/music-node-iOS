//
//  LoginViewController.swift
//  Music Node
//
//  Created by Stijn Mommersteeg on 09/04/2017.
//  Copyright © 2017 chocomel. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    let login_url = "https://music-node-api.herokuapp.com/api/auth"
    var token:String?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doLogin(_ sender: Any) {
        
        if(emailTextField.text! != "" && passwordTextField.text! != "") {
            loginNow(email: emailTextField.text!, password: passwordTextField.text!)
        }
        
    }
    
    func loginNow(email:String, password:String) {
        let postData: NSDictionary = NSMutableDictionary()
        
        postData.setValue(email, forKey: "email")
        postData.setValue(password, forKey: "password")
        
        let url:URL = URL(string: login_url)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        var paramString = ""
        
        for (key, value) in postData
        {
            paramString = paramString + (key as! String) + "=" + (value as! String) + "&"
        }
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, err in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                
                let token = json["token"] as! String?
                
                DispatchQueue.main.async {
                    if(token != nil) {
                        self.token = token
                        self.doSegue()
                    }
                }
                
            } catch {
                
            }
            
        }

        task.resume()
    }
    
    func doSegue() {
        if(token != nil) {
            performSegue(withIdentifier: "login", sender: loginButton)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "login") {
            print(segue.destination)
            if let playlistView = segue.destination as? PlaylistViewController {
                playlistView.token = token!
            }
        }
        
    }
}
