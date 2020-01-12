//
//  SignalLevelView.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import SwiftUI
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public struct SignalLevelViewModel {
    public let title: String
    public let value: String
    public let unit: String

    #if os(macOS)
    public let levelIcon: NSImage?
    #elseif os(iOS)
    public let levelIcon: UIImage?
    #endif
}

public struct SignalLevelView: View {

    let model: SignalLevelViewModel

    public var body: some View {
        VStack(alignment: .center) {
            Text(self.model.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(.gray)

            #if os(macOS)
            self.model.levelIcon.map { Image(nsImage: $0) }
            #elseif os(iOS)
            self.model.levelIcon.map { Image(uiImage: $0) }
            #else
            EmptyView()
            #endif

            HStack(spacing: 0) {
                Spacer(minLength: 5)
                Text(self.model.value)
                    .font(.body)
                Spacer(minLength: 5)
            }
            Text(self.model.unit)
                .font(.footnote)
        }
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
            .background(
                Group {
                    #if os(macOS)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.controlBackgroundColor))
                        .shadow(radius: 2)
                    #elseif os(iOS)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                    #else
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .shadow(radius: 2)
                    #endif
                }
            )
    }
}

#if DEBUG

struct SignalLevelView_Previews: PreviewProvider {
    static var previews: some View {
        #if os(macOS)
        return SignalLevelView(model: SignalLevelViewModel(title: "RSSI", value: "-7", unit: "dB", levelIcon: NSImage(named: "NSImageNameFlowViewTemplate")))
        #elseif os(iOS)
        return SignalLevelView(model: SignalLevelViewModel(title: "RSSI", value: "-7", unit: "dB", levelIcon: UIImage(systemName: "function")))
        #else
        return SignalLevelView(model: SignalLevelViewModel(title: "RSSI", value: "-7", unit: "dB"))
        #endif
    }
}

#endif
