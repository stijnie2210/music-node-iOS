import Foundation
import UIKit

class SignupViewController : UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    let signup_url = "https://music-node-api.herokuapp.com/api/signup"
    
    
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
            "E-mail bestaat al of is niet geldig", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Oké", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func successAlert() {
        let alertController = UIAlertController(title: "Gelukt!", message:
            "Geregistreerd", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Oké", style: UIAlertActionStyle.default) { action in
            self.performSegue(withIdentifier: "doSignup", sender: self)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signup(_ sender: Any) {
        if(emailTextField.text! != "" && passwordTextField.text! != "") {
            doSignup(email: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    
    func doSignup(email:String, password:String) {
        self.signupButton.isEnabled = false
        self.loadIndicator.startAnimating()
        let postData: NSDictionary = NSMutableDictionary()
        
        postData.setValue(email, forKey: "email")
        postData.setValue(password, forKey: "password")
        
        let url:URL = URL(string: signup_url)!
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
                
                let status = json["status"] as! String?
                
                DispatchQueue.main.async {
                    self.signupButton.isEnabled = true
                    self.loadIndicator.stopAnimating()
                    if(status == "ok") {
                        self.successAlert()
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "doSignup") {
            
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
    }
    
}
