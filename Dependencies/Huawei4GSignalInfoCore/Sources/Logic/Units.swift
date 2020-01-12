//
//  Units.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation

public protocol SignalValue {}

public struct Decibel: SignalValue, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, RawRepresentable, Comparable {
    public var rawValue: Float

    public init(rawValue: Float) {
        self.rawValue = rawValue
    }

    public init(floatLiteral value: Float) {
        self.init(rawValue: value)
    }

    public init(integerLiteral value: Int) {
        self.init(rawValue: Float(value))
    }

    public static func < (lhs: Decibel, rhs: Decibel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

public struct DecibelMilliWatts: SignalValue, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, RawRepresentable, Comparable {
    public var rawValue: Float

    public init(rawValue: Float) {
        self.rawValue = rawValue
    }

    public init(floatLiteral value: Float) {
        self.init(rawValue: value)
    }

    public init(integerLiteral value: Int) {
        self.init(rawValue: Float(value))
    }

    public static func < (lhs: DecibelMilliWatts, rhs: DecibelMilliWatts) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
