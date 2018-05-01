//
//  Instrument.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 4/17/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import Foundation

class Instrument {
    
    var name: String?
    var imageExt: String?
    
    var sampleGroups: [SampleGroup] = []
    
    enum CodingKeys: String {
        case name = "name"
        case imageExt = "image_ext"
    }
    
    init?(withJSON json: [String: Any]) {
        name = json[CodingKeys.name.rawValue] as? String
        imageExt = json[CodingKeys.imageExt.rawValue] as? String
    }
    
    func loadAudioSamples(success: @escaping () -> Void, failure: @escaping (_ errorMessage: String) -> Void) {
        guard name != nil else {
            failure("We don't have access to the name of this instrument")
            return
        }
        FirebaseService.shared.fetchAudioSamples(forType: "instrument", filterTerm: name!) { samples in
            self.organizeSamplesIntoGroups(samples)
            success()
        }
    }
    
    func organizeSamplesIntoGroups(_ samples: [AudioSample]) {
        let sortedSamples = samples.sorted { $0.position! > $1.position! }
        
        for sample in sortedSamples {
            guard sample.microphone != nil else { continue }
            guard sample.instrument != nil else { continue }
            
            if sampleGroups.isEmpty {
                let sampleGroup = SampleGroup()
                sampleGroup.position = sample.position
                sampleGroup.samples.append(sample)
                sampleGroups.append(sampleGroup)
            } else if let sampleGroup = sampleGroups.last {
                if sampleGroup.position == sample.position {
                    sampleGroup.samples.append(sample)
                } else {
                    let sampleGroup = SampleGroup()
                    sampleGroup.position = sample.position
                    sampleGroup.samples.append(sample)
                    sampleGroups.append(sampleGroup)
                }
            }
        }
        
        for group in sampleGroups {
            group.samples.sort { $0.microphone!.name! > $1.microphone!.name! }
        }
    }
}

class SampleGroup {
    var position: String?
    var samples: [AudioSample] = []
}
