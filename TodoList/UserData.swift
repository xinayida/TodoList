//
//  UserData.swift
//  TodoList
//
//  Created by 王为 on 2021/1/19.
//

import Foundation
import UserNotifications

var encoder = JSONEncoder()
var decoder = JSONDecoder()

let notificationContent = UNMutableNotificationContent()

class ToDo: ObservableObject {
    @Published var todoList: [SingleToDo]
    var count = 0
    
    init(){
        todoList = []
        
    }
    init(data: [SingleToDo]) {
        self.todoList = []
        for item in data{
            self.todoList.append(SingleToDo(title: item.title, dueDate: item.dueDate, isChecked: item.isChecked, isFavorite: item.isFavorite, id: self.count))
           count += 1
        }
    }
    
    func showNotification(id: Int){
        notificationContent.title = self.todoList[id].title
        notificationContent.sound = UNNotificationSound.default
        
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: self.todoList[id].dueDate.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: self.todoList[id].title + self.todoList[id].dueDate.description, content: notificationContent, trigger: triger)
        print("sendRequest \(request.content)")
        UNUserNotificationCenter.current().add(request)
    }
    
    func withdrawNotification(id: Int) {
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        let identifier = self.todoList[id].title + self.todoList[id].dueDate.description
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func check(id: Int) {
        self.todoList[id].isChecked.toggle()
        self.dataStore()
    }
    
    func add(data: SingleToDo) {
        todoList.append(SingleToDo(title: data.title, dueDate: data.dueDate, isFavorite: data.isFavorite, id: self.count))
        self.count += 1
        self.sort()
        self.dataStore()
        
        showNotification(id: todoList.count - 1)
    }
    
    func edit(id: Int, data: SingleToDo) {
        withdrawNotification(id: id)
        self.todoList[id].dueDate = data.dueDate
        self.todoList[id].title = data.title
        self.todoList[id].isChecked = false
        self.todoList[id].isFavorite = data.isFavorite
        self.sort()
        self.dataStore()
        showNotification(id: id)
    }
    
    func sort(){
        self.todoList.sort(by: {(data1, data2) in
            return data1.dueDate.timeIntervalSince1970 < data2.dueDate.timeIntervalSince1970
//            return data1.dueDate.distance(to: data2.dueDate) > 0
        })
        
        for i in 0 ..< self.todoList.count{
            self.todoList[i].id = i
        }
    }
    
    func delete(id: Int) {
        withdrawNotification(id: id)
        self.todoList[id].deleted = true
//        self.ToDoList.remove(at: id)
//        for i in id ..< self.ToDoList.count{
//            self.ToDoList[i].id = i
//        }
        self.dataStore()
    }
    
    func dataStore(){
        let dataStore = try! encoder.encode(self.todoList)
        UserDefaults.standard.set(dataStore, forKey: "todoList")
    }
}

struct SingleToDo: Identifiable , Codable{
    var title: String = ""
    var dueDate: Date = Date()
    var isChecked: Bool = false
    var deleted: Bool = false
    var isFavorite: Bool = false
    var id: Int = 0
}
