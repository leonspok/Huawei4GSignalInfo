//
//  PopupView.swift
//  Huawei4GSignalInfo-Mac
//
//  Created by Igor Savelev on 12.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import SwiftUI
import Huawei4GSignalInfoCore

struct PopupView: View {

    @ObservedObject var model: PopupViewModel

    var body: some View {
        VStack(spacing: 0) {
            InfoView(model: self.model.infoModel)
            Spacer()
            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
                .padding([.top, .bottom], 10)
            HStack {
                Toggle(isOn: self.$model.isPolling) {
                    Text("Polling:")
                }
                    .toggleStyle(SwitchToggleStyle())
                Spacer()
                Button(action: self.model.configure) {
                    Text("Configure")
                }
                Button(action: self.model.quit) {
                    Text("Quit")
                }
            }
        }
            .padding()
    }
}

#if DEBUG

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView(model: PopupViewModel(provider: FakeProvider()))
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
