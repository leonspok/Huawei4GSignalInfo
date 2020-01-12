//
//  AppDelegate.swift
//  Huawei4GSignalInfo-Mac
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import Cocoa
import AppKit
import SwiftUI
import Huawei4GSignalInfoCore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var provider: SignalInfoProvider?
    private var statusBarItem: NSStatusItem?
    private var infoViewController: NSViewController?
    private var popover: NSPopover?

    private var providerObserver: Any?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let provider = SignalInfoProvider(defaults: .standard, fetcher: SignalInfoFetcher())
        provider.startPolling()
        self.providerObserver = provider.notificationCenter.addObserver(forName: .signalInfoHasUpdated, object: provider, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            if let info = self.provider?.signalInfo {
                self.statusBarItem?.button?.image = info.sinr.image
            } else {
                let icon = NSImage(named: NSImage.statusNoneName)
                self.statusBarItem?.button?.image = icon
            }
        }

        let statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        if let button = statusBarItem.button {
            button.toolTip = "4G signal level"
            button.image = NSImage(named: NSImage.statusNoneName)
            button.action = #selector(togglePopover(_:))
        }

        self.provider = provider
        self.statusBarItem = statusBarItem
    }

    @objc
    func togglePopover(_ sender: AnyObject?) {
        if let popover = self.popover, popover.isShown {
            popover.performClose(sender)
        } else if let button = self.statusBarItem?.button,
            let provider = self.provider {
            let model = PopupViewModel(provider: provider)
            let popupView = PopupView(model: model).frame(width: 300, height: 230)
            let hostingController = NSHostingController(rootView: popupView)
            let popover = NSPopover()
            popover.contentSize = NSSize(width: 300, height: 90)
            popover.behavior = .transient
            popover.contentViewController = hostingController
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            self.popover = popover
            self.infoViewController = hostingController
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
