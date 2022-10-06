//
//  AudioPlayer.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 1.10.22.
//

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
    
    //Service var
    let audioPlayerService = AudioPlayerService()
    //Track array
    var trackListArray: [TrackModel] = []
    //Load track
    func loadTracksFunc() {
        trackListArray.append(trackFirst)
    }
    
    
    //Create audio queue and play that list
    func createPlayerQueue() {
        DispatchQueue.global(qos: .userInitiated).async {
           
            self.trackListArray.removeAll()
            self.loadTracksFunc()
            self.trackListArray.forEach { track in
               let asset = AVURLAsset(url: track.url)
               let item = AVPlayerItem(asset: asset)
                self.audioPlayerService.queuePlayer.insert(item, after: self.audioPlayerService.queuePlayer.items().last)
           }
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

