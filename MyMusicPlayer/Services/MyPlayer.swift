//
//  AVPlayer.swift
//  MyMusicPlayer
//
//  Created by Alexey Mokrousov on 25/9/23.
//

import Foundation
import UIKit
import AVFoundation
import Combine

//var audioPlayer: AVAudioPlayer!

class MyPlayer {
    
    private var cancallables = Set<AnyCancellable>()
    
    var avAudioPlayer: AVAudioPlayer!
    var tracksService: TracksService!
    var customTimer: Stopwatch!
    
    public var songPosition: Int = 0 // would be an indexPath.row of collectionView
    public var tracks: [Track] = []
    
    private var cancellables = Set<AnyCancellable>()
    @Published var currentTime: TimeInterval = 0
    
   
    init(service: TracksService) {
        
        self.tracksService = service
        tracks = tracksService.tracks
        self.customTimer = Stopwatch()
        
        customTimer.$elapsedTime
            .sink { newValue in
                // НЕПРАВИЛЬНО СЧИТАЕТ (где-то надо делить на duration??)
                let value = newValue / 100
                self.currentTime = value
                print(newValue)
            }
            .store(in: &cancallables)
        
    }
    
    
    func configureAudioPlayer(trackIndex: Int? = nil) {
        
        var index = songPosition
        
        if let trackindex = trackIndex {
            index = trackindex
        }
        
        let currentTrack = tracks[index]
        let url = URL(filePath: currentTrack.filePath)
        
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            print(error)
        }
        
        avAudioPlayer.prepareToPlay()
        self.play()
       
        
        
    }
    
    func play() {
        customTimer.isRunning = true
        avAudioPlayer.play()
    }
    
    func pause() {
        customTimer.reset()
        if avAudioPlayer.isPlaying {
            avAudioPlayer.pause()
        } else {
        }
    }
    
    func restart() {
        if avAudioPlayer.isPlaying {
            avAudioPlayer.currentTime = 0
            avAudioPlayer.play()
        } else {
        }
    }
    
    func previous() {
        if songPosition > 0 {
            songPosition -= 1
            avAudioPlayer.pause()
        }
        
        func next() {
            if songPosition < tracks.count - 1 {
                songPosition += 1
                avAudioPlayer.pause()
            }
        }
        
    }
    
}

class Stopwatch: ObservableObject {
    private var startTime: Date?
    private var accumulatedTime:TimeInterval = 0
    private var timer: Cancellable?
    
    @Published var isRunning = false {
        didSet {
            if self.isRunning {
                self.start()
            } else {
                self.stop()
            }
        }
    }
    
    @Published private(set) var elapsedTime: TimeInterval = 0
    
    private func start() -> Void {
        self.startTime = Date()
        self.timer?.cancel()
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.elapsedTime = self.getElapsedTime()
            }
    }
    private func stop() -> Void {
        self.timer?.cancel()
        self.timer = nil
        self.accumulatedTime = self.elapsedTime
        self.startTime = nil
    }
    func reset() -> Void {
        self.accumulatedTime = 0
        self.elapsedTime = 0
        self.startTime = nil
        self.isRunning = false
    }
    private func getElapsedTime() -> TimeInterval {
        return -(self.startTime?.timeIntervalSinceNow ??     0)+self.accumulatedTime
    }
}
