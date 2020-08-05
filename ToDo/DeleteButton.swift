//
//  DeleteButton.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/5.
//

import SwiftUI

struct DeleteButton: View {
    @Binding var selection: [Int]
    @EnvironmentObject var userdata: ToDo
    
    var body: some View {
        Button(action: {
            for i in selection {
                userdata.delete(id: i)
            }
        }){
            Image(systemName: "trash")
                .imageScale(.large)
        }
    }
}

//struct DeleteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteButton()
//    }
//}
