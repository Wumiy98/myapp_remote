//
//  SearchView.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2023/3/6.
//



import SwiftUI
import CoreData

struct SearchView: View {

//    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    @Environment(\.managedObjectContext) var managedObejectContext
    @EnvironmentObject var tabBarStore: TabBarStore
    let fetchRequest: NSFetchRequest<Diary> = NSFetchRequest<Diary>(entityName: "Diary")
    
    @State private var diaries: [Diary] = []
    @State private var searchText = ""

    var body: some View {
            VStack{
            searchTab(searchText:$searchText)
                .onChange(of: searchText){ _ in
                    searchEvents()
                }
            Spacer()
                ZStack{
                    Image("peep-17")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 500)
                        
                    if diaries.count != 0 {
                    searchList

                        }
                }

                

                
            Spacer()
        }
            .transition(.move(edge: .bottom))
            .animation(.spring(response:0.5 ,dampingFraction: 0.7),value:diaries.count)
//            .toolbar(.hidden, for: .tabBar)

        .ignoresSafeArea(edges:.bottom)
        .onAppear {
            withAnimation(.easeIn(duration: 0.2)){tabBarStore.isHidden = true}
        }
        .onDisappear {
            withAnimation(.easeIn(duration: 0.2)){tabBarStore.isHidden = false}
//                            tabBarStore.isHidden = false
        }
        
        }
    }


extension SearchView{
    func searchEvents() {
        let predicate = NSPredicate(format: "mytext CONTAINS[cd] %@", searchText)
                fetchRequest.predicate = predicate
        do {
            diaries = try managedObejectContext.fetch(fetchRequest)
        } catch {
            print("Error fetching events: \(error.localizedDescription)")
        }
    }
    
    var searchList : some View {
        List(diaries, id: \.self) { item in
            NavigationLink(item.mytext){ AddDiaryView(diary: item,isedited: true)
//            .navigationBarItems(trailing:backToContenView())
                
            }
            .listStyle(.plain)
        }
        .frame(minHeight:600)
//        .transition(.move(edge: .bottom))
//        .animation(.spring(response:0.5 ,dampingFraction: 0.7),value: diaries.count)
    }
    

    
}

struct cleanButton: View {
    @Binding var searchText:String
    
    var body: some View {
        Button(action: {
            searchText = ""
            //收起键盘
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
        }) {
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
        }
    }
}

struct GlassView: View {
    var body: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
    }
}

struct searchTab: View {
    @Binding var searchText:String
    @FocusState var focusSearch:Bool
    var body: some View {
        TextField("Search the content", text: $searchText)
            .focused($focusSearch)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .multilineTextAlignment(.leading)
            .overlay(
                HStack {
                    GlassView()
                    // 编辑时显示清除按钮
                    if searchText != "" {
                        cleanButton(searchText: $searchText)
                    }
                }
            )
            .padding(.horizontal, 10)
            .onAppear(perform: {
                focusSearch.toggle()
            })
    }
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
    }
}

struct backToContenView: View {
    var body: some View {
        NavigationLink(destination: DiaryView()
            .navigationBarBackButtonHidden(true)
        ){
  
            Text("DiaryList")
                .foregroundColor(.blue)
            
            Image(systemName: "book.fill")
                .font(.caption)
                .foregroundColor(.blue)
        }
    }
}

struct StaticSearchView: View {
    var body: some View {
        ZStack(alignment:.leading){
            GlassView()
            Text("Search the Content")
                .padding(.leading,30)
        }
        .padding(7)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6).cornerRadius(8))
        .padding(8)
        .foregroundColor(.gray)
//        .padding(.bottom,-5)
    }
}
