//
//  MicSpecsDetailsVC.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 1/20/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import UIKit

class MicSpecsDetailsVC: UIViewController {

    let header = UIView()
    var offset_HeaderStop: CGFloat! // At this offset the Header stops its transformations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sennheiser MD 421 II"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MicSpecsDetailsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MicSpecTableViewCell.reuseIdentifier, for: indexPath) as! MicSpecTableViewCell
        
        var specDescription = String()
        var spec = String()
        
        switch indexPath.row {
        case 0: specDescription = "Type of mic:"
            spec = "Dynamic"
        case 1: specDescription = "Pad:"
            spec = "none"
        case 2: specDescription = "HPF or Roll-off:"
            spec = "5 position bass roll off"
        case 3: specDescription = "Polar Pattern:"
            spec = "Cardioid"
        case 4: specDescription = "Max SPL:"
            spec = "really high"
        case 5: specDescription = "Large or Small Diaphragm:"
            spec = "Large Diaphragm and bloobidy blahbidy boo"
        case 6: specDescription = "Frequency Response:"
            spec = "30Hz-17kHz"
        case 7: specDescription = "Phantom Power:"
            spec = "none"
        case 8: specDescription = "Front or Side Address:"
            spec = "Front address"
        case 9: specDescription = "Signal to Noise Ratio:"
            spec = "?"
        default: break
        }
        
        cell.specDescriptionLabel.text = specDescription
        cell.specLabel.text = spec
        return cell
    }
}

extension MicSpecsDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        header.backgroundColor = .white
        let micImageView = UIImageView()
        header.addSubview(micImageView)
        header.clipsToBounds = true
        micImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ NSLayoutConstraint(item: micImageView, attribute: .top, relatedBy: .equal, toItem: header, attribute: .top, multiplier: 1, constant: 8),
                                      NSLayoutConstraint(item: micImageView, attribute: .bottom, relatedBy: .equal, toItem: header, attribute: .bottom, multiplier: 1, constant: 8),
                                      NSLayoutConstraint(item: micImageView, attribute: .leading, relatedBy: .equal, toItem: header, attribute: .leading, multiplier: 1, constant: 8),
                                      NSLayoutConstraint(item: micImageView, attribute: .trailing, relatedBy: .equal, toItem: header, attribute: .trailing, multiplier: 1, constant: 8)])
        micImageView.image = #imageLiteral(resourceName: "Sennheiser MD421")
        micImageView.clipsToBounds = true
        micImageView.contentMode = .scaleAspectFit
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        offset_HeaderStop = tableView.bounds.width * 0.75
        return offset_HeaderStop
    }
}

extension MicSpecsDetailsVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
        }
        header.layer.transform = headerTransform
    }
}
