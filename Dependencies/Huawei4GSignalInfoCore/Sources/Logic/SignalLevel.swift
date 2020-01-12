//
//  SignalInfo.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation

public struct SignalLevel<Value: SignalValue> {
    public let value: Value
    public let level: Int
    public let maxLevel: Int

    public init(value: Value,
                level: Int,
                maxLevel: Int) {
        self.value = value
        self.level = level
        self.maxLevel = maxLevel
    }
}
