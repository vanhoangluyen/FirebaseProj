//
//  ViewController.swift
//  FirebaseProj
//
//  Created by LuyenBG on 2/12/18.
//  Copyright © 2018 LuyenBG. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITableViewDataSource {
    @IBOutlet var artistNameTextfield: UITextField!
    @IBOutlet var artistGenreTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var labelMessage: UILabel!
    

    var refArtists: DatabaseReference!
    var artistList = [ArtistModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //configuring firebase
        FirebaseApp.configure()
        //getting a reference to the node artists
        refArtists = Database.database().reference().child("artists")
        fetchingValue()
    }
    func fetchingValue() {
        refArtists.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.artistList.removeAll()
                //iterating through all the values
                for artist in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let artistObject = artist.value as? [String : AnyObject]
                    let artistName = artistObject?["artistName"]
                    let artistGenre = artistObject?["artistGenre"]
                    let artistId = artistObject?["id"]
                    //creating artist object with model and fetched values
                    let artist = ArtistModel(id: artistId as? String , name: artistName as? String, genre: artistGenre as? String)
                    //appending it to list
                    self.artistList.append(artist)
                }
                //reloading the tableview
                self.tableView.reloadData()
            }
        })
    }


    //MARK: - Write Operation – Firebase Realtime Database
    @IBAction func btnAddArtist(_ sender: UIButton) {
        //and also getting the generated key
        let key = refArtists.childByAutoId().key
        if (artistNameTextfield.text == "" || artistGenreTextField.text == "") {
            labelMessage.text = "Please Insert Infomation"
        } else {
            //creating artist with the given values
            let artist = [
                "id" : key,
                "artistName" : artistNameTextfield.text! as String,
                "artistGenre": artistGenreTextField.text! as String
            ]
            //adding the artist inside the generated unique key
            refArtists.child(key).setValue(artist)
            //displaying message
            labelMessage.text = "Artist Added"
        }
        artistNameTextfield.text = ""
        artistGenreTextField.text = ""
    }

    @IBAction func btnCalcel(_ sender: UIButton) {
        artistNameTextfield.text = ""
        artistGenreTextField.text = ""
        labelMessage.text = ""
    }
    //MARK: - Read Operation – Firebase Realtime Database
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = artistList[indexPath.row].name
        cell.detailTextLabel?.text = artistList[indexPath.row].genre
        return cell
    }
}

