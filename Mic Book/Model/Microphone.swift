//
//  Microphone.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 4/11/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import Foundation

class Microphone {
    
    var brand: Brand?
    var diaphragmSize: DiaphragmSize?
    var frequencyResponse: FrequencyResponse?
    var highPassFilter: String?
    var maxSpl: String?
    var name: String?
    var pad: String?
    var needsPhantomPower: Bool = false
    var polarPatterns: [PolarPattern] = []
    var isSideAddress: Bool = false
    var signalToNoiseRatio: String?
    var type: MicrophoneType?
    var imageExt: String?
    
    enum CodingKeys: String {
        case brand = "brand"
        case diaphragmSize = "diaphragm_size"
        case frequencyResponse = "frequency_response"
        case highPassFilter = "hpf"
        case maxSpl = "max_spl"
        case name = "name"
        case pad = "pad"
        case needsPhantomPower = "phantom_power"
        case polarPattern = "polar_pattern"
        case isSideAddress = "side_address"
        case signalToNoiseRatio = "snr"
        case type = "type"
        case imageExt = "image_ext"
    }
    
    init?(withJSON json: [String: Any]) {
        if let brandJSON = json[CodingKeys.brand.rawValue] as? [String: Any] {
            brand = Brand(withJSON: brandJSON)
        }
        if let diaphramSizeString = json[CodingKeys.diaphragmSize.rawValue] as? String { diaphragmSize = DiaphragmSize(rawValue: diaphramSizeString) }
        if let frequencyResponseJSON = json[CodingKeys.frequencyResponse.rawValue] as? [String: Any] {
            frequencyResponse = FrequencyResponse(withJSON: frequencyResponseJSON)
        }
        highPassFilter = json[CodingKeys.highPassFilter.rawValue] as? String
        maxSpl = json[CodingKeys.maxSpl.rawValue] as? String
        name = json[CodingKeys.name.rawValue] as? String
        pad = json[CodingKeys.pad.rawValue] as? String
        needsPhantomPower = json[CodingKeys.needsPhantomPower.rawValue] as! Bool
        if let polarPatternString = json[CodingKeys.polarPattern.rawValue] as? String {
            let commaSeparatedStrings = polarPatternString.split(separator: ",")
            commaSeparatedStrings.forEach { self.polarPatterns.append(PolarPattern(rawValue: String($0))!) }
        }
        isSideAddress = json[CodingKeys.isSideAddress.rawValue] as! Bool
        signalToNoiseRatio = json[CodingKeys.signalToNoiseRatio.rawValue] as? String
        if let typeString = json[CodingKeys.type.rawValue] as? String {
            type = MicrophoneType(rawValue: typeString)
        }
        imageExt = json[CodingKeys.imageExt.rawValue] as? String
    }
}

enum DiaphragmSize: String {
    case large = "Large"
    case small = "Small"
    case na = "N/A"
}

enum PolarPattern: String {
    case cardioid = "Cardioid"
    case bidirectional = "Figure-8"
    case omniDirectional = "Omni"
    case hyperCardioid = "Hypercardioid"
    case wideCardioid = "Wide Cardioid"
    case superCardioid = "Supercardioid"
}

enum MicrophoneType: String {
    case dynamic = "Dynamic"
    case condensor = "Condenser"
    case ribbon = "Active Ribbon"
}
