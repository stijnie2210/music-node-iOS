import Foundation
import UIKit

class AddPlaylistViewController : UIViewController {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    var token:String?
    var tempViewController:PlaylistViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.isEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlaylistDetailController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Gelukt!", message:
            "Afspeellijst toegevoegd", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Oké", style: UIAlertActionStyle.default) { action in
            _ = self.navigationController?.popViewController(animated: true)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onEdit(_ sender: Any) {
        if(nameField.text != "") {
            addButton.isEnabled = true
        } else {
            addButton.isEnabled = false
        }
    }
    
    @IBAction func onAdd(_ sender: Any) {
        self.loadIndicator.startAnimating()
        self.addButton.isEnabled = false
        
        let playlist_url = "https://music-node-api.herokuapp.com/api/playlists"
        let postData: NSDictionary = NSMutableDictionary()
        
        postData.setValue(nameField.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), forKey: "name")
        
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
                self.addButton.isEnabled = true
                self.tempViewController?.reloadtableView()
                self.showAlert()
            }
            
        }
        
        task.resume()
    }


}
