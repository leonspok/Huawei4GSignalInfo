//
//  SignalInfo+RSRQ.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation

extension SignalLevel where Value == Decibel {
    private struct Constants {
        static let levels: [ClosedRange<Decibel>] = [
            Decibel(rawValue: -Float.infinity)...(-11),
            (-11)...(-8),
            (-8)...(-5),
            (-5)...Decibel(rawValue: Float.infinity)
        ]
    }

    public init(rsrq: Decibel) {
        let level = Constants.levels.firstIndex(where: { $0.contains(rsrq) }) ?? 0
        let maxLevel = Constants.levels.count
        self.init(value: rsrq, level: level, maxLevel: maxLevel)
    }
}
