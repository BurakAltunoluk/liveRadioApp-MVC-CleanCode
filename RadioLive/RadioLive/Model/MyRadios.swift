//
//  MyRadios.swift
//  RadioLive
//
//  Created by Burak Altunoluk on 11/08/2022.
//

import Foundation

struct MyRadios {
    
    var listOfRadios = [RadioStation]()
    var myFavoriteStations = [RadioStation]()
    
    mutating func addNewStation (name: String, logo: String, link: String, myFavourite: Bool) {
        let newRadio = RadioStation(radioName: name, radioLink: link, radioLogo: logo, isMyFavorite: myFavourite)
        self.listOfRadios.append(newRadio)
    }
}

