//
//  PlayerViewController.swift
//  MyMusicPlayer
//
//  Created by Alexey Mokrousov on 27/9/23.
//

import Foundation
import UIKit

class PlayerViewController: UIViewController {
    var musicPlayer: MyPlayer!
    
    private var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemPink
        let image = UIImage()
        
        return imageView
    }()
    
    private var trackNameLabel: UILabel = {
        var label = UILabel()
        label.text = "default"
        return label
    }()
    
    private var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .blue
        progressView.progressTintColor = .yellow
        return progressView
    }()
    
    private var playPauseButton: PlayPauseButton = {
        var button = PlayPauseButton()
        return button
    }()
    
    private var previousbutton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        
        return button
    }()
    
   private var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle
    
    public init(player: MyPlayer) {
        self.musicPlayer = player
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9424937963, blue: 0.7806524634, alpha: 1)
        
        previousbutton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        setupUI()
    }
    
    // MARK: - Player Controlling
    
    @objc func play() {
        musicPlayer.play()
       
    }
    
    @objc func pause() {
        musicPlayer.pause()
    }
    
    @objc func previousButtonTapped() {
        musicPlayer.previousTrack()
        print("PREVIOUS BUTTON TAPPED")
    }
    
    @objc func nextButtonTapped() {
        musicPlayer.nextTrack()
        print("NEXT BUTTON TAPPED")
    }
    

    
    // MARK: - UI Setup
    
    func setupUI() {
        
        view.addSubview(coverImageView)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 8 ),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 1)
        ])
        
        view.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackNameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            trackNameLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor)
        ])
        
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor)
        ])
        
        view.addSubview(playPauseButton)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playPauseButton.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            playPauseButton.centerXAnchor.constraint(equalTo: progressView.centerXAnchor)
        ])
        
        view.addSubview(previousbutton)
        previousbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previousbutton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            previousbutton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -10)
        ])
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 10)
        ])
    }
    
    
}
