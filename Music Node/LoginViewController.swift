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
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Fout", message:
            "Inloggegevens incorrect", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Oké", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    @IBAction func doLogin(_ sender: Any) {
        
        if(emailTextField.text! != "" && passwordTextField.text! != "") {
            loginNow(email: emailTextField.text!, password: passwordTextField.text!)
        } else {
            
        }
        
    }
    
    @IBAction func toSignupScreen(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignupScreen", sender: self.signupButton)
    }
    
    
    func loginNow(email:String, password:String) {
        self.loginButton.isEnabled = false
        self.loadIndicator.startAnimating()
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
                    self.loginButton.isEnabled = true
                    self.loadIndicator.stopAnimating()
                    if(token != nil) {
                        self.token = token
                        UserDefaults.standard.set(token, forKey: "token")
                        self.doSegue()
                    } else {
                        self.passwordTextField.text = ""
                        self.showAlert()
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
            let validToken = self.token!
            let navController = segue.destination as? UINavigationController
            
            let playlistView = navController?.viewControllers.first as! PlaylistViewController
            
            playlistView.token = validToken
            
        }
        
    }
}
