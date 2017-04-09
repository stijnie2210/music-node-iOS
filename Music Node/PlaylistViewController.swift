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
    
    var token:String?
    var playlists = [(String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let playlist_url = "https://music-node-api.herokuapp.com/api/playlists"
        
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
                        self.playlists.append(data["name"] as! String)
                        print(self.playlists)
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
        
        // Example data from other project
        
//        let player = players[indexPath.row] as Player
//        cell.textLabel?.text = player.name
//        cell.detailTextLabel?.text = "Game: \(player.game)"
//        cell.imageView?.image = player.image
        
        
        let playlist = self.playlists[indexPath.row]
        cell.textLabel?.text = playlist
        
        return cell
    }
}
