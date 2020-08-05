//
//  UserData.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import Foundation
import UserNotifications

var encoder = JSONEncoder()//编码器
var decoder = JSONDecoder()//解码器

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
            todoList.append(SingleToDo(id: self.count, /*isFavorite: item.isFavorite,*/ title: item.title, duedate: item.duedate, isChecked: item.isChecked))
            count += 1
        }
    }
    
    func check(id: Int) {
        todoList[id].isChecked.toggle()
    }
    
    //MARK: 添加新提醒事项
    func add(data: SingleToDo) {
        todoList.append(SingleToDo(id: self.count, /*isFavorite: data.isFavorite,*/ title: data.title, duedate: data.duedate))
        count += 1
        
        sort()
        
        dataStore()
        
        sendNotification(id: todoList.count - 1)
    }
    
    //MARK: 编辑现有提醒事项
    func edit(id: Int, data: SingleToDo) {
        withdrawNotification(id: id)
        todoList[id].title = data.title
        todoList[id].duedate = data.duedate
        todoList[id].isChecked = false
//        todoList[id].isFavorite = data.isFavorite
        
        sort()
        
        dataStore()
        
        sendNotification(id: id)
    }
    
    //MARK: 发送通知
    func sendNotification(id: Int) {
        NotificationContent.title = todoList[id].title
        NotificationContent.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: todoList[id].duedate.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: todoList[id].title + todoList[id].duedate.description, content: NotificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    //MARK: 撤回通知
    func withdrawNotification(id: Int) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [todoList[id].title + todoList[id].duedate.description])//仅能撤回已发送的通知
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [todoList[id].title + todoList[id].duedate.description])
    }
    
    //MARK: 删除提醒事项
    func delete(id: Int) {
        withdrawNotification(id: id)
        todoList[id].deleted = true
        
        dataStore()
    }
    
    //MARK: 对提醒事项按照时间排序
    func sort() {
        todoList.sort (by: { (data1, data2) in
            return data1.duedate.timeIntervalSince1970 < data2.duedate.timeIntervalSince1970
        })
        for i in 0..<self.todoList.count {
            todoList[i].id = i
        }
    }
    
    //MARK: 存储数据
    func dataStore() {
        let dataStored = try! encoder.encode(todoList)
        UserDefaults.standard.set(dataStored, forKey: "todoList")
    }
}

struct SingleToDo: Identifiable, Codable {
    var id: Int = 0
    
    var deleted: Bool = false
//    var isFavorite: Bool = false
    
    var title: String = ""
    var duedate: Date = Date()
    var isChecked: Bool = false
}
