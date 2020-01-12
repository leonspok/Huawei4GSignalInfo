//
//  PopupViewModel.swift
//  Huawei4GSignalInfo-Mac
//
//  Created by Igor Savelev on 12.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation
import AppKit
import SwiftUI
import Huawei4GSignalInfoCore

final class PopupViewModel: ObservableObject {
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
            .signalInfoPollingToggled
        ]
        self.observers = notifications.map { notificationName in
            return self.provider.notificationCenter.addObserver(forName: notificationName, object: self.provider, queue: .main, using: { [weak self] _ in
                self?.objectWillChange.send()
            })
        }
    }

    // MARK: - Public API

    private(set) lazy var infoModel: InfoViewModel = {
        InfoViewModel(provider: self.provider)
    }()
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

    func configure() {
        let configModel = ConfigurationViewModel(
            address: self.provider.configuration.routerAddress.host ?? "",
            pollingInterval: Int(self.provider.configuration.pollingInterval)
        )
        let rootView = ConfigurationView(model: configModel)
        let view = NSHostingView(rootView: rootView)
        view.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 70))

        let alert = NSAlert()
        alert.messageText = "Settings"
        alert.informativeText = "Specify ip address of your Huawei device and polling interval in seconds"
        alert.accessoryView = view
        alert.addButton(withTitle: "Save")
        alert.addButton(withTitle: "Cancel")
        switch alert.runModal() {
        case .alertFirstButtonReturn:
            var config = self.provider.configuration
            config.pollingInterval = TimeInterval(configModel.pollingInterval)
            var urlComponents = URLComponents(url: config.routerAddress, resolvingAgainstBaseURL: false)
            urlComponents?.host = configModel.address
            config.routerAddress = urlComponents?.url ?? config.routerAddress
            self.provider.configuration = config
        default:
            break
        }
    }

    func quit() {
        NSApplication.shared.terminate(nil)
    }
}
