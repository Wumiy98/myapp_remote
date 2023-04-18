//
//  ContentView.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2022/3/23.
//

import SwiftUI
import CoreData

//test
    
struct ContentView: View {
    @State private var currentSelected:Tab = .home
    @StateObject var tabBarStore: TabBarStore = TabBarStore()
    
    var body: some View {
        

        
        VStack{

            switch currentSelected {
            case .home:
                HomeView()
//                DiaryView()
                
            case .diary:
                DiaryView()
            }
            
//            TabBar()
            Spacer()
            if !tabBarStore.isHidden{
                TabBar(currentSelected:$currentSelected)
                    .transition(.move(edge: .bottom))

//                    .animation(.easeInOut(duration: 0.2))
            }
            
            
        }//tabview
        .ignoresSafeArea(edges:.bottom)
        .environmentObject(tabBarStore)

        
    }
        
    }
    

    
    

    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            Group{
                ContentView( )
                    .environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
                    .preferredColorScheme(.light)
                
                ContentView( )
                    .environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
                    .preferredColorScheme(.dark)
                
            }

//            
        }
    }

