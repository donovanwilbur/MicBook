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
    
    let audioSamplesBaseUrlString = "https://firebasestorage.googleapis.com/v0/b/mic-book.appspot.com/o/audio%20samples%2F"
    let token = "?alt=media&token=0994722a-8835-458b-b78e-a8d2aed14060"
    
    var microphones: [Microphone] = []
    var instruments: [Instrument] = []
    
    //STORAGE REFERENCES
    let MICROPHONES_STORAGE_REF: StorageReference = Storage.storage().reference().child("microphones")
    let BRAND_STORAGE_REF: StorageReference = Storage.storage().reference().child("brand logos")
    let FREQUENCY_RESPONSE_CURVES_STORAGE_REF: StorageReference = Storage.storage().reference().child("frequency response curves")
    let AUDIO_SAMPLES_STORAGE_REF: StorageReference = Storage.storage().reference().child("audio samples")
    let INSTRUMENT_ICONS_STORAGE_REF: StorageReference = Storage.storage().reference().child("instrument icons")
    
    //DATABASE REFERENCES
    let MICROPHONES_DB_REF = Database.database().reference().child("microphones")
    let AUDIO_SAMPLES_DB_REF = Database.database().reference().child("audio samples")
    let INSTRUMENTS_DB_REF = Database.database().reference().child("instruments")
    
    func fetchMicrophones(completion: @escaping ([Microphone]) -> Void) {
        
        MICROPHONES_DB_REF.observeSingleEvent(of: .value) { snapshot in
            
            var mics: [Microphone] = []
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                if let micInfo = item.value as? [String: Any] {
                    if let mic = Microphone(withJSON: micInfo) {
                       mics.append(mic)
                    }
                }
            }
            self.microphones = mics
            completion(mics)
        }
    }
    
    func fetchInstruments(completion: @escaping ([Instrument]) -> Void) {
        
        INSTRUMENTS_DB_REF.observeSingleEvent(of: .value) { snapshot in
            
            var instruments: [Instrument] = []
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                if let instrumentInfo = item.value as? [String: Any] {
                    if let instrument = Instrument(withJSON: instrumentInfo) {
                        instruments.append(instrument)
                    }
                }
            }
            self.instruments = instruments
            completion(instruments)
        }
    }
    
    func fetchAudioSamples(forType child: String, filterTerm term: String, completion: @escaping ([AudioSample]) -> Void) {
     
        AUDIO_SAMPLES_DB_REF.queryOrdered(byChild: child).queryEqual(toValue: term).observeSingleEvent(of: .value) { snapshot in
            
            var samples: [AudioSample] = []
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                if let sampleInfo = item.value as? [String: Any] {
                    if let sample = AudioSample(withJSON: sampleInfo) {
                        samples.append(sample)
                    }
                }
            }
            completion(samples)
        }
    }
}
