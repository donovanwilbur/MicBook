//
//  MicSpecsCollectionVC.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 1/20/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import UIKit
import FirebaseStorageUI

class MicSpecsCollectionVC: UIViewController {

    @IBOutlet weak var sectionHeaderImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var micGroups: [MicrophoneGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Mic Specifications"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        fetchMicrophones()
    }

    func fetchMicrophones() {
        FirebaseService.shared.fetchMicrophones { (microphones) in
            self.organizeMicrophonesIntoGroups(microphones)
        }
    }
    
    func organizeMicrophonesIntoGroups(_ microphones: [Microphone]) {
        let sortedMicrophones = microphones.sorted { $0.brand!.name! > $1.brand!.name! }
        
        for mic in sortedMicrophones {
            if micGroups.isEmpty {
                let micGroup = MicrophoneGroup()
                micGroup.brand = mic.brand
                micGroup.microphones.append(mic)
                micGroups.append(micGroup)
            } else if let micGroup = micGroups.last {
                if micGroup.brand?.name == mic.brand?.name {
                    micGroup.microphones.append(mic)
                } else {
                    let micGroup = MicrophoneGroup()
                    micGroup.brand = mic.brand
                    micGroup.microphones.append(mic)
                    micGroups.append(micGroup)
                }
            }
        }
        collectionView.reloadData()
    }
    
    func showError(withMessage message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "micSpecsDetailsVC" {
            if let nextVC = segue.destination as? MicSpecsDetailsVC {
                if let mic = sender as? Microphone {
                    nextVC.mic = mic
                }
            }
        }
    }
}

class MicrophoneGroup : NSObject {
    var brand: Brand?
    var microphones: [Microphone] = []
}

//MARK: - UICollectionViewDataSource Methods
extension MicSpecsCollectionVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return micGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return micGroups[section].microphones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MicSpecsCollectionViewCell.reuseIdentifier, for: indexPath) as! MicSpecsCollectionViewCell
        let mic = micGroups[indexPath.section].microphones[indexPath.row]
        cell.micNameLabel.text = mic.name
        if let name = mic.name, let ext = mic.imageExt {
            cell.imageView.contentMode = .scaleAspectFit
            cell.imageView.sd_setImage(with: FirebaseService.shared.MICROPHONES_STORAGE_REF.child("\(name).\(ext)"))
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate Methods
extension MicSpecsCollectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mic = micGroups[indexPath.section].microphones[indexPath.row]
        performSegue(withIdentifier: "micSpecsDetailsVC", sender: mic)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MicSpecsCollectionSectionHeaderView.reuseIdentifier, for: indexPath) as! MicSpecsCollectionSectionHeaderView
            let brand = micGroups[indexPath.section].brand
            if let name = brand?.name, let ext = brand?.imageExt {
                headerView.brandImageView.sd_setImage(with: FirebaseService.shared.BRAND_STORAGE_REF.child("\(name).\(ext)"))
            }
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout Methods
extension MicSpecsCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentWidth = collectionView.bounds.width - 32
        let cellWidth = contentWidth / 3
        let cellHeight = cellWidth * 1.25
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
