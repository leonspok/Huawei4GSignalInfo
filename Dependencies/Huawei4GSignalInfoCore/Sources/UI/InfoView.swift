//
//  InfoView.swift
//  Huawei4GSignalInfoCore-iOS
//
//  Created by Igor Savelev on 11.01.2020.
//  Copyright © 2020 Igor Savelev. All rights reserved.
//

import SwiftUI

public struct InfoView: View {

    @ObservedObject public var model: InfoViewModel

    public init(model: InfoViewModel) {
        self.model = model
    }

    public var body: some View {
        Group {
            if self.model.infoViewModel != nil {
                self.model.infoViewModel.map { SignalInfoView(model: $0) }
            } else {
                Text(self.model.emptyText)
            }
        }
    }
}

#if DEBUG

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        let provider = FakeProvider()
        provider.signalInfo = nil
        return InfoView(model: InfoViewModel(provider: provider))
    }
}

#endif
