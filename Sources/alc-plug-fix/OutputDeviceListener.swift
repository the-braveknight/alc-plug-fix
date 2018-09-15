//
//  OutputDeviceListener.swift
//  alc-plug-fix
//
//  Created by Zaid Rahawi on 9/14/18.
//  Copyright © 2018 Zaid Rahawi. All rights reserved.
//

import Foundation
import CoreAudio

enum OutputDevice: UInt32 {
    case speakers = 1769173099
    case headphones = 1751412846
    case other = 0
    
    init(dataSourceId: UInt32) {
        self = OutputDevice(rawValue: dataSourceId) ?? .other
    }
}

protocol OutputDeviceListenerDelegate: class {
    func outputDeviceListener(_ outputDeviceListener: OutputDeviceListener, outputDeviceDidChangeTo newOutputDevice: OutputDevice)
}

class OutputDeviceListener {
    private var defaultDevice: AudioDeviceID = 0
    private var defaultSize = UInt32(MemoryLayout<AudioObjectID>.size)
    
    private var defaultAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyDefaultOutputDevice, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMaster)
    private var sourceAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyDataSource, mScope: kAudioDevicePropertyScopeOutput, mElement: kAudioObjectPropertyElementMaster)
    
    private var dataSourceId: UInt32 = 0
    
    weak var delegate: OutputDeviceListenerDelegate?
    
    var currentOutputDevice: OutputDevice {
        return OutputDevice(dataSourceId: dataSourceId)
    }
    
    private let queue = DispatchQueue(label: "OutputDeviceListener", qos: .background)
    
    init() {
        AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &defaultAddress, 0, nil, &defaultSize, &defaultDevice)
    }
    
    func startListening() {
        AudioObjectAddPropertyListenerBlock(defaultDevice, &sourceAddress, queue, handlePropertyEvent)
    }
    
    private func handlePropertyEvent(numberOfAddresses: UInt32, address: UnsafePointer<AudioObjectPropertyAddress>) {
        AudioObjectGetPropertyData(defaultDevice, address, 0, nil, &defaultSize, &dataSourceId)
        
        delegate?.outputDeviceListener(self, outputDeviceDidChangeTo: currentOutputDevice)
    }
}
