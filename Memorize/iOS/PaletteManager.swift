//
//  PaletteManager.swift
//  Memorize
//
//  Created by Takeshi on 10/4/21.
//

import SwiftUI

struct PaletteManager: View {
    @EnvironmentObject var store: PaletteStore
    
//    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.presentationMode) var presentationModel
    
    @State private var editModel: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palette in
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[palette])) {
                        VStack(alignment: .leading) {
                            Text(palette.name).font(editModel == .active ? .largeTitle : .caption)
                            Text(palette.emojis)
                        }
                        .gesture(editModel == .active ? tap : nil)
                    }
                }.onDelete { indexSet in
                    store.palettes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
                
            }
            .navigationTitle("Manage Palettes")
            .navigationBarTitleDisplayMode(.inline)
            .dismissable{ presentationModel.wrappedValue.dismiss() }
            .toolbar {
                ToolbarItem { EditButton() }
            }
            .environment(\.editMode, $editModel)
        }
        
       
    }
    
    var tap: some Gesture {
        TapGesture().onEnded {
            print("xxxxx")
        }
    }
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager().previewDevice("iPhone 8").environmentObject(PaletteStore(named: "Preview"))
            .preferredColorScheme(.light)
    }
}
