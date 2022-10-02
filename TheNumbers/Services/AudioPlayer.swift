//
//  AudioPlayer.swift
//  TheNumbers
//
//  Created by Alinser Shchurko on 1.10.22.
//

import Foundation
import MediaPlayer

class AudioPlayer {
    var track = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "FeelingGood", ofType: "mp3") ?? ""))
}


