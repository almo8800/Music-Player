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
    
    //MARK: - User Interface
    private var collectionView: UICollectionView!
    lazy var playerSmallView: PlayerSmallView = {
        let playerView = PlayerSmallView()
        view.addSubview(playerView)
        return playerView
    }()
    
    //MARK: - Properties
    
    var tracksService = TracksService()
    var myPlayer: MyPlayer!
    
    private var playingTrackIndex: Int? = nil {
        didSet {
            if let oldValue = oldValue {
                handlePlayCellIndicator(index: oldValue, needToShow: false)
            }
        }
    }
    
    private var isFirstTap = false
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        configureUI()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: "TracklistCell")
        
        myPlayer = MyPlayer(service: tracksService)
        playerSmallView.delegate = self
        bindingFromPlayer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: - Binding from Player
    
    private func bindingFromPlayer() {
        myPlayer.$currentTime
        .map { value in return Float(value) }
            .sink { newValue in
                self.playerSmallView.progressView.setProgress(newValue, animated: false)
            }
            .store(in: &cancallables)
        
        myPlayer.$currentTrackIndex
            .sink { trackIndex in
                self.playingTrackIndex = trackIndex
                print("должна быть \(trackIndex) ячейка нв вью контроллере")
                self.playerSmallViewConfigure(trackIndex: trackIndex)
                self.handlePlayCellIndicator(index: trackIndex, needToShow: false)
                self.handlePlayCellIndicator(index: trackIndex, needToShow: true)
            }
            .store(in: &cancallables)
        
        tracksService.configureSongs { result in
            switch result {
            case .success:
                self.collectionView.reloadData()
            case .failure:
                print("Problem configure songs ")
            }
        }
    }
    
    private func activatePlayerSmallView() {
        playerSmallView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        playerSmallView.isPlaying.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func configureUI() {
        
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

// MARK: - UICollectionViewDelegatem, UICollectionViewDataSource

extension TracklistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracksService.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TracklistCell", for: indexPath) as! TrackCell
        
        cell.configure(track: tracksService.tracks[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myPlayer.configureAudioPlayer(trackIndex: indexPath.row)
        myPlayer.avAudioPlayer.delegate = self
        playerSmallView.playAndStopButton.buttonState = .play
        playerSmallViewConfigure(trackIndex: indexPath.row)
        handlePlayCellIndicator(index: indexPath.row, needToShow: true)
        
        guard isFirstTap else {
            isFirstTap = true
            activatePlayerSmallView()
            return
        }
    }
    
    private func playerSmallViewConfigure(trackIndex: Int) {
        guard tracksService.tracks.count != 0 else { return }
        playerSmallView.nameLabel.text = tracksService.tracks[trackIndex].name
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        handlePlayCellIndicator(index: indexPath.row, needToShow: false)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension TracklistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}

extension TracklistViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let currentTrackIndex = myPlayer.currentTrackIndex
        handlePlayCellIndicator(index: currentTrackIndex, needToShow: false)
        myPlayer.nextTrack()
    }
}

extension TracklistViewController {
    private func handlePlayCellIndicator(index: Int, needToShow: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? TrackCell {
            if needToShow {
                selectedCell.showPlayAnimation()
            } else {
                selectedCell.removePlayAnimation()
            }
        }
    }
}

extension TracklistViewController: PlayerSmallViewDelegate {
    func goToPlayer() {
        let playerViewController = PlayerViewController(player: myPlayer)
        self.navigationController?.present(playerViewController, animated: true)
    }
    
    func playPauseButtonDidTapped(with state: PlayPauseButton.ButtonState) {
        switch state {
            case .pause:
            myPlayer.pause()
            case .play:
            myPlayer.play()
        }
    }
}




