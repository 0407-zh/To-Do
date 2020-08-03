//
//  EditingPage.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import SwiftUI

struct EditingPage: View {
    @EnvironmentObject var userData: ToDo
    @State var title: String = ""
    @State var duedate: Date = Date()
    @Environment(\.presentationMode) var presentation
    
    var id: Int? = nil
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("提醒事项", text: $title)
                    DatePicker(selection: $duedate) {
                        Text("截止时间")
                    }
                }
                Section {
                    Button(action: {
                        if id == nil {
                            userData.add(data: SingleToDo(title: title, duedate: duedate))
                        } else {
                            userData.edit(id: self.id!, data: SingleToDo(title: title, duedate: duedate))
                        }

                        presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("确认")
                    })
                    Button(action: {
                        presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("取消")
                    })
                }
            }
            .navigationTitle("编辑提醒事项")
        }
    }
}

struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        EditingPage()
    }
}
