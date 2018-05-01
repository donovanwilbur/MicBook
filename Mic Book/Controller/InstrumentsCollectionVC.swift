//
//  InstrumentsCollectionVC.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 4/17/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import UIKit

class InstrumentsCollectionVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var instruments: [Instrument] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Instruments"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        if FirebaseService.shared.microphones.isEmpty {
            FirebaseService.shared.fetchMicrophones { (_) in
                self.fetchInstruments()
            }
        } else {
            fetchInstruments()
        }
    }
    
    func fetchInstruments() {
        FirebaseService.shared.fetchInstruments { (instruments) in
            self.instruments = instruments
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "instrumentDetailsVC" {
            if let nextVC = segue.destination as? InstrumentDetailsVC {
                if let instrument = sender as? Instrument {
                    nextVC.instrument = instrument
                }
            }
        }
    }
}

//MARK: - UICollectionViewDataSource Methods
extension InstrumentsCollectionVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instruments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstrumentCollectionViewCell.reuseIdentifier, for: indexPath) as! InstrumentCollectionViewCell
        let instrument = instruments[indexPath.row]
        if let name = instrument.name, let ext = instrument.imageExt {
            cell.imageView.sd_setImage(with: FirebaseService.shared.INSTRUMENT_ICONS_STORAGE_REF.child("\(name).\(ext)"))
        }
        cell.nameLabel.text = instrument.name
        return cell
    }
}

//MARK: - UICollectionViewDelegate Methods
extension InstrumentsCollectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let instrument = instruments[indexPath.row]
        performSegue(withIdentifier: "instrumentDetailsVC", sender: instrument)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout Methods
extension InstrumentsCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentWidth = collectionView.bounds.width - 24
        let cellWidth = contentWidth / 2
        let cellHeight = cellWidth * 1.25
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
