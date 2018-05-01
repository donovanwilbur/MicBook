//
//  AudioSampleTableViewCell.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 4/18/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import UIKit
import FirebaseStorageUI

protocol AudioSampleTableViewCellDelegate: AnyObject {
    func togglePlayPause(_ sample: AudioSample, _ cell: AudioSampleTableViewCell)
}

class AudioSampleTableViewCell: UITableViewCell {

    static let reuseIdentifier = "sampleCell"
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var sample: AudioSample!
    
    weak var delegate: AudioSampleTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressView.setProgress(0, animated: false)
    }
    
    func configure(withSample sample: AudioSample) {
        self.sample = sample
        guard let mic = sample.microphone else { return }
        titleLabel.text = mic.name
        subtitleLabel.text = mic.brand?.name
        if let name = mic.name, let ext = mic.imageExt {
            thumbImageView.sd_setImage(with: FirebaseService.shared.MICROPHONES_STORAGE_REF.child("\(name).\(ext)"))
        }
    }
    
    @IBAction func playPauseBtnPressed(_ sender: UIButton) {
        delegate?.togglePlayPause(sample, self)
    }
}
