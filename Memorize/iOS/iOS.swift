//
//  iOS.swift
//  Memorize
//
//  Created by Takeshi on 10/9/21.
//

import SwiftUI


extension UIImage {
    var imamgeData: Data? { jpegData(compressionQuality: 1.0) }
}

extension View {
    
    func paletteControlButtonStyle() -> some View {
        self
    }
    
    func popoverPadding() -> some View {
        self
    }
    
    @ViewBuilder
    func wrappedInNavigationViewToMakeDismissable(_ dismiss: (() -> Void)?) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
            NavigationView {
                self.navigationBarTitleDisplayMode(.inline)
                    .dismissable(dismiss)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            self
        }
    }
    
    @ViewBuilder
    func dismissable(_ dismiss:(() -> Void)?) -> some View {
        if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
            self.toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        } else {
            self
        }
    }
}


struct Pasteboard {
    static var imageData:Data? {
        UIPasteboard.general.image?.imamgeData
    }
    
    static var imageURL: URL? {
        UIPasteboard.general.url?.imageURL
    }
}
