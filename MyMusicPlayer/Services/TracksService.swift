//
//  FileManager.swift
//  MyMusicPlayer
//
//  Created by Alexey Mokrousov on 25/9/23.
//

import Foundation
import AVFoundation

enum TrackServiceError: Error {
    case badFolderUrl
    case wrongContentDirectory
}

class TracksService {
    
    var tracks: [Track] = []
    let queue = DispatchQueue(label: "background")
    
    func configureSongs(completion: @escaping (Result<[Track], TrackServiceError>) -> Void)  {
        let completionOnMain = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        queue.async {
            var fetchedTracks: [Track] = []
            let group = DispatchGroup()
            
            guard let folderURL = Bundle.main.resourceURL else {
                completionOnMain(.failure(.badFolderUrl))
                return
            }
            
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
                let mp3FileURLs = fileURLs.filter { $0.pathExtension == "mp3" }
                for url in mp3FileURLs {
                    
                    var trackName: String?
                    var artistName: String?
                    var imageData: Data?
                    let musicAsset = AVAsset(url: url)
                    
                    group.enter()
                    musicAsset.loadMetadata(for: .id3Metadata) { result, error in
                        if let result = result {
                            
                            for item in result {
                                guard let commonKey = item.commonKey?.rawValue,
                                      let value = item.value else { continue }
                                
                                if commonKey == AVMetadataKey.commonKeyTitle.rawValue {
                                    trackName = value as? String
                                }
                        
                                if commonKey == AVMetadataKey.commonKeyArtist.rawValue {
                                    artistName = value as? String
                                }
                                
                                if commonKey == AVMetadataKey.commonKeyArtwork.rawValue,
                                   let data = value as? Data {
                                    imageData = data
                                }
                            }
                        }
                        
                        if let error = error {
                            print(error)
                        }
                        
                        let trackFilePath = url.path
                        let track = Track(
                            name: trackName ?? "unkwown track",
                            artist: artistName ?? "unknown artist",
                            imageData: imageData,
                            filePath: trackFilePath)
                       
                        DispatchQueue.main.async {
                            fetchedTracks.append(track)
                            group.leave()
                        }
                    }
                    
                }
                group.notify(queue: .main) {
                    print("Fetched TRACKS \(fetchedTracks.count)")
                    self.tracks = fetchedTracks
                    completion(.success(fetchedTracks))
                }
            } catch {
                completionOnMain(.failure(.wrongContentDirectory))
            }
        }
    }
}
