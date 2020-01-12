//
//  SignalLevel+Mac.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation
import AppKit

extension SignalLevel {
    public var image: NSImage? {
        let bundle = Bundle(identifier: "com.leonspok.Huawei4GSignalInfoCore")
        if self.maxLevel >= 4 {
            if self.level < 0 {
                return (bundle?.image(forResource: "level_0_4"))
            } else if self.level > 4 {
                return (bundle?.image(forResource: "level_4_4"))
            } else {
                return (bundle?.image(forResource: "level_\(self.level)_4"))
            }
        } else {
            if self.level < 0 {
                return (bundle?.image(forResource: "level_0_3"))
            } else if self.level > 3 {
                return (bundle?.image(forResource: "level_3_3"))
            } else {
                return (bundle?.image(forResource: "level_\(self.level)_3"))
            }
        }
    }
}
