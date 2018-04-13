//
//  Brand.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 4/12/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import Foundation

class Brand {

    var name: String?
    var imageExt: String?
    
    enum CodingKeys: String {
        case name = "name"
        case imageExt = "image_ext"
    }
    
    init?(withJSON json: [String: Any]) {
        name = json[CodingKeys.name.rawValue] as? String
        imageExt = json[CodingKeys.imageExt.rawValue] as? String
    }
}
