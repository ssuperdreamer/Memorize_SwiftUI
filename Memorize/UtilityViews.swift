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
