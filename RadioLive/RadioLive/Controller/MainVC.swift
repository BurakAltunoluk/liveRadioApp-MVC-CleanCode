//
//  ViewController.swift
//  RadioLive
//
//  Created by Burak Altunoluk on 11/08/2022.
//

import UIKit
import AVFoundation
import AVKit

//MARK: Properties
final class MainVC: UIViewController {
    private var player: AVPlayer?
    private var ChoosedRadioRowNumber = 0
    private var segmentIndex = 0
    private var radioList = MyRadios(listOfRadios: [RadioStation]())
    
    @IBOutlet private var myFavouriteOutlet: UIButton!
    @IBOutlet private var playPauseOutlet: UIButton!
    @IBOutlet private var radioTitleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var logoImageView: UIImageView!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.image = UIImage(named: "radio")
        defaultRadioStaions()
        collectionView.reloadData()
        //Background Playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error {
            print("Error \(error.localizedDescription)")
        }
    }
    
    //MARK: Buttons
    @IBAction private func playPauseButton(_ sender: UIButton) {
        if playPauseOutlet.titleLabel!.text == ">>" {
            playPauseOutlet.setTitle("||", for: UIControl.State.normal)
            player?.pause()
        } else {
            playPauseOutlet.setTitle(">>", for: UIControl.State.normal)
            player?.play()
        }
    }
    
    @IBAction private func myFavoriteButton(_ sender: UIButton) {
        if radioList.listOfRadios[ChoosedRadioRowNumber].isMyFavorite == false {
            radioList.listOfRadios[ChoosedRadioRowNumber].isMyFavorite = true
            myFavouriteOutlet.backgroundColor = .cyan
        } else {
            radioList.listOfRadios[ChoosedRadioRowNumber].isMyFavorite = false
            myFavouriteOutlet.backgroundColor = .clear
        }
    }
    
    @IBAction private func segmentButtons(_ sender: UISegmentedControl) {
        collectionView.reloadData()
        if sender.selectedSegmentIndex == 0 {
            myFavouriteOutlet.isEnabled = true
            segmentIndex = 0
        }else {
            segmentIndex = 1
            myFavouriteOutlet.isEnabled = false
            radioList.myFavoriteStations = [RadioStation]()
            for (i, k) in radioList.listOfRadios.enumerated() {
                if k.isMyFavorite == true {
                    radioList.myFavoriteStations.append(radioList.listOfRadios[i])
                }
            }
        }
    }
}

//MARK: CollectionView Extention
extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentIndex == 0 {
            return radioList.listOfRadios.count
        } else {
            return radioList.myFavoriteStations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cello", for: indexPath) as! CollectionViewCell
        if segmentIndex == 0 {
            let imageData = try! Data(contentsOf:URL(string: radioList.listOfRadios[indexPath.row].radioLogo)!)
            Cell.imageView.image = UIImage(data: imageData)
        } else {
            let imageData = try! Data(contentsOf:URL(string: radioList.myFavoriteStations[indexPath.row].radioLogo)!)
            Cell.imageView.image = UIImage(data: imageData)
        }
        return Cell
    }
}

//MARK: CollectionView Extention
extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.width / 2.06
        return CGSize(width: screenSize, height: screenSize)
    }
}

extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ChoosedRadioRowNumber = indexPath.row
        if segmentIndex == 0 {
            playSound(url: radioList.listOfRadios[indexPath.row].radioLink)
            playPauseOutlet.setTitle(">>", for: UIControl.State.normal)
            let imageData = try! Data(contentsOf:URL(string: radioList.listOfRadios[indexPath.row].radioLogo)!)
            logoImageView.image = UIImage(data: imageData)
            radioTitleLabel.text = radioList.listOfRadios[indexPath.row].radioName
            
        } else {
            playSound(url: radioList.myFavoriteStations[indexPath.row].radioLink)
            playPauseOutlet.setTitle(">>", for: UIControl.State.normal)
            let imageData = try! Data(contentsOf:URL(string: radioList.myFavoriteStations[indexPath.row].radioLogo)!)
            logoImageView.image = UIImage(data: imageData)
            radioTitleLabel.text = radioList.myFavoriteStations[indexPath.row].radioName
        }
        if radioList.listOfRadios[indexPath.row].isMyFavorite == true {
            myFavouriteOutlet.backgroundColor = .cyan
        } else {
            myFavouriteOutlet.backgroundColor = .clear
        }
    }
    
 //MARK: Methods
    
    private func playSound(url: String) {
        guard let url = URL.init(string: url)
        else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        player?.play()
    }
    
    private func defaultRadioStaions() {
        radioList.addNewStation(name: "BBC New", logo: "https://ichef.bbci.co.uk/images/ic/256xn/p07grdrd.jpg", link: "http://vprbbc.streamguys.net:80/vprbbc24.mp3", myFavourite: false)
        radioList.addNewStation(name: "Magic Radio", logo: "https://is3-ssl.mzstatic.com/image/thumb/Purple125/v4/51/08/72/510872a8-b366-a680-4608-b2c651ec72b9/source/256x256bb.jpg", link: "http://uk4.internet-radio.com:8004/", myFavourite: false)
        radioList.addNewStation(name: "Kral Londra", logo: "https://is5-ssl.mzstatic.com/image/thumb/Purple113/v4/16/78/72/16787265-f43d-c8a9-5d8d-a0a9858a907a/source/512x512bb.jpg", link: "http://46.20.4.5:9500/;", myFavourite: false)
        radioList.addNewStation(name: "Smooth Jazz", logo: "https://is5-ssl.mzstatic.com/image/thumb/Purple/v4/7d/40/81/7d4081c1-6108-45fe-c09f-196e65a8f5cf/source/256x256bb.jpg", link: "http://us4.internet-radio.com:8266/", myFavourite: false)
        radioList.addNewStation(name: "RadioFlorida", logo: "https://source.boomplaymusic.com/group10/M00/05/31/1106f6c8dec94e19a6cfa4b22309205d.jpg", link: "http://us5.internet-radio.com:8283/", myFavourite: false)
        radioList.addNewStation(name: "RockFm", logo: "https://a.thumbs.redditmedia.com/iP0ZJWdm49JpxaiaNgu7PhFTFiBw5aABWsdgJy8yXj8.png", link: "http://us4.internet-radio.com:8258/", myFavourite: false)
        radioList.addNewStation(name: "RadioBlues", logo: "https://static.mytuner.mobi/media/tvos_radios/UghsJznKt6.png", link: "http://us2.internet-radio.com:8443/", myFavourite: false)
        radioList.addNewStation(name: "Megaton Radio", logo: "https://dbs.radioline.fr/pictures/radio_d810f69534c66aec681bd39c3e76c1bf/logo200.jpg?size=600", link: "http://us2.internet-radio.com:8443/", myFavourite: false)
    }
}


