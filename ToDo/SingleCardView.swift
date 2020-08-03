//
//  SingleCardView.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import SwiftUI

struct SingleCardView: View {
    @EnvironmentObject var userData: ToDo
    var index: Int
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 6)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 6){
                Text(userData.todoList[index].title)
                    .font(.headline)
                    .fontWeight(.heavy)
                Text(userData.todoList[index].duedate.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading)
            
            Spacer()
            
            Image(systemName: userData.todoList[index].isChecked ? "checkmark.square" : "square")
                .imageScale(.large)
                .padding(.trailing)
                .onTapGesture {
                    userData.check(id: index)
                }
        }
        .frame(height: 80)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10, x: 0, y: 10)
    }
}

struct SingleCardView_Previews: PreviewProvider {
    static var previews: some View {
        SingleCardView(index: 0)
    }
}
