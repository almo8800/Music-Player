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

class MyPlayer {
    
    private var cancallables = Set<AnyCancellable>()
    
    var avAudioPlayer = AVAudioPlayer()
    var tracksService: TracksService!
    var customTimer: Stopwatch!
    
    // MARK: - Output
    
    @Published public var currentTrackIndex: Int = 0 {
        didSet {
        }
    }

    @Published var currentTime: TimeInterval = 0
    
    public var tracks: [Track] {
        tracksService.tracks
    }
    
    init(service: TracksService) {
        
        self.tracksService = service
        self.customTimer = Stopwatch()
       
        customTimer.$elapsedTime
            .sink { newValue in
                // НЕПРАВИЛЬНО СЧИТАЕТ (где-то надо делить на duration??)
                let value = newValue / 100
                self.currentTime = value
            }
            .store(in: &cancallables)
    }
    
    func configureAudioPlayer(trackIndex: Int? = nil) {
       
        if let newindex = trackIndex {
            currentTrackIndex = newindex
        }

        let currentTrack = tracks[currentTrackIndex]
        let url = URL(filePath: currentTrack.filePath)
        
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: url)
            avAudioPlayer.volume = 0.1
            let startTimeInSeconds: TimeInterval = 165
            avAudioPlayer.currentTime = startTimeInSeconds
           
        }
        catch {
            print(error)
        }
       
        self.play()
    }
    
    func play() {
       
        customTimer.isRunning = true
        avAudioPlayer.play()
       
    }
    
    func pause() {
        //customTimer.reset()
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
    
    func previousTrack() {
        if currentTrackIndex > 0 {
            currentTrackIndex -= 1
            //avAudioPlayer.pause()
            configureAudioPlayer(trackIndex: currentTrackIndex)
        }
    }
    
    func nextTrack() {
        if currentTrackIndex < tracks.count - 1 {
            currentTrackIndex += 1
            //avAudioPlayer.pause()
            configureAudioPlayer(trackIndex: currentTrackIndex)
        }
    }
}

extension MyPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("YES")
    }
    
    func isEqual(_ object: Any?) -> Bool {
        return true
    }
    
    var hash: Int {
        5
    }
    
    var superclass: AnyClass? {
        nil
    }
    
    func `self`() -> Self {
        self
    }
    
    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        nil
    }
    
    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        nil
    }
    
    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        nil
    }
    
    func isProxy() -> Bool {
        false
    }
    
    func isKind(of aClass: AnyClass) -> Bool {
        false
    }
    
    func isMember(of aClass: AnyClass) -> Bool {
        false
    }
    
    func conforms(to aProtocol: Protocol) -> Bool {
        false
    }
    
    func responds(to aSelector: Selector!) -> Bool {
        false
    }
    
    var description: String {
        "need conformance"
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
