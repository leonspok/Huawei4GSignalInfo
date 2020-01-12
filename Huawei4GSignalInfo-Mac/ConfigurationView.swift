//
//  SettingsView.swift
//  Huawei4GSignalInfo-Mac
//
//  Created by Igor Savelev on 12.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import SwiftUI

final class ConfigurationViewModel: ObservableObject {
    @Published var address: String
    @Published var pollingInterval: Int

    init(address: String,
         pollingInterval: Int) {
        self.address = address
        self.pollingInterval = pollingInterval
    }
}

struct ConfigurationView: View {

    @ObservedObject var model: ConfigurationViewModel

    var body: some View {
        VStack(alignment: .leading) {
            TextField("Device address", text: self.$model.address)
            Stepper(value: self.$model.pollingInterval, in: 1...60) {
                Text("Polling interval: \(self.model.pollingInterval)s")
            }
        }
    }
}

#if DEBUG

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        return ConfigurationView(
            model: ConfigurationViewModel(address: "192.168.8.1", pollingInterval: 3)
        )
    }
}

#endif
