//
//  DiaryView.swift
/*  myapp

Created by 吴明翔翔翔 on 2023/3/18.*/
//

import SwiftUI

struct DiaryView: View {
    
    // MARK: Properties
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.diaryDate,order: .reverse)]) var corediaries:FetchedResults<Diary>
    @EnvironmentObject var tabBarStore: TabBarStore
    @State var showgraphview:Bool  = false
    @State var diaries: [Diary] = []
    @State var pickyear:Double = Double(Calendar.current.component(.year, from: Date()))
    @State var pickmonth:Double = Double(Calendar.current.component(.month, from: Date()))
//    @State var pickall:Bool = true
    
    
    //    @FetchReques(entity: Diary.entity(),sortDescriptors:
    //                    [NSSortDescriptor(keyPath:\Diary.diaryDate,ascending: true)]) var diaries:FetchedResults<Diary>
    
    

    //MARK: Body
    var body: some View {
        
        if corediaries.count == 0 {
            NavigationView{ NoItemsView()}
            
        }
        
        else{
            
            
            
            NavigationView{

                ZStack(alignment: .bottom){
                    
              
                    VStack{

                        
                        
                        NavigationLink(destination: SearchView()) {
                        StaticSearchView()
                        }
                        

                        myfilter
                        listView
                        
                        
                        
                    }
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
            .onAppear(perform: {
                diaries = Array(corediaries)

            })
            .onChange(of: pickmonth ){_ in DateFilter()}
            .onChange(of: pickyear ){_ in DateFilter()}
            
            .navigationViewStyle(.stack)//adapt for ipad

        }

        
    }
    
    //MARK: FUNCTIONS
    
    

}


extension DiaryView{
    
    
    private var myfilter:some View{
        
        HStack{
            VStack{
                let calendar = Calendar.current //

                let year = Double(calendar.component(.year, from: Date())) //
                let month = Double(calendar.component(.month, from: Date())) 
                
                Slider(value: $pickyear.animation(),
                       in: 2020...year,
                       step: 1
                )
                
                Slider(value: $pickmonth.animation(),
                       in: 1...month,
                       step: 1
                )

            }
//                            .tint(Color(UIColor.systemBackground))
            .tint(Color("myblack"))
            .frame(width: 150)
            .padding(.horizontal,20)
            
            VStack{
                    Text("Year:\(String(format: "%.0f",pickyear))")
                    Text("Month:\(Int(pickmonth))")
                    //
                }
            .foregroundColor(Color(UIColor.systemBackground))
            .fontWeight(.bold)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color("myblack")))
            .padding(.horizontal,20)
                
//            VStack{
//                Button(action: {}){Text("clear")
//                }
//
//            }
                
                
            }
        
    }
    private func DateFilter(){
        diaries = corediaries.filter { (date) -> Bool in
            let components = Calendar.current.dateComponents([.year,.month], from: date.diaryDate)
             return components.month == Int(pickmonth) && components.year == Int(pickyear)
         }
        
    }
    
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
//                                .padding()
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


