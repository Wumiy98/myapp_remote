//
//  ContentView.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2022/3/23.
//

import SwiftUI
import CoreData

//struct ContentView: View {
//    @State var selectedTab :Int
//
//    init(selectedTab:Int = 0) {
//        self.selectedTab = selectedTab//change tabview
//        let appearance = UITabBarAppearance()
//        appearance.backgroundColor = .white // Set tab bar background color
//        appearance.shadowImage = UIImage() // Remove tab bar shadow
//        appearance.shadowColor = .clear // Set tab bar shadow color
//        UITabBar.appearance().standardAppearance = appearance // Set standard appearance
//    }
//    var body: some View {
//
//
//        //        NavigationView {
//        TabView(selection: $selectedTab){
//            Text("Home")
//                .tabItem{
//
//                    Image(systemName: "house.fill")
//                    Text("Home")
//                }
//                .tag(1)
//
//            DiaryView()
//                .tabItem{
//                    Image(systemName: "book.fill")
//                    Text("Diary")
//                }.tag(2)
//
//            GraphView()
//                .tabItem{
//
//                    Image(systemName: "chart.xyaxis.line")
//                    Text("Graph")
//                }
//                .tag(3)
//
//
//
//
//
//
//
//
//        }//tabview
//
//
//
//    }
//
//}
    
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

