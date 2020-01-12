//
//  SignalInfoViewModel.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 12.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation

public struct SignalInfoViewModel {
    public let showsTopText: Bool
    public let topText: String
    public let levels: [SignalLevelViewModel]

    public init(showsTopText: Bool = true,
                topText: String,
                levels: [SignalLevelViewModel]) {
        self.showsTopText = showsTopText
        self.topText = topText
        self.levels = levels
    }

    public init(showsTopText: Bool = true,
                provider: SignalInfoProviderProtocol) {
        let topText = provider.configuration.routerAddress.host ?? "..."
        let levels: [SignalLevelViewModel] = {
            guard let info = provider.signalInfo else {
                return []
            }
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 1
            return [
                SignalLevelViewModel(
                    title: "SINR",
                    value: numberFormatter.string(from: info.sinr.value.rawValue as NSNumber) ?? "...",
                    unit: "dB",
                    levelIcon: info.sinr.image
                ),
                SignalLevelViewModel(
                    title: "RSSI",
                    value: numberFormatter.string(from: info.rssi.value.rawValue as NSNumber) ?? "...",
                    unit: "dBm",
                    levelIcon: info.rssi.image
                ),
                SignalLevelViewModel(
                    title: "RSRQ",
                    value: numberFormatter.string(from: info.rsrq.value.rawValue as NSNumber) ?? "...",
                    unit: "dB",
                    levelIcon: info.rsrq.image
                ),
                SignalLevelViewModel(
                    title: "RSRP",
                    value: numberFormatter.string(from: info.rsrp.value.rawValue as NSNumber) ?? "...",
                    unit: "dBm",
                    levelIcon: info.rsrp.image
                )
            ]
        }()
        self.init(showsTopText: showsTopText, topText: topText, levels: levels)
    }
}
