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
    @State var isFlagged: Bool = false
    @State var isRemind: Bool = false
    @Environment(\.presentationMode) var presentation
    
    var id: Int? = nil
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("To Do", text: $title)
                    Toggle(isOn: $isRemind, label: {
                        Text("Remind me at a time")
                    })
                    if isRemind {
                        DatePicker(selection: $duedate) {
                            Text("Remind Time")
                        }
                    }
                }
                
                Section{
                    Toggle(isOn: $isFlagged) {
                        Text("Flag")
                        Image(systemName: isFlagged ? "flag.fill" : "flag")
                            .foregroundColor(.orange)
                            .imageScale(.medium)
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
