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
    let footer = UIView()
    var offset_HeaderStop: CGFloat! // At this offset the Header stops its transformations
    
    var mic: Microphone!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(mic.brand?.name ?? "") \(mic.name ?? "")"
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
        var spec: String?
        
        switch indexPath.row {
        case 0: specDescription = "Type of mic:"
        spec = mic.type?.rawValue
        case 1: specDescription = "Pad:"
        spec = mic.pad
        case 2: specDescription = "HPF or Roll-off:"
        spec = mic.highPassFilter
        case 3: specDescription = "Polar Pattern:"
        var patterns = String()
        if mic.polarPatterns.count == 1 {
            patterns = mic.polarPatterns.first!.rawValue
        } else {
            for (i, pattern) in mic.polarPatterns.enumerated() {
                patterns.append(contentsOf: pattern.rawValue)
                if i != mic.polarPatterns.count - 1 {
                    patterns.append(contentsOf: ", ")
                }
            }
        }
        spec = patterns
        case 4: specDescription = "Max SPL:"
        spec = mic.maxSpl
        case 5: specDescription = "Large or Small Diaphragm:"
        spec = mic.diaphragmSize?.rawValue
        case 6: specDescription = "Frequency Response:"
        spec = mic.frequencyResponse?.value
        case 7: specDescription = "Phantom Power:"
        spec = mic.needsPhantomPower ? "Yes" : "No"
        case 8: specDescription = "Front or Side Address:"
        spec = mic.isSideAddress ? "Side Address" : "Front Address"
        case 9: specDescription = "Signal to Noise Ratio:"
        spec = mic.signalToNoiseRatio
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
        if let name = mic.name, let ext = mic.imageExt {
            micImageView.sd_setImage(with: FirebaseService.shared.MICROPHONES_STORAGE_REF.child("\(name).\(ext)"))
        }
        micImageView.clipsToBounds = true
        micImageView.contentMode = .scaleAspectFit
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        offset_HeaderStop = tableView.bounds.width * 0.75
        return offset_HeaderStop
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        footer.backgroundColor = .white
        let frequencyResponseImageView = UIImageView()
        footer.addSubview(frequencyResponseImageView)
        frequencyResponseImageView.clipsToBounds = true
        frequencyResponseImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ frequencyResponseImageView.topAnchor.constraint(equalTo: footer.topAnchor),
                                      frequencyResponseImageView.leadingAnchor.constraint(equalTo: footer.leadingAnchor),
                                      frequencyResponseImageView.trailingAnchor.constraint(equalTo: footer.trailingAnchor),
                                      frequencyResponseImageView.bottomAnchor.constraint(equalTo: footer.bottomAnchor) ])
        if let name = mic.frequencyResponse?.imageName, let ext = mic.frequencyResponse?.imageExt {
            frequencyResponseImageView.sd_setImage(with: FirebaseService.shared.FREQUENCY_RESPONSE_CURVES_STORAGE_REF.child("\(name).\(ext)"))
        }
        frequencyResponseImageView.clipsToBounds = true
        frequencyResponseImageView.contentMode = .scaleAspectFit
        footer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showZoomableFrequencyResponseImage(_:))))
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let imageView = footer.subviews.last as? UIImageView, let image = imageView.image {
            let aspectRatio = image.size.height / image.size.width
            return tableView.frame.width * aspectRatio
        } else { return 200 }
    }
    
    @objc func showZoomableFrequencyResponseImage(_ gesture: UITapGestureRecognizer) {
        print("Tap tappity tap!")
        guard let imageView = footer.subviews.last as? UIImageView, let image = imageView.image else { return }
        
        let zoomController = PhotoZoomController(nibName: "PhotoZoomController", bundle: nil)
        
        zoomController.modalTransitionStyle = .crossDissolve
        zoomController.image = image
        
        navigationController?.present(zoomController, animated: true, completion: nil)
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
