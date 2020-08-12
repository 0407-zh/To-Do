//
//  ShowMarkedOnlyButton.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/11.
//

import SwiftUI

struct ShowMarkedOnlyButton: View {
    @Binding var showMarkedOnly: Bool
    
    var body: some View {
        Button(action: {
            showMarkedOnly.toggle()
        }){
            Image(systemName: showMarkedOnly ? "bookmark.fill" : "bookmark")
                .foregroundColor(.orange)
                .imageScale(.large)
        }
    }
}

//struct ShowMarkedOnlyButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowMarkedOnlyButton(showMarkedOnly: .constant(false))
//    }
//}
