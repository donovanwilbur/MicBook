//
//  InstrumentDetailsVC.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 4/18/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import UIKit
import AVKit

class InstrumentDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var instrument: Instrument!
    var avPlayer: AVPlayer?
    
    private var progressObserverToken: Any?
    
    weak var currentCell: AudioSampleTableViewCell?
    var currentCellIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instrument.loadAudioSamples(success: {
            self.tableView.reloadData()
        }) { (error) in
            self.showError(withMessage: error)
        }
        self.title = instrument.name
    }
    
    func showError(withMessage message: String) {
        let alert = UIAlertController(title: "Error", message: "Unable to load audio samples for this instrument. \(message)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource Methods
extension InstrumentDetailsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return instrument.sampleGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instrument.sampleGroups[section].samples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AudioSampleTableViewCell.reuseIdentifier, for: indexPath) as! AudioSampleTableViewCell
        cell.configure(withSample: instrument.sampleGroups[indexPath.section].samples[indexPath.row])
        cell.delegate = self
        
        guard let index = currentCellIndex else { return cell }
        if indexPath == index {
            if avPlayer!.rate > 0 {
                cell.playPauseButton.setImage(#imageLiteral(resourceName: "Pause Icon"), for: .normal)
            } else {
                cell.playPauseButton.setImage(#imageLiteral(resourceName: "Play Icon"), for: .normal)
                cell.progressView.setProgress(0, animated: false)
            }
        } else {
            cell.playPauseButton.setImage(#imageLiteral(resourceName: "Play Icon"), for: .normal)
            cell.progressView.setProgress(0, animated: false)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate Methods
extension InstrumentDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let position = instrument.sampleGroups[section].samples.first?.positionDescription else { return nil }
        let header = UIView()
        header.backgroundColor = .darkGray
        let titleLabel = UILabel()
        titleLabel.text = "Mic Placement: \(position)"
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true
        header.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ titleLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 8),
                                      titleLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8),
                                      titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
                                      titleLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -4)])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

//MARK: - AudioSampleTableViewCellDelegate Methods
extension InstrumentDetailsVC: AudioSampleTableViewCellDelegate {
    func togglePlayPause(_ sample: AudioSample, _ cell: AudioSampleTableViewCell) {
        
        guard let player = avPlayer else {
            play(sample, cell: cell)
            return
        }
        
        if player.rate > 0 {
            if currentCell != cell {
                pause()
                play(sample, cell: cell)
            } else {
                pause()
            }
        } else {
            play(sample, cell: cell)
        }
    }
    
    func play(_ sample: AudioSample, cell: AudioSampleTableViewCell) {
        cell.activityIndicatorView.startAnimating()
        cell.playPauseButton.isHidden = true
        currentCell = cell
        currentCellIndex = tableView.indexPath(for: cell)
        
        setupAVPlayer(withSample: sample, success: {
            self.avPlayer?.play()
            cell.playPauseButton.setImage(#imageLiteral(resourceName: "Pause Icon"), for: .normal)
        }, failure: nil )
    }
    
    func pause() {
        currentCell?.progressView.setProgress(0, animated: false)
        currentCell?.playPauseButton.setImage(#imageLiteral(resourceName: "Play Icon"), for: .normal)
        avPlayer?.pause()
        avPlayer?.currentItem?.seek(to: kCMTimeZero)
    }
}

//MARK: - Audio Player Stuff
extension InstrumentDetailsVC {
    
    //Observer for animating the progress bar accross the clip
    func addPeriodicTimeObserver() {
        guard let currentItem = avPlayer?.currentItem else { return }
        let duration = Float(currentItem.asset.duration.seconds)
        
        // Invoke callback every tenth of a second
        let interval = CMTimeMake(1, 10)
        // Add time observer
        progressObserverToken = avPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            guard self != nil else { return }
            if self!.avPlayer!.rate > 0 {
                let currentTime = Float(CMTimeGetSeconds(currentItem.currentTime()))
                
                guard let index = self?.currentCellIndex else { return }
                if let cell = self?.tableView.cellForRow(at: index) as? AudioSampleTableViewCell {
                    cell.progressView.setProgress(currentTime / duration, animated: true)
                }
            }
        }
    }
    
    func removePeriodicTimeObserver() {
        // If a time observer exists, remove it
        if let token = progressObserverToken {
            avPlayer?.removeTimeObserver(token)
            progressObserverToken = nil
        }
    }
    
    func setupAVPlayer(withSample sample: AudioSample, success: (() -> Void)?, failure: (() -> Void)?) {
        guard let instrumentName = sample.instrument?.name?.replacingOccurrences(of: " ", with: "%20"), let micName = sample.microphone?.name?.replacingOccurrences(of: " ", with: ""), let position = sample.position else {
            showError(withMessage: "Unable to locate this audio file. Please try again later.")
            failure?()
            return
        }
        
        guard let url = URL(string: "\(FirebaseService.shared.audioSamplesBaseUrlString)\(instrumentName)_\(micName)_\(position).wav\(FirebaseService.shared.token)") else {
            showError(withMessage: "Unable to locate this audio file. Please try again later.")
            failure?()
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
        addPeriodicTimeObserver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachedClipEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        success?()
    }
    
    @objc func reachedClipEnd() {
        avPlayer?.pause()
        avPlayer?.currentItem?.seek(to: kCMTimeZero)
        currentCell?.playPauseButton.setImage(#imageLiteral(resourceName: "Play Icon"), for: .normal)
        currentCell?.progressView.setProgress(0, animated: false)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            guard let player = avPlayer else { return }
            if player.rate > 0 {
                currentCell?.activityIndicatorView.stopAnimating()
                currentCell?.playPauseButton.isHidden = false
            }
        }
    }
}
