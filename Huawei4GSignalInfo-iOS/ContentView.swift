//
//  ContentView.swift
//  Huawei4GSignalInfo-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import SwiftUI
import Huawei4GSignalInfoCore

final class ContentViewModel: ObservableObject {
    private let provider: SignalInfoProviderProtocol
    private var observers: [Any] = []

    init(provider: SignalInfoProviderProtocol) {
        self.provider = provider
        self.subscribeToProviderUpdates()
    }

    deinit {
        self.observers.forEach { observer in
            self.provider.notificationCenter.removeObserver(observer)
        }
    }

    private func subscribeToProviderUpdates() {
        let notifications: [Notification.Name] = [
            .signalInfoPollingToggled,
            .signalInfoHasUpdated
        ]
        self.observers = notifications.map { notificationName in
            return self.provider.notificationCenter.addObserver(forName: notificationName, object: self.provider, queue: .main, using: { [weak self] _ in
                self?.objectWillChange.send()
            })
        }
    }

    // MARK: - Public API

    @Published private(set) var isEditing: Bool = false
    @Published var address: String = ""
    @Published var pollingInterval: Int = 1
    var isPolling: Bool {
        get {
            self.provider.isPolling
        }
        set {
            if newValue {
                self.provider.startPolling()
            } else {
                self.provider.stopPolling()
            }
        }
    }

    func changeConfiguration() {
        self.address = self.provider.configuration.routerAddress.host ?? ""
        self.pollingInterval = Int(self.provider.configuration.pollingInterval)
        self.isEditing = true
    }

    func save() {
        var config = self.provider.configuration
        config.pollingInterval = TimeInterval(self.pollingInterval)
        var urlComponents = URLComponents(url: config.routerAddress, resolvingAgainstBaseURL: false)
        urlComponents?.host = self.address
        config.routerAddress = urlComponents?.url ?? config.routerAddress
        self.provider.configuration = config
        self.isEditing = false
    }
}

struct ContentView: View {

    @ObservedObject var model: ContentViewModel

    var body: some View {
        NavigationView {
            Form {
                if self.model.isEditing == false {
                    Section {
                        InfoView(model: .init(provider: SignalInfoProvider.shared))
                            .padding([.top, .bottom], 10)
                        Toggle(isOn: self.$model.isPolling) {
                            Text("Polling enabled:")
                        }
                    }
                }

                if self.model.isEditing {
                    Section(header: Text("Configuration")) {
                        TextField("Device IP address", text: self.$model.address)
                        Stepper("Polling interval: \(self.model.pollingInterval)s", value: self.$model.pollingInterval, in: 1...60)
                    }
                }
            }
                .navigationBarTitle("4G Info")
                .navigationBarItems(
                    trailing: Group {
                        if self.model.isEditing {
                            Button(action: self.model.save) {
                                Text("Done")
                            }
                        } else {
                            Button(action: self.model.changeConfiguration) {
                                Image(systemName: "slider.horizontal.3")
                            }
                        }
                    }
                )
        }
    }
}

#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: ContentViewModel(provider: FakeProvider()))
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
