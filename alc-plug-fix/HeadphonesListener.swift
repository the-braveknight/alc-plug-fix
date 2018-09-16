//
//  HeadphonesListener.swift
//  alc-plug-fix
//
//  Created by Zaid Rahawi on 9/14/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation
import CoreAudio

protocol HeadphonesListenerDelegate: class {
    func headphonesListener(_ headphonesListener: HeadphonesListener, didPlugHeadphonesAt date: Date)
    func headphonesListener(_ headphonesListener: HeadphonesListener, didUnplugHeadphonesAt date: Date)
}

enum AudioOutputDevice: UInt32 {
    case speakers = 1769173099
    case headphones = 1751412846
}

class HeadphonesListener {
    private var defaultDevice: AudioDeviceID = 0
    private var defaultSize = UInt32(MemoryLayout<AudioObjectID>.size)
    
    private var defaultAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyDefaultOutputDevice, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMaster)
    private var sourceAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyDataSource, mScope: kAudioDevicePropertyScopeOutput, mElement: kAudioObjectPropertyElementMaster)
    
    private var dataSourceId: UInt32 = 0
    
    weak var delegate: HeadphonesListenerDelegate?
    
    var currentOutputDevice: AudioOutputDevice? {
        return AudioOutputDevice(rawValue: dataSourceId)
    }
    
    private let queue = DispatchQueue(label: "HeadphonesListener", qos: .utility)
    
    init() {
        AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &defaultAddress, 0, nil, &defaultSize, &defaultDevice)
    }
    
    func startListening() {
        AudioObjectAddPropertyListenerBlock(defaultDevice, &sourceAddress, queue, handlePropertyEvent)
    }
    
    private func handlePropertyEvent(numberOfAddresses: UInt32, address: UnsafePointer<AudioObjectPropertyAddress>) {
        AudioObjectGetPropertyData(defaultDevice, address, 0, nil, &defaultSize, &dataSourceId)
        
        switch currentOutputDevice {
        case .headphones?: delegate?.headphonesListener(self, didPlugHeadphonesAt: Date())
        case .speakers?: delegate?.headphonesListener(self, didUnplugHeadphonesAt: Date())
        case .none: break
        }
    }
}
