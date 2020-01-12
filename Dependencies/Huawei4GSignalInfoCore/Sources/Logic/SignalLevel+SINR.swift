//
//  SignalInfo+SINR.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation

extension SignalLevel where Value == Decibel {
    private struct Constants {
        static let levels: [ClosedRange<Decibel>] = [
            Decibel(rawValue: -Float.infinity)...7,
            7...10,
            10...12.5,
            12.5...Decibel(rawValue: Float.infinity)
        ]
    }

    public init(sinr: Decibel) {
        let level = Constants.levels.firstIndex(where: { $0.contains(sinr) }) ?? 0
        let maxLevel = Constants.levels.count
        self.init(value: sinr, level: level, maxLevel: maxLevel)
    }
}
