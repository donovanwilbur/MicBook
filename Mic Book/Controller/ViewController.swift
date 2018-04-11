//
//  ViewController.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 1/17/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var homeScreenCards: [HomeScreenCard] = [ HomeScreenCard(image: #imageLiteral(resourceName: "Mic Specs"), title: "Microphone Specifications"),
                                              HomeScreenCard(image: #imageLiteral(resourceName: "Audio Samples Instruments"), title: "Audio Samples Organized by Instrument"),
                                              HomeScreenCard(image: #imageLiteral(resourceName: "Audio Samples Microphones"), title: "Audio Samples Organized by Microphone")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - UICollectionViewDataSource Methods
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeScreenCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeScreenCollectionViewCell
        
        cell.configureCell(with: homeScreenCards[indexPath.row])
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate Methods
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var identifier = String()
        switch indexPath.row {
        case 0: identifier = "micSpecsCollectionVC"
        case 1: identifier = "audioSamplesByInstrumentVC"
        case 2: identifier = "audioSamplesByMicVC"
        default: return
        }
        performSegue(withIdentifier: identifier, sender: nil)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout Methods
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionView.bounds.height * 0.8
        let cellWidth = collectionView.bounds.width - 50
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
}
