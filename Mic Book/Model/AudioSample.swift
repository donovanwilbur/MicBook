//
//  AudioSample.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 4/18/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import Foundation

class AudioSample {
    
    var instrument: Instrument?
    var microphone: Microphone?
    var position: String?
    var positionDescription: String?
    
    enum CodingKeys: String {
        case instrument = "instrument"
        case microphone = "microphone"
        case position = "position"
        case positionDescription = "position_description"
    }
    
    init?(withJSON json: [String: Any]) {
        let instrumentString = json[CodingKeys.instrument.rawValue] as? String
        instrument = FirebaseService.shared.instruments.first(where: { $0.name == instrumentString })
        let microphoneString = json[CodingKeys.microphone.rawValue] as? String
        microphone = FirebaseService.shared.microphones.first(where: { $0.name == microphoneString })
        position = json[CodingKeys.position.rawValue] as? String
        positionDescription = json[CodingKeys.positionDescription.rawValue] as? String
    }
}
