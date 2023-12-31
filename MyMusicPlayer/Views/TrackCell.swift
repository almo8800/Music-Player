//
//  TrackCell.swift
//  MyMusicPlayer
//
//  Created by Alexey Mokrousov on 26/9/23.
//

import Foundation
import UIKit

class TrackCell: UICollectionViewCell {
    
    private let trackCoverView: UIImageView = {
        var image = UIImage(systemName: "airpodsmax")
        var imageView = UIImageView(image: image)
        
        return imageView
    }()
    
   private let playAnimationView: UIImageView = {
        let dimension: CGFloat = 20 // Specify the desired size of the circle view
           
           let playAnimationView = UIImageView(frame: CGRect(x: 0, y: 0, width: dimension, height: dimension))
           playAnimationView.alpha = 0
        
           playAnimationView.contentMode = .scaleAspectFit
           playAnimationView.backgroundColor = .magenta
           playAnimationView.layer.cornerRadius = dimension / 2
           playAnimationView.clipsToBounds = true
           
           let animation = CABasicAnimation(keyPath: "transform.scale")
           animation.duration = 0.5
           animation.repeatCount = .infinity
           animation.autoreverses = true
           animation.fromValue = 0.7
           animation.toValue = 1.2
           
           playAnimationView.layer.add(animation, forKey: "scaleAnimation")
           
           return playAnimationView
    }()
    
    private var trackNameLabel: UILabel = {
       var label = UILabel()
       label.font = UIFont.boldSystemFont(ofSize: 16)
       return label
    }()
    private var artistNameLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(track: Track) {
        self.trackNameLabel.text = track.name
        self.artistNameLabel.text = track.artist
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        contentView.backgroundColor = #colorLiteral(red: 1, green: 0.9424937963, blue: 0.7806524634, alpha: 1)
        contentView.addSubview(trackCoverView)
        
        trackCoverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackCoverView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            trackCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            trackCoverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            trackCoverView.widthAnchor.constraint(equalTo: trackCoverView.heightAnchor)
        ])
        
        trackCoverView.addSubview(playAnimationView)
        playAnimationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playAnimationView.centerXAnchor.constraint(equalTo: trackCoverView.centerXAnchor),
            playAnimationView.centerYAnchor.constraint(equalTo: trackCoverView.centerYAnchor),
            playAnimationView.heightAnchor.constraint(equalTo: trackCoverView.heightAnchor, multiplier: 0.3),
            playAnimationView.widthAnchor.constraint(equalTo: playAnimationView.heightAnchor)
        ])
       
        contentView.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            trackNameLabel.leadingAnchor.constraint(equalTo: trackCoverView.trailingAnchor, constant: 5),
            trackNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5)
        ])
        
        contentView.addSubview(artistNameLabel)
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 0),
            artistNameLabel.leadingAnchor.constraint(equalTo: trackCoverView.trailingAnchor, constant: 5),
            trackNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5)
        ])
    }
}

//MARK: - UI Events

extension TrackCell {
    func showPlayAnimation() {
        playAnimationView.alpha = 1
    }
    func removePlayAnimation() {
        playAnimationView.alpha = 0
    }
}
