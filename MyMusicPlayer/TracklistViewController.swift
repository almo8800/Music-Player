//
//  TracklistViewController.swift
//  MyMusicPlayer
//
//  Created by Alexey Mokrousov on 25/9/23.
//

import Foundation
import UIKit

class TracklistViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        configureUI()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: "TracklistCell")
        collectionView.backgroundColor = .yellow
      
        
    }
    
    func configureUI() {
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
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TracklistCell", for: indexPath) as! TrackCell
        cell.trackNameLabel.text = "HERE I AM"
        return cell
    }
    
   
}

extension TracklistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
}

class TrackCell: UICollectionViewCell {
    
    
    let trackCoverView = UIImageView()
    let playAnimationView = UIImageView()
    
    let trackNameLabel = UILabel()
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        contentView.backgroundColor = .gray
        
        trackCoverView.backgroundColor = .white
        contentView.addSubview(trackCoverView)
        
        trackCoverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackCoverView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            trackCoverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            trackCoverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            trackCoverView.widthAnchor.constraint(equalTo: trackCoverView.heightAnchor)
        ])
       
        
        trackNameLabel.backgroundColor = .blue
        contentView.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            trackNameLabel.leadingAnchor.constraint(equalTo: trackCoverView.trailingAnchor, constant: 5),
            trackNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
            trackNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
