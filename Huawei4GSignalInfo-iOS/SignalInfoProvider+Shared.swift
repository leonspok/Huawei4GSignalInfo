//
//  SignalInfoProvider.swift
//  Huawei4GSignalInfo-iOS
//
//  Created by Igor Savelev on 12.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation
import Huawei4GSignalInfoCore

extension SignalInfoProvider {
    static let shared: SignalInfoProvider = {
        let defaults = UserDefaults(suiteName: "group.com.leonspok.Huawei4GSignalInfo") ?? .standard
        let provider = SignalInfoProvider(defaults: defaults, fetcher: SignalInfoFetcher())
        provider.startPolling()
        return provider
    }()
}
