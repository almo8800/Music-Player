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
    var customTimer: CustomTimer!
    
    // MARK: - Output
    
    @Published public var currentTrackIndex: Int = 0 {
        didSet {
        }
    }

    @Published var currentTime: TimeInterval = 0
    
    public var tracks: [Track] {
        tracksService.tracks
    }
    
    public var currentTrack: Track {
        tracks[currentTrackIndex]
    }
    
    init(service: TracksService) {
        
        self.tracksService = service
        self.customTimer = CustomTimer()
       
        customTimer.$elapsedTime
            .sink { newValue in
                print(newValue)
                let value = newValue / self.avAudioPlayer.duration
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
        let musicAsset = AVAsset(url: url)
    
        musicAsset.loadMetadata(for: .id3Metadata) { result, error in
            if let result = result {
                print(result)
            }
            if let error = error {
                print(error)
            }
        }
       
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: url)
            avAudioPlayer.volume = 0.1
            let startTimeInSeconds: TimeInterval = 165
            //avAudioPlayer.currentTime = startTimeInSeconds
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
        
        if avAudioPlayer.isPlaying {
            avAudioPlayer.pause()
        } else {
        }
        
        customTimer.isRunning = false
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
            configureAudioPlayer(trackIndex: currentTrackIndex)
        }
    }
    
    func nextTrack() {
        if currentTrackIndex < tracks.count - 1 {
            currentTrackIndex += 1
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


