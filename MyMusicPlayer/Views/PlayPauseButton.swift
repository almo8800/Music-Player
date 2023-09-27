//
//  PlayPauseButton.swift
//  MyMusicPlayer
//
//  Created by Alexey Mokrousov on 27/9/23.
//

import Foundation
import UIKit

class PlayPauseButton: UIButton {
    
    enum ButtonState {
        case play
        case pause
    }
    
    var buttonState: ButtonState = .play {
        didSet {
            switch buttonState {
            case .play:
                self.setImage(pauseImage, for: .normal)
            case .pause:
                self.setImage(playImage, for: .normal)
            }
        }
    }

    
    private let playImage = UIImage(systemName: "play.fill")
    private let pauseImage = UIImage(systemName: "pause.fill")
    
    init() {
        super.init(frame: .zero)
        self.tintColor = .red
        self.setImage(pauseImage, for: .normal)
        configureButton()
        print(buttonState)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButton() {
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        switch buttonState {
        case .play:
            buttonState = .pause
        case .pause:
            buttonState = .play
        }
        
    }
    
}
