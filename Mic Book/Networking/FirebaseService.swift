//
//  FirebaseService.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 4/11/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

final class FirebaseService {
    
    static let shared: FirebaseService = FirebaseService()
    
    private init() { }
    
    //STORAGE REFERENCES
    let MICROPHONES_STORAGE_REF: StorageReference = Storage.storage().reference().child("microphones")
    let BRAND_STORAGE_REF: StorageReference = Storage.storage().reference().child("brand logos")
    
    //DATABASE REFERENCES
    let MICROPHONES_DB_REF = Database.database().reference().child("microphones")
    
    func fetchMicrophones(completion: @escaping ([Microphone]) -> Void) {
        
        MICROPHONES_DB_REF.observeSingleEvent(of: .value, with: { snapshot in
            
            var mics: [Microphone] = []
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                if let micInfo = item.value as? [String: Any] {
                    if let mic = Microphone(withJSON: micInfo) {
                       mics.append(mic)
                    }
                }
            }
            completion(mics)
        })
    }
}
