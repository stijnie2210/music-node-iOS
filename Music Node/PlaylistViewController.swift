//
//  PlaylistViewController.swift
//  Music Node
//
//  Created by Stijn Mommersteeg on 07/04/2017.
//  Copyright © 2017 chocomel. All rights reserved.
//

import Foundation
import UIKit


class PlaylistViewController : UITableViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    
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
    
    
    @IBAction func reloadPlaylists(_ sender: Any) {
        reloadtableView()
    }
    
    
    func reloadtableView() {
        self.playlists.removeAll()
        self.playlistData.removeAll()
        loadPlaylists()
    }
    
    
    func loadPlaylists() {
        let playlist_url = "https://music-node-api.herokuapp.com/api/users/playlists"
        
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
                    
                    for data in playlistsJson {
                        print(data["_id"]!)
                        self.playlistData.append([data["_id"] as! String, data["name"] as! String])
                        self.playlists.append(data["name"] as! String)
                        self.tableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let playlist = playlistData[tableView.indexPathForSelectedRow!.row]
        let validToken = self.token!
        print(playlist[1])
        
        if let details = segue.destination as? PlaylistDetailController {
            details.tempViewController = self
            details.id = playlist[0]
            details.name = playlist[1]
            details.token = validToken
        }
    }
}
