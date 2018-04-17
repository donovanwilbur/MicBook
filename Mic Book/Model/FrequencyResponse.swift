//
//  FrequencyResponse.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 4/16/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import Foundation

class FrequencyResponse {
    
    var value: String?
    var imageName: String?
    var imageExt: String?
    
    enum CodingKeys: String {
        case value = "value"
        case imageName = "image_name"
        case imageExt = "image_ext"
    }
    
    init?(withJSON json: [String: Any]) {
        value = json[CodingKeys.value.rawValue] as? String
        imageName = json[CodingKeys.imageName.rawValue] as? String
        imageExt = json[CodingKeys.imageExt.rawValue] as? String
    }
}
