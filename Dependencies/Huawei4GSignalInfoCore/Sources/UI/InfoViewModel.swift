//
//  InfoViewModel.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 12.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation

public final class InfoViewModel: ObservableObject {
    private let showsTopText: Bool
    private let provider: SignalInfoProviderProtocol
    private var observers: [Any] = []

    public var emptyText = "Not available"
    public var infoViewModel: SignalInfoViewModel? {
        guard self.provider.signalInfo != nil else {
            return nil
        }
        return SignalInfoViewModel(showsTopText: self.showsTopText, provider: self.provider)
    }

    public init(showsTopText: Bool = true,
                provider: SignalInfoProviderProtocol) {
        self.showsTopText = showsTopText
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
            .signalInfoHasUpdated,
            .configurationUpdated
        ]
        self.observers = notifications.map { notificationName in
            return self.provider.notificationCenter.addObserver(forName: notificationName, object: self.provider, queue: .main, using: { [weak self] _ in
                self?.objectWillChange.send()
            })
        }
    }
}
