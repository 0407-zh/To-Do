//
//  UserData.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import SwiftUI
import Foundation
import UserNotifications
import UserNotificationsUI

var encoder = JSONEncoder()
var decoder = JSONDecoder()

let NotificationContent = UNMutableNotificationContent()

class ToDo: ObservableObject {
    @Published var todoList: [SingleToDo]
    var count: Int = 0
    
    init() {
        self.todoList = []
    }
    init(data: [SingleToDo]) {
        self.todoList = []
        for item in data {
            todoList.append(SingleToDo(notes: item.notes, title: item.title, duedate: item.duedate, isChecked: item.isChecked, isMarked: item.isMarked, isRemind: item.isRemind, remindTime: item.remindTime, id: self.count))
            count += 1
        }
    }
    
    //MARK: - Check
    func check(id: Int) {
        todoList[id].isChecked.toggle()
        
        // 需要再次删除或者添加通知
        if todoList[id].isChecked {
            withdrawNotification(id: id)
        } else {
            sendNotification(id: id)
        }
        
        dataStore()
    }
    
    //MARK: - 添加
    func add(data: SingleToDo) {
        todoList.append(SingleToDo(notes: data.notes, title: data.title, duedate: data.duedate, isMarked: data.isMarked, isRemind: data.isRemind, remindTime: data.remindTime, id: self.count))
        count += 1
        
        sort()
        
        dataStore()
        
        sendNotification(id: todoList.count - 1)
    }
    
    //MARK: - 编辑
    func edit(id: Int, data: SingleToDo) {
        withdrawNotification(id: id)
        todoList[id].notes = data.notes
        todoList[id].title = data.title
        todoList[id].duedate = data.duedate
        todoList[id].isChecked = data.isChecked
        todoList[id].isMarked = data.isMarked
        
        sort()
        
        dataStore()
        
        sendNotification(id: id)
    }
    
    //MARK: - 发送通知
    func sendNotification(id: Int) {
        NotificationContent.title = todoList[id].title
        NotificationContent.subtitle = todoList[id].notes
        NotificationContent.sound = UNNotificationSound.default
        
        guard let selectedDate = todoList[id].duedate else {
            return
        }

        let interval = selectedDate.timeIntervalSinceNow

        guard interval > 0 else {
            return
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: todoList[id].title + todoList[id].duedate!.description, content: NotificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    //MARK: - 撤回通知
    func withdrawNotification(id: Int) {
        // 移除通知，identifiers需要与添加通知时相同
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [todoList[id].title + todoList[id].duedate!.description])//仅能撤回已发送的通知
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [todoList[id].title + todoList[id].duedate!.description])
    }
    
    //MARK: - 删除提醒事项
    func delete(id: Int) {
        withdrawNotification(id: id)
        todoList[id].deleted = true
        
        dataStore()
    }
    
    //MARK: - 按照时间排序
    func sort() {
        todoList.sort (by: { (data1, data2) in
            return data1.duedate!.timeIntervalSince1970 < data2.duedate!.timeIntervalSince1970
        })
        for i in 0..<self.todoList.count {
            todoList[i].id = i
        }
    }
    
    //MARK: - 存储数据
    func dataStore() {
        let dataStored = try! encoder.encode(todoList)
        UserDefaults.standard.set(dataStored, forKey: "def")
    }
    
    //MARK: - 震动反馈
    func vibrationFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

struct SingleToDo: Identifiable, Codable {
//    var url: String = ""
    var notes: String = ""
    var title: String = ""
    var duedate: Date? = Date()
    var isChecked: Bool = false
    var isMarked: Bool = false
    var isRemind: Bool = false
    var remindTime: Bool = false
    var deleted: Bool = false
    
    var id: Int = 0
}

let formatter = DateFormatter()
let currentDate = DateFormatter()
let scheduledDate = DateFormatter()

func initUserData() -> [SingleToDo] {
    formatter.dateFormat = "EEEE, yyyy-MM-dd HH:mm"
    currentDate.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE, MMMd", options: 0, locale: currentDate.locale) // 用日期模版
    scheduledDate.dateFormat = "EEEE, yyyy-MM-dd"
    
    var output: [SingleToDo] = []
    if let dataStored = UserDefaults.standard.object(forKey: "def") as? Data {
        let data = try! decoder.decode([SingleToDo].self, from: dataStored)
        for item in data {
            if !item.deleted {
                output.append(SingleToDo(notes: item.notes, title: item.title, duedate: item.duedate, isChecked: item.isChecked, isMarked: item.isMarked, isRemind: item.isRemind, remindTime: item.remindTime, id: output.count))
            }
        }
    }
    return output
}

//https://stackoverflow.com/a/57877101/13623931
struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}

