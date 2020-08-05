//
//  EditingButton.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/5.
//

import SwiftUI

struct EditingButton: View {
    @Binding var editingMode: Bool
    @Binding var selection: [Int]
    
    var body: some View {
        Button(action: {
            editingMode.toggle()
            selection.removeAll()
        }){
            Image(systemName: "slider.horizontal.3")
                .imageScale(.large)
        }
    }
}

//struct EditingButton_Previews: PreviewProvider {
//    static var previews: some View {
//        EditingButton()
//    }
//}
