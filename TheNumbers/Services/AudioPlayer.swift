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
    var trackListArray: [TrackModel] { get set }
    func createPlayerQueue()
    func loadTracksFunc()
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
         loadTracksFunc()
         trackListArray.forEach { track in
            let asset = AVURLAsset(url: track.url)
            let item = AVPlayerItem(asset: asset)
            audioPlayerService.queuePlayer.insert(item, after: audioPlayerService.queuePlayer.items().last)
        }
    }
    //TracksList
    var trackFirst = TrackModel(name: "FeelingGood", url: URL(fileURLWithPath: Bundle.main.path(forResource: "FeelingGood", ofType: "mp3") ?? ""))
    
}

//MARK: Service
final class AudioPlayerService {
    //queue player
    var queuePlayer = AVQueuePlayer()
    
    //func play track
    func playTrack() {
        queuePlayer.play()
    }
}

