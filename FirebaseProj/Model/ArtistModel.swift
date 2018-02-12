//
//  ArtistModel.swift
//  FirebaseProj
//
//  Created by LuyenBG on 2/12/18.
//  Copyright © 2018 LuyenBG. All rights reserved.
//

import Foundation

class ArtistModel {
    var id: String?
    var name: String?
    var genre: String?
    init(id : String?,name:String?,genre:String?) {
        self.id = id
        self.name = name
        self.genre = genre
    }
}
