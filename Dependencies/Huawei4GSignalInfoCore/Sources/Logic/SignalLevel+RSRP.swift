//
//  SignalInfo+RSRP.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation

extension SignalLevel where Value == DecibelMilliWatts {
    private struct Constants {
        static let levels: [ClosedRange<DecibelMilliWatts>] = [
            DecibelMilliWatts(rawValue: -Float.infinity)...(-112),
            (-112)...(-103),
            (-103)...(-85),
            (-85)...DecibelMilliWatts(rawValue: Float.infinity)
        ]
    }

    public init(rsrp: DecibelMilliWatts) {
        let level = Constants.levels.firstIndex(where: { $0.contains(rsrp) }) ?? 0
        let maxLevel = Constants.levels.count
        self.init(value: rsrp, level: level, maxLevel: maxLevel)
    }
}
