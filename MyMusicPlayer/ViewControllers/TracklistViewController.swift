//
//  TracklistViewController.swift
//  MyMusicPlayer
//
//  Created by Alexey Mokrousov on 25/9/23.
//

import Foundation
import UIKit
import AVFoundation
import Combine

class TracklistViewController: UIViewController {
    
    private var cancallables = Set<AnyCancellable>()
    
    var collectionView: UICollectionView!
    var tracksService = TracksService()
    var myPlayer: MyPlayer!
    
    var isFirstTap = false
    
    lazy var playerSmallView: PlayerSmallView = {
        let playerView = PlayerSmallView()
        view.addSubview(playerView)
        return playerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        myPlayer = MyPlayer(service: tracksService)
        
        configureUI()
    
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: "TracklistCell")
        
        myPlayer.$currentTime
        .map { value in return Float(value) }
            .sink { newValue in
                print(newValue)
                self.playerSmallView.progressView.setProgress(newValue, animated: false)
            }
            .store(in: &cancallables)
    }
    
    func activatePlayerSmallView() {
        playerSmallView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        playerSmallView.isPlaying.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func configureUI() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .darkGray
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension TracklistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TracklistCell", for: indexPath) as! TrackCell
        
        cell.configure(track: tracksService.tracks[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell Did Tapped for \(indexPath)")
       
      
        myPlayer.configureAudioPlayer(trackIndex: indexPath.row)
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? TrackCell {
            selectedCell.showPlayAnimation()
            playerSmallView.nameLabel.text = tracksService.tracks[indexPath.row].name
            
        }
        
        guard isFirstTap else {
            isFirstTap = true
            activatePlayerSmallView()
            return
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath) deselected")
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? TrackCell {
            selectedCell.removePlayAnimation()
        }
    }
    
}

extension TracklistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}


