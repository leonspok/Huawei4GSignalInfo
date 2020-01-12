//
//  SignalLevel+iOS.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation
import UIKit

extension SignalLevel {
    public var image: UIImage? {
        let bundle = Bundle(identifier: "com.leonspok.Huawei4GSignalInfoCore")
        if self.maxLevel >= 4 {
            if self.level < 0 {
                return UIImage(named: "level_0_4", in: bundle, compatibleWith: nil)
            } else if self.level > 4 {
                return UIImage(named: "level_4_4", in: bundle, compatibleWith: nil)
            } else {
                return UIImage(named: "level_\(self.level)_4", in: bundle, compatibleWith: nil)
            }
        } else {
            if self.level < 0 {
                return UIImage(named: "level_0_3", in: bundle, compatibleWith: nil)
            } else if self.level > 3 {
                return UIImage(named: "level_3_3", in: bundle, compatibleWith: nil)
            } else {
                return UIImage(named: "level_\(self.level)_3", in: bundle, compatibleWith: nil)
            }
        }
    }
}
