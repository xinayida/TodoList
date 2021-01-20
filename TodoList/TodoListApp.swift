//
//  TodoListApp.swift
//  TodoList
//
//  Created by 王为 on 2021/1/18.
//

import SwiftUI
import NotificationCenter
@main
struct TodoListApp: App {
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(success, error) in
            if success {
                print("success")
            } else {
                print("error")
            }
        })
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
