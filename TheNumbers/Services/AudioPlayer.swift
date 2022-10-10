//
//  AudioPlayer.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 1.10.22.
//

//вы предоставите ссылку на AudioTrimmer в титрах вашего проекта. Пример:
//Музыка: https://audiotrimmer.com/ru/royalty-free-music/

import Foundation
import MediaPlayer

//MARK: Protocol
protocol AudioPlayerProtocol {
    var  trackListArray: [TrackModel] { get set }
    func createPlayerQueue()
    func repeatPlaylistFunc()
}

//MARK: ClassVM
class AudioPlayerVM: AudioPlayerProtocol {
    let queue = DispatchQueue.global(qos: .utility)
    //Service var
    let audioPlayerService = AudioPlayerService()
    //Track array
    var trackListArray: [TrackModel] = []
    //Load track
    func loadTracksFunc() {
//        DispatchQueue.global(qos: .utility).async {
            self.trackListArray.append(self.trackFirst)
            self.trackListArray.append(self.trackSecond)
            self.trackListArray.append(self.trackThird)
            self.trackListArray.append(self.trackFour)
            self.trackListArray.append(self.trackFive)
//        }
       
    }
    
    
    //Create audio queue and play that list
    func createPlayerQueue() {
            self.trackListArray.removeAll()
            self.loadTracksFunc()
            trackListArray.shuffle()
            self.trackListArray.forEach { track in
               let asset = AVURLAsset(url: track.url)
               let item = AVPlayerItem(asset: asset)
                self.audioPlayerService.queuePlayer.insert(item, after: self.audioPlayerService.queuePlayer.items().last)
           }
    }
    
    func repeatPlaylistFunc() {
        
        audioPlayerService.token = audioPlayerService.queuePlayer.observe(\.currentItem, changeHandler: {
             (player, _) in
           
            if self.audioPlayerService.queuePlayer.items().count == 1 {
                self.createPlayerQueue() }
        })
    }
    
    //TracksList
    var trackFirst = TrackModel(name: "FeelingGood", url: URL(fileURLWithPath: Bundle.main.path(forResource: "FeelingGood", ofType: "mp3") ?? ""))
    var trackSecond = TrackModel(name: "LittlePrankster", url: URL(fileURLWithPath: Bundle.main.path(forResource: "LittlePrankster", ofType: "mp3") ?? ""))
    var trackThird = TrackModel(name: "SummerHouse", url: URL(fileURLWithPath: Bundle.main.path(forResource: "SummerHouse", ofType: "mp3") ?? ""))
    var trackFour = TrackModel(name: "TheGoodLife", url: URL(fileURLWithPath: Bundle.main.path(forResource: "TheGoodLife", ofType: "mp3") ?? ""))
    var trackFive = TrackModel(name: "FeelingGood", url: URL(fileURLWithPath: Bundle.main.path(forResource: "FeelingGood", ofType: "mp3") ?? ""))
    
}

//MARK: Service
final class AudioPlayerService {
    //queue player
   @objc var queuePlayer = AVQueuePlayer()
   var token: NSKeyValueObservation?
    
    
    //func play track
    func playTrack() {
      
            queuePlayer.volume = 0.28
            queuePlayer.play()
       
      
    }
    
    //func play track
    func pauseTrack() {
        queuePlayer.pause()
    }
}

