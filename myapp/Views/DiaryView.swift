//
//  DiaryView.swift
/*  myapp

Created by 吴明翔翔翔 on 2023/3/18.*/
//

import SwiftUI

struct DiaryView: View {
    
    // MARK: Properties
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.diaryDate,order: .reverse)]) var diaries:FetchedResults<Diary>
    @EnvironmentObject var tabBarStore: TabBarStore
    @State var showgraphview:Bool  = false
    
    
    //    @FetchReques(entity: Diary.entity(),sortDescriptors:
    //                    [NSSortDescriptor(keyPath:\Diary.diaryDate,ascending: true)]) var diaries:FetchedResults<Diary>
    
    
//    @State private var showingAddView = false
//     var searchIsEdited:Bool = false

    //MARK: Body
    var body: some View {
        
        
        if diaries.count == 0 {
            NavigationView{ NoItemsView()}
            
        }
        
        else{
            NavigationView{

                ZStack(alignment: .bottom){
                    
//                    Color.black

                    VStack(alignment:.leading){
                        Text("you have recorded \(Int(diaries.count)) diaries")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        NavigationLink(destination: SearchView()) {
                        StaticSearchView()}
                        listView
                        .padding()
                        
                    }
                    .accentColor(.red)
                    .navigationBarItems(
                        trailing: Button(action: {
                            showgraphview.toggle()
                        }){
                                Image(systemName: "chart.line.uptrend.xyaxis.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                        })
                  
                    .sheet(isPresented: $showgraphview){
                        GraphView()
                    }



                }

            }//navigation end
            
            .navigationViewStyle(.stack)//adapt for ipad
        }
        
    }
    
    //MARK: FUNCTIONS
    
    

}


extension DiaryView{
    
    var listView: some View {

            List{
                ForEach(diaries){
   
                    diary in
                    NavigationLink(destination: AddDiaryView(diary: diary,isedited:true)
                        .onAppear {
                            withAnimation(.easeIn(duration: 0.2)){tabBarStore.isHidden = true}
                        }
                        .onDisappear {
                            withAnimation(.easeIn(duration: 0.2)){tabBarStore.isHidden = false}
//                            tabBarStore.isHidden = false
                        }
                    
                    ){//test
                        Rowview(diaryDate: diary.diaryDate,
                                mood_index:diary.mood_index,
                                mydate: diary.date,weather: diary.weather)
                        
//                        Text("\(diary.mood_index)")
//                        Text("\(diary.diaryDate)")
                        
                        
                        
                        
                        
                       
                    }//test
                    
                    
                }
                .onDelete(perform:deletdiary)
                .padding()
            }
            .listStyle(.plain)
//            .overlay{
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color("myblack"), lineWidth: 3)
//                    .frame(width: 380,height:640)
//                    .padding()
//
//
//            }

            .navigationTitle("MyDiary")
        
    }
    
 

    private func deletdiary(offsets: IndexSet){
        withAnimation(.spring()){
            offsets.map{diaries[$0]}.forEach(managedObjContext.delete)
            PersistenceController().save(context: managedObjContext)
        }

    }
}
//MARK: PREVIEW
struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView()                .environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
    }
}


