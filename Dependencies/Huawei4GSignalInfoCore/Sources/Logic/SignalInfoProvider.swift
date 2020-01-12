//
//  SignalInfoProvider.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Foundation

extension Notification.Name {
    public static let signalInfoHasUpdated: Notification.Name = .init("SignalInfoHasUpdated")
    public static let signalInfoPollingToggled: Notification.Name = .init("SignalInfoPollingToggled")
    public static let configurationUpdated: Notification.Name = .init("ConfigurationUpdated")
}

public struct SignalInfoProviderConfiguration {
    public var routerAddress: URL
    public var pollingInterval: TimeInterval

    public static let `default` = SignalInfoProviderConfiguration(
        routerAddress: URL(string: "http://192.168.8.1") ?? URL(fileURLWithPath: "http://127.0.0.1"),
        pollingInterval: 3.0
    )
}

public protocol SignalInfoProviderProtocol: AnyObject {
    var isPolling: Bool { get }
    var signalInfo: SignalInfo? { get }
    var configuration: SignalInfoProviderConfiguration { get set }
    var notificationCenter: NotificationCenter { get }

    func startPolling()
    func stopPolling()
}

public final class SignalInfoProvider: SignalInfoProviderProtocol {
    private let defaults: UserDefaults
    private let fetcher: SignalInfoFetcherProtocol

    private var timer: Timer?

    public init(defaults: UserDefaults,
                fetcher: SignalInfoFetcherProtocol) {
        self.defaults = defaults
        self.fetcher = fetcher
        self.configuration = Self.fetchConfiguration(from: defaults) ?? .default
    }

    // MARK: - SignalInfoProviderProtocol

    public var isPolling: Bool = false {
        didSet {
            self.notificationCenter.post(name: .signalInfoPollingToggled, object: self)
        }
    }
    public private(set) lazy var notificationCenter = NotificationCenter()
    public private(set) var signalInfo: SignalInfo? {
        didSet {
            self.notificationCenter.post(name: .signalInfoHasUpdated, object: self)
        }
    }
    public var configuration: SignalInfoProviderConfiguration {
        didSet {
            let wasPolling = self.isPolling
            self.stopPolling()
            self.notificationCenter.post(name: .configurationUpdated, object: self)
            self.storeConfiguration(self.configuration)
            if wasPolling {
                self.startPolling()
            }
        }
    }

    public func startPolling() {
        guard self.isPolling == false else { return }
        self.isPolling = true
        let timer = Timer(timeInterval: self.configuration.pollingInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.fetchInfo()
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
        self.fetchInfo()
    }

    public func stopPolling() {
        self.isPolling = false
        self.timer?.invalidate()
        self.timer = nil
    }

    // MARK: - Private

    private struct UserDefaultsKeys {
        static let routerAddressKey = "router_address"
        static let pollingIntervalKey = "polling_interval"
    }

    private func fetchInfo() {
        self.fetcher.fetchInfo(routerAddress: self.configuration.routerAddress, completion: { [weak self] result in
            switch result {
            case .success(let info):
                self?.signalInfo = info
            case .failure:
                self?.signalInfo = nil
            }
        })
    }

    private static func fetchConfiguration(from userDefaults: UserDefaults) -> SignalInfoProviderConfiguration? {
        let defaultConfig = SignalInfoProviderConfiguration.default
        let routerAddress: URL = {
            guard let url = userDefaults.url(forKey: UserDefaultsKeys.routerAddressKey) else {
                return defaultConfig.routerAddress
            }
            return url
        }()
        let pollingInterval: TimeInterval = {
            let pollingInterval = userDefaults.double(forKey: UserDefaultsKeys.pollingIntervalKey)
            return pollingInterval > 0.1 ? pollingInterval : defaultConfig.pollingInterval
        }()
        return .init(routerAddress: routerAddress, pollingInterval: pollingInterval)
    }

    private func storeConfiguration(_ configuration: SignalInfoProviderConfiguration) {
        self.defaults.set(configuration.routerAddress, forKey: UserDefaultsKeys.routerAddressKey)
        self.defaults.set(configuration.pollingInterval, forKey: UserDefaultsKeys.pollingIntervalKey)
    }
}
