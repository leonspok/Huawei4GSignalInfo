//
//  SignalInfo+RSSI.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation

extension SignalLevel where Value == DecibelMilliWatts {
    private struct Constants {
        static let levels: [ClosedRange<DecibelMilliWatts>] = [
            DecibelMilliWatts(rawValue: -Float.infinity)...(-85),
            (-85)...(-75),
            (-75)...(-65),
            (-65)...DecibelMilliWatts(rawValue: Float.infinity)
        ]
    }

    public init(rssi: DecibelMilliWatts) {
        let level = Constants.levels.firstIndex(where: { $0.contains(rssi) }) ?? 0
        let maxLevel = Constants.levels.count
        self.init(value: rssi, level: level, maxLevel: maxLevel)
    }
}
