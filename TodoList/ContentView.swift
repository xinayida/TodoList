//
//  ContentView.swift
//  TodoList
//
//  Created by 王为 on 2021/1/18.
//

import SwiftUI

func initUserData() -> [SingleToDo] {
    var output: [SingleToDo] = []
    if let dataStored = UserDefaults.standard.object(forKey: "todoList") as? Data{
        let data = try! decoder.decode([SingleToDo].self, from: dataStored)
        for item in data {
            if !item.deleted{
                output.append(SingleToDo(title: item.title, dueDate: item.dueDate, isChecked: item.isChecked, id: item.id))
            }
        }
    }
    return output
}

struct ContentView: View {
    
    @ObservedObject var userData: ToDo = ToDo(data: initUserData())
    
    @State var showEditingPage: Bool = false
    @State var selection: [Int] = []
    @State var editingMode: Bool = false
    
    var body: some View {
        ZStack{
            NavigationView{
                ScrollView(.vertical,showsIndicators: true){
                    VStack {
                        ForEach(self.userData.todoList){item in
                            if !item.deleted{
                                SingleCardView(index: item.id, editingMode: self.$editingMode, selection: self.$selection)
                                    .environmentObject(self.userData)
                                    .padding(.horizontal)
                                    .padding(.top)
                                    .animation(.spring())
                                    .transition(.slide)
                            }
                        }
                    }.padding(.horizontal)
                }
                .navigationTitle("提醒事项")
                .navigationBarItems(trailing: HStack(spacing: 20) {
                    if self.editingMode {
                        DeleteButton(selection: self.$selection)
                            .environmentObject(self.userData)
                    }
                    EditingButton(editingMode: self.$editingMode, selection: self.$selection)
                })
            }
            //浮动窗
            HStack{
                Spacer()
                VStack{
                    Spacer()
                    Button(action: {
                        self.showEditingPage = true
                    }){
                        Image(systemName: "plus.circle.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 80, height: 80, alignment: .center).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).padding(.trailing)
                    }
                    .sheet(isPresented: self.$showEditingPage, content: {
                        EditingPage().environmentObject(self.userData)
                    })
                }
            }
        }
    }
}

struct DeleteButton: View{
    
    @Binding var selection: [Int]
    @EnvironmentObject var userData: ToDo
    
    var body: some View {
        Button(action: {
            for i in selection {
                userData.delete(id: i)
            }
        }){
            Image(systemName: "trash")
                .imageScale(.large)
        }
    }
}

struct EditingButton:View {
    @Binding var editingMode: Bool
    @Binding var selection: [Int]
    var body: some View{
        Button(action: {
            self.editingMode.toggle()
            selection.removeAll()
        }){
            Image(systemName: "gear").imageScale(.large)
        }
    }
}

struct SingleCardView: View {
    @EnvironmentObject var userData: ToDo
    var index: Int
    @State var isChecked : Bool = false
    @State var showEditingPage: Bool = false
    @Binding var editingMode: Bool
    @Binding var selection: [Int]
    
    var body: some View {
        HStack {
            Rectangle().frame(width: 6).foregroundColor(.blue)
            //删除按钮
            if editingMode {
                Button(action: {
                    self.userData.delete(id: self.index)
                }){
                    Image(systemName: "trash").imageScale(.large).padding(.leading)
                }
            }
            //内容部分
            Button(action: {
                if !self.editingMode {
                    self.showEditingPage = true
                }
            }){
                Group {
                    VStack(alignment: .leading, spacing: 6.0){
                        Text(self.userData.todoList[index].title).font(.headline).fontWeight(.heavy)
                            .foregroundColor(.black)
                        Text(self.userData.todoList[index].dueDate.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }.padding(.leading)
                    Spacer()
                }
            }
            //弹出编辑框
            .sheet(isPresented: self.$showEditingPage, content: {
                EditingPage(title: self.userData.todoList[index].title,
                            dueDate: self.userData.todoList[index].dueDate,
                            id: self.index)
                    .environmentObject(self.userData)
            })
            
            //右边按钮
            if !editingMode {
                Image(systemName: self.userData.todoList[index].isChecked ? "checkmark.square.fill": "square").imageScale(.large).padding(.trailing)
                    .onTapGesture {
                        self.userData.check(id: self.index)
                    }
            } else {
                Image(systemName: selection.contains(index) ? "checkmark.circle.fill" : "circle").imageScale(.large).padding(.trailing)
                    .onTapGesture {
                        if selection.contains(index) {
                            selection.remove(at: selection.firstIndex(of: index)!)
                        } else {
                            selection.append(index)
                        }
                    }
            }
        }
        .frame(height: 80, alignment: .center)
        .background(Color.white)
        .cornerRadius(10, antialiased: true)
        .shadow(radius: 10,x:0, y:10)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userData: ToDo(data: [SingleToDo(title: "写作业"), SingleToDo(title: "复习")]))
    }
}
