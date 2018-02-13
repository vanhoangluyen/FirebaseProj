//
//  ViewController.swift
//  FirebaseProj
//
//  Created by LuyenBG on 2/12/18.
//  Copyright © 2018 LuyenBG. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
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
    //MARK: - Edit Operation – Firebase Realtime Database
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the selected artist
        let artist = artistList[indexPath.row]
        //building an alert
        let alertController = UIAlertController(title: artist.name, message: "Give new values to update ", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            //getting artist id
            let id = artist.id
            //getting new values
            let name = alertController.textFields![0].text
            let genre = alertController.textFields![1].text
            //calling the update method to update artist
            self.updateArtist(id: id!, name: name!, genre: genre!)
        }
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) in}
        //adding two textfields to alert
        alertController.addTextField(configurationHandler: { (textfield) in
            textfield.text = artist.name
        })
        alertController.addTextField(configurationHandler: { (textfield) in
            textfield.text = artist.genre
        })
        //adding action
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        //presenting dialog
        present(alertController, animated: true, completion: nil)
        
    }
    //MARK : - Update Operation – Firebase Realtime Database
    func updateArtist(id: String, name: String, genre : String) {
        //creating artist with the new given values
        let artist = [
            "id": id,
            "artistName": name,
            "artistGenre": genre
        ]
        //updating the artist using the key of the artist
        refArtists.child(id).setValue(artist)
        //displaying message
        labelMessage.text = "Artist Updated"
    }
}

