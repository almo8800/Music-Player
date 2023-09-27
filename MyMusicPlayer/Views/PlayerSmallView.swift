//
//  PlayerSmallView.swift
//  MyMusicPlayer
//
//  Created by Alexey Mokrousov on 26/9/23.
//

import Foundation
import UIKit

private enum State {
    case normal
    case opening
}

class PlayerSmallView: UIView {
    
    
    // MARK: - User Interface
    
    var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = .blue
        progressView.progressTintColor = .yellow

        return progressView
    }()
    
    var nameLabel: UILabel = {
        var label = UILabel()
        label.text = "default"
        return label
    }()
    
    var timeLabel: UILabel = {
       var label = UILabel()
       return label
    }()
    


    
    var playAndStopButton: UIButton = {
        var button = UIButton(type: .system)
        button.tintColor = .white
        
        var pauseImage = UIImage(systemName: "pause.fill")
        
        button.setImage(pauseImage, for: .normal)
        button.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Properties
    
  
    var playImage = UIImage(systemName: "play.fill")
    var pauseImage = UIImage(systemName: "pause.fill")
    
    var isPlaying = false
    private var topConstant = NSLayoutConstraint()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
        
        self.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func playPauseTapped() {
        isPlaying.toggle()
        
        if isPlaying {
            playAndStopButton.setImage(pauseImage, for: .normal)
        } else {
            playAndStopButton.setImage(playImage, for: .normal)
        }
    }
        
    override func didMoveToSuperview() {
        if let superview = superview {
            NSLayoutConstraint.activate([
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0),
                widthAnchor.constraint(equalTo: superview.widthAnchor, constant: 0)
            ])
            
            topConstant = self.topAnchor.constraint(equalTo: superview.bottomAnchor, constant: -120)
            topConstant.isActive = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupUI() {
        // Progress View Setup
        addSubview(progressView)
        progressView.setProgress(0, animated: true)
        progressView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                progressView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
              
                progressView.heightAnchor.constraint(equalToConstant: 2)
            ])
        
        // TrackNameLabel Setup
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
        
        // PlayPause Button
        addSubview(playAndStopButton)
        playAndStopButton.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                playAndStopButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                playAndStopButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                playAndStopButton.widthAnchor.constraint(equalToConstant: 30),
                playAndStopButton.heightAnchor.constraint(equalTo: playAndStopButton.widthAnchor)
             ])
        

        }
    }


extension PlayerSmallView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            var cornerMask = CACornerMask()
            if(corners.contains(.topLeft)){
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if(corners.contains(.topRight)){
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if(corners.contains(.bottomLeft)){
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if(corners.contains(.bottomRight)){
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
}

