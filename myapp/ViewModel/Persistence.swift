//
//  Persistence.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2023/3/7.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        //
        for index in 0..<150 {
            let newItem = Diary(context: viewContext)
            let date = Date()
            newItem.id = UUID()
            newItem.date = date
            newItem.diaryDate = Calendar.current.date(byAdding: .day, value: -Int(index), to: date) ?? Date()
            newItem.mytext = "Content number\(index)"
            newItem.mood_index = Double(Int.random(in:1...10))

        }// 这一部分就是用来初始化内容的


        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name:"DiaryModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                print("fail to load the data\(error.localizedDescription)")
//                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save(context:NSManagedObjectContext){
        do{
            try context.save()
            print("data saved!!!")
        } catch {
            print("we could not save")
        }
    }
    
    
    func adddiary(mytext: String, mood_index:Double,diaryDate:Date, context:NSManagedObjectContext){
        
        let diary = Diary(context: context)
        diary.id = UUID()
        diary.date = Date()
        diary.mytext = mytext
        diary.mood_index = mood_index
        diary.diaryDate = diaryDate
        save(context: context)
    }
    
    func editdiary(diary:Diary, mytext: String,mood_index:Double,diaryDate:Date,context:NSManagedObjectContext){
        diary.date = Date()
        diary.mytext = mytext
        diary.mood_index = mood_index
        diary.diaryDate = diaryDate
        
        save(context: context)
        
    }
    
//    func deletdiary(diary:Diary,offsets: IndexSet,context:NSManagedObjectContext){
//        withAnimation{
//            offsets.map{diary[$0]}.forEach(context.delete)
//            save(context: context)
//        }
//
//    }
}
