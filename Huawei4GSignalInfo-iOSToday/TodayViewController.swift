//
//  TodayViewController.swift
//  Huawei4GSignalInfo-iOSToday
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import UIKit
import SwiftUI
import NotificationCenter
import Huawei4GSignalInfoCore

class TodayViewController: UIViewController, NCWidgetProviding {

    private var hostingController: UIViewController?
    private var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = self.contentView {
                view.bounds = self.view.bounds
                view.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(view)
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                    view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                    view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                    view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
                ])
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .compact
        self.view.backgroundColor = .clear

        let view = InfoView(model: InfoViewModel(showsTopText: false, provider: SignalInfoProvider.shared)).padding()
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.backgroundColor = .clear
        self.contentView = hostingController.view
        self.hostingController = hostingController
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
}
