import Foundation
import UIKit


class PlaylistViewController : UITableViewController {
    
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addPlaylistButton: UIBarButtonItem!
    
    var token:String?
    var playlists = [(String)]()
    var playlistData = [([String(), String()])]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        playlistData.removeAll()
        loadPlaylists()
    }
    
    @IBAction func addPlaylist(_ sender: Any) {
        performSegue(withIdentifier: "toAddPlaylist", sender: self.addPlaylistButton)
    }
    
    
    
    @IBAction func reloadPlaylists(_ sender: Any) {
        reloadtableView()
    }
    
    
    func reloadtableView() {
        self.playlists.removeAll()
        self.playlistData.removeAll()
        self.tableView.reloadData()
        self.loadPlaylists()
    }
    
    
    func loadPlaylists() {
        self.loadIndicator.startAnimating()
        let playlist_url = "https://music-node-api.herokuapp.com/api/users/playlists?limit=25"
        
        let url:URL = URL(string: playlist_url)!
        var request = URLRequest(url: url)
        request.setValue("JWT \(token!)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {data, response, err in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                
                
                let playlistsJson = json["data"] as! [[String:Any]]
                
                DispatchQueue.main.async {
                    self.loadIndicator.stopAnimating()
                    
                    for data in playlistsJson {
                        self.playlistData.append([data["_id"] as! String, data["name"] as! String])
                        self.playlists.append(data["name"] as! String)
                        self.tableView.reloadData()
                        self.loadIndicator.stopAnimating()
                    }
                }
                
            } catch {
                
            }
            
        }
        
        task.resume()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // TODO: Get playlist data and return number of rows based on array size
        return playlists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath)
        
        
        // Configure the cell...
        
        let playlist = self.playlists[indexPath.row]
        cell.textLabel?.text = playlist
        
        return cell
    }
    
    @IBAction func doLogout(_ sender: Any) {
        let alert = UIAlertController(title: "Uitloggen", message: "Weet je zeker dat je wil uitloggen?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Nee", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ja", style: .destructive) { action in
            
            UserDefaults.standard.removeObject(forKey: "token")
            self.performSegue(withIdentifier: "doLogout", sender: self.logoutButton)
        })
        
        self.present(alert, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "doLogout") {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if(segue.identifier == "toAddPlaylist") {
            let validToken = self.token!
            
            if let add = segue.destination as? AddPlaylistViewController {
                add.tempViewController = self
                add.token = validToken
            }
        }
        
        if(segue.identifier == "toDetail") {
            let playlist = playlistData[tableView.indexPathForSelectedRow!.row]
            let validToken = self.token!
            
            if let details = segue.destination as? PlaylistDetailController {
                details.tempViewController = self
                details.id = playlist[0]
                details.name = playlist[1]
                details.token = validToken
            }
        }
    }
}
