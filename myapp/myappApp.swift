//
//  myappApp.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2022/3/23.
//

import SwiftUI

@main
struct myappApp: App {

    let persistenceController = PersistenceController.shared
    
    
    
    //core
    var body: some Scene {
        WindowGroup{
            ContentView()

                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
