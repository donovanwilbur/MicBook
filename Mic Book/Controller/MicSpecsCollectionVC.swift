//
//  MicSpecsCollectionVC.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 1/20/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import UIKit

class MicSpecsCollectionVC: UIViewController {

    @IBOutlet weak var sectionHeaderImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Mic Specifications"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension MicSpecsCollectionVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MicSpecsCollectionViewCell.reuseIdentifier, for: indexPath) as! MicSpecsCollectionViewCell
        return cell
    }
}

extension MicSpecsCollectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "micSpecsDetailsVC", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MicSpecsCollectionSectionHeaderView.reuseIdentifier, for: indexPath) as! MicSpecsCollectionSectionHeaderView
            headerView.brandImageView.image = #imageLiteral(resourceName: "Sennheiser Logo")
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension MicSpecsCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentWidth = collectionView.bounds.width - 32
        let cellWidth = contentWidth / 3
        let cellHeight = cellWidth * 1.25
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
