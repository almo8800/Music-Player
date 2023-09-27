//
//  FileManager.swift
//  MyMusicPlayer
//
//  Created by Alexey Mokrousov on 25/9/23.
//

import Foundation
import AVFoundation

class TracksService {
    
    var tracks: [Track] = []
    
    init() {
        
    }
    
    let queue = DispatchQueue(label: "background")
    
    func configureSongs(completion: @escaping ([Track]) -> Void)  {
        
        queue.async {
            var fetchedTracks: [Track] = []
            
            if let folderURL = Bundle.main.resourceURL {
                
                do {
                    let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
                    
                    let mp3FileURLs = fileURLs.filter { $0.pathExtension == "mp3" }
                    
                    for url in mp3FileURLs {
                        let trackName = url.lastPathComponent
                        let trackFilePath = url.path
                        let track = Track(name: trackName, filePath: trackFilePath)
                        fetchedTracks.append(track)
                    }
                } catch {
                    print("Error: \(error)")
                }
                
            }
            
            DispatchQueue.main.async {
                self.tracks = fetchedTracks
                completion(fetchedTracks)
            }
            
        }
    }
}
