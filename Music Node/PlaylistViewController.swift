//
//  PlaylistViewController.swift
//  Music Node
//
//  Created by Stijn Mommersteeg on 07/04/2017.
//  Copyright © 2017 chocomel. All rights reserved.
//

import Foundation
import UIKit

struct Playlist {
    var name:String
    var numberOfTracks:Int
    
    init(name: String, numberOfTracks:Int) {
        self.name = name
        self.numberOfTracks = numberOfTracks
    }
}

class PlaylistViewController : UITableViewController {
    
    let testPlaylists = [
        Playlist(name: "Playlist 1", numberOfTracks: 5),
        Playlist(name: "Playlist 2", numberOfTracks: 10)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // TODO: Get playlist data and return number of rows based on array size
        return testPlaylists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath)
        
        // Configure the cell...
        
        // Example data from other project
        
//        let player = players[indexPath.row] as Player
//        cell.textLabel?.text = player.name
//        cell.detailTextLabel?.text = "Game: \(player.game)"
//        cell.imageView?.image = player.image
        
        cell.textLabel?.text = testPlaylists[indexPath.row].name
        cell.detailTextLabel?.text = String(testPlaylists[indexPath.row].numberOfTracks)
        
        
        return cell
    }
}
