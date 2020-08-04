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
                    TextField("ToDo", text: $title)
                    DatePicker(selection: $duedate) {
                        Text("Remind Time")
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
                        Text("Done")
                    })
                    Button(action: {
                        presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
            }
            .navigationTitle("Details")
        }
    }
}

struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        EditingPage()
    }
}
