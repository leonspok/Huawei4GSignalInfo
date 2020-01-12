//
//  SignalInfo.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation

public struct SignalInfo {
    public let sinr: SignalLevel<Decibel>
    public let rssi: SignalLevel<DecibelMilliWatts>
    public let rsrq: SignalLevel<Decibel>
    public let rsrp: SignalLevel<DecibelMilliWatts>

    public init(sinr: SignalLevel<Decibel>,
                rssi: SignalLevel<DecibelMilliWatts>,
                rsrq: SignalLevel<Decibel>,
                rsrp: SignalLevel<DecibelMilliWatts>) {
        self.sinr = sinr
        self.rssi = rssi
        self.rsrq = rsrq
        self.rsrp = rsrp
    }
}
