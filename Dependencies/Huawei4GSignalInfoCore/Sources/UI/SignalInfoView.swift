//
//  SignalInfoView.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import SwiftUI

public struct SignalInfoView: View {

    public let model: SignalInfoViewModel

    public var body: some View {
        VStack(spacing: 10) {
            if self.model.showsTopText {
                #if os(macOS)
                Text(self.model.topText)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.gray)
                #elseif os(iOS)
                Text(self.model.topText)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(.secondaryLabel))
                #else
                Text(self.model.topText)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.gray)
                #endif
            }
            HStack(spacing: 5) {
                ForEach(self.model.levels.indices, id: \.self) { i in
                    SignalLevelView(model: self.model.levels[i])
                }
            }
        }
    }
}

#if DEBUG

struct SignalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let model = SignalInfoViewModel(provider: FakeProvider())
        return SignalInfoView(model: model)
    }
}

final class FakeProvider: SignalInfoProviderProtocol {
    public var isPolling: Bool = false
    public var notificationCenter = NotificationCenter()
    public var signalInfo: SignalInfo? = .init(
        sinr: SignalLevel(sinr: 10),
        rssi: SignalLevel(rssi: -75),
        rsrq: SignalLevel(rsrq: -6),
        rsrp: SignalLevel(rsrp: -103)
    )
    public var configuration: SignalInfoProviderConfiguration = .default

    public func startPolling() {}
    public func stopPolling() {}
}

#endif
