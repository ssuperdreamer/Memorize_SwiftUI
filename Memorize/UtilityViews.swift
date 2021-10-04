//
//  UtilityViews.swift
//  Memorize
//
//  Created by Takeshi on 10/1/21.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        if uiImage != nil {
            Image(uiImage: uiImage!)
        }
    }
}

struct IdentifiableAlert: Identifiable {
    var id: String
    var alert: () -> Alert
}

struct AnimatedActionButton: View {
    var title: String? = nil
    var systemImage: String? = nil
    var action: () -> Void
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            if title != nil && systemImage != nil {
                Label(title!, systemImage: systemImage!)
            } else if title != nil {
                Text(title!)
            } else if systemImage != nil {
                Image(systemName: systemImage!)
            }
        }
    }
}
