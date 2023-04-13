//
//  AddFoodView.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2022/3/23.
//


import SwiftUI
import CoreData

struct AddDiaryView: View {
    @Environment(\.managedObjectContext) var managedObejectContext
    var diary:FetchedResults<Diary>.Element? = nil
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tabBarStore: TabBarStore

    @State private var mytext = ""
    @State private var diaryDate  = Date()
    @State private var mood_index:Double = 5.0
    @State private var weather:String = "sun.max"

    @State var alertTitle:String = ""
    @State var showAlert :Bool = false
    @State var wordscount:Int = 0
    @State var myWeather: MyWeather = .sunny


    @State var isedited:Bool
    @State var showtime:Bool = false


    var body: some View {
                        ZStack{
                            Form{
                                Section{
                                    AddTopView(diaryDate: $diaryDate,showtime: $showtime)
                                    weatherPicker
                                    AddMidView()
                                    AddBottonView()
                                    
                                }//selection
            
                            } //form
                            .blur(radius: showtime ? 2 : 0)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color("myblack"), lineWidth: 3)
//                                    .frame(width: 360,height: 610)
//                                    .padding()
//
//                            )
                            
                            
                            
                    
                                if showtime{
                                    Color(UIColor.systemBackground).opacity(0.1)
                                        .onTapGesture {
                                            showtime = false}
                                }
                                
                                DatePickerView(diaryDate: $diaryDate,showtime: $showtime)
                                    .onChange(of: diaryDate, perform: { _ in
                                        showtime = false
                                    })


                            .animation(.spring(response: 0.3,dampingFraction: 0.9),value: showtime)

                                
                            
                        }//zstack
                        .navigationBarTitle(isedited ?"Edit your Diary":"Add Your Diary",displayMode:.inline)
                        .alert(isPresented: $showAlert, content: getAlert)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("myblack"), lineWidth:3)
                            .frame(width: 360,height: 650)
                            .padding()
                            .offset(y:10)

                        )
  

                    



        }
}

extension AddDiaryView{
    

    
    private func backbutton() -> some View{
        
        HStack {
            Button(action:{self.presentationMode.wrappedValue.dismiss()}){Image(systemName: "chevron.backward")
                    .font(.title)
                
                
            }
            .padding([.leading, .bottom], 15.0)
//                                    .offset(x:-160,y:-350)
            
            Spacer()
        }

    }
    
    private func AddMidView() -> some View{
       TextField("Write your today mood 😊", text: $mytext)
           .padding().frame(height: 300,alignment: .top)
           .onChange(of: mytext) { _ in
               let words = mytext.split { $0 == " " || $0.isNewline }
               self.wordscount = words.count}
           .onAppear{
               
               if let diary = self.diary ,isedited {
                   mytext = diary.mytext
                   diaryDate = diary.diaryDate
                   mood_index = diary.mood_index
                   weather = diary.weather
               
               }
}
           .overlay(content: {Text("\(wordscount)  ").offset(x:160,y: 140)
                   .font(.headline)
                   .foregroundColor(.secondary)
           })
   }
   private func AddBottonView()-> some View{
       VStack{
           MoodweatherBatteryView
           

           
           Slider(value: $mood_index.animation(),
              in: 0...10,
              step: 1
//              minimumValueLabel:Text("1"),
//              maximumValueLabel:Text("10"),
//              label: {Text("sd")}
       )
       .tint(Color("myblack"))
           
               Button("Submit"){submiteaction(isedited: isedited)}
                   .buttonStyle(.borderedProminent)
                   .foregroundColor(Color(UIColor.systemBackground))
                   .tint(Color("myblack"))
                   .padding()
 


}
       
   }
   private func getAlert() -> Alert{
       return Alert(title: Text(alertTitle))
   }
   private func submiteaction(isedited:Bool) {
       weather = myWeather.pickWeather

       if allAppropriate(){
           if isedited{
               if let diary = self.diary{
                   PersistenceController().editdiary(diary: diary, mytext: mytext,mood_index: mood_index, weather:weather, diaryDate :diaryDate ,context: managedObejectContext)}
           }else{
               PersistenceController().adddiary(mytext: mytext, mood_index: mood_index, diaryDate :diaryDate,weather:weather,context: managedObejectContext)}
           dismiss()


       }
   }
    private func textIsAppropriate()  -> Bool{
       let words = mytext.split { $0 == " " || $0.isNewline }
       if words.count  < 3{
           return false
       }
       return true
   }
    
    private func DateIsAppropriate()  -> Bool{
    
    let fetchRequest: NSFetchRequest<Diary> = NSFetchRequest<Diary>(entityName: "Diary")
    let startOfNewDate = Calendar.current.startOfDay(for: diaryDate)
    let endOfNewDate = Calendar.current.date(byAdding: .day, value: 1, to: startOfNewDate)! as NSDate

    let predicate = NSPredicate(format: "diaryDate >= %@ AND diaryDate < %@", startOfNewDate as NSDate, endOfNewDate)

    fetchRequest.predicate = predicate
    do {
        let events = try managedObejectContext.fetch(fetchRequest)
        if events.count > 0 {
            // 如果有重叠的事件，则新建日期与存储的日期重叠
            return false

        }
    } catch {
        // 处理错误
        return false
    }
    return true
}//end fuc
    
    private func allAppropriate()-> Bool{

        if !textIsAppropriate(){
            alertTitle = " your new content should greater than 3 charcters long"
            showAlert.toggle()
            return false
        }
        else if !DateIsAppropriate(){
            if isedited{
                return true
            }
            else {
                alertTitle = " the date has already created"
                showAlert.toggle()
                return false}
       
        }
        else{
            return true
        }
        
    }//end function
    
    
    var MoodweatherBatteryView:some View{
        
        VStack{
            Text("my mood index: \(Int(mood_index))")
                .fontWeight(.bold)
            
            HStack{
             
                Image(systemName: myWeather.pickWeather)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .padding()
                BatteryView(mood_index: $mood_index)
                    .frame(width: 100)
                .padding()
            }
            

            
            
        }
    }
    
    var weatherPicker:some View{
        HStack{
            Text("Weather")
                .fontWeight(.bold)
                .foregroundColor(Color("myblack"))
            
            Picker("",selection: $myWeather) {
                    ForEach(MyWeather.allCases, id: \.self) { filter in
                        Text(filter.rawValue)
                    }
                }
                .frame(maxWidth: .infinity)
                .pickerStyle(.menu)
        }

        
    }
    
}


struct AddTopView: View {
    @Binding var diaryDate:Date
    @Binding var showtime:Bool
    var body: some View {
        HStack{
            Text("Diary Date ")
                .fontWeight(.bold)
                .foregroundColor(Color("myblack"))
            Spacer()
            Button(action: {
               showtime.toggle()})
                 {Text(" \(getDiaryTime(date:diaryDate))")}

        }
        .animation(.spring(response: 0.5,dampingFraction: 0.7),value: showtime)
        

    }
}
struct AddDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        AddDiaryView(isedited: false)

    }
}



struct DatePickerView: View {
    private let startdate:Date = Calendar.current.date(from: DateComponents(year:2021)) ?? Date()

    @Binding var diaryDate: Date
    @Binding var showtime:Bool
    var body: some View {
        if showtime{
                DatePicker("Diary Date",selection: $diaryDate,in: startdate...Date(),displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .background(Color(UIColor.systemBackground))
//                                .background(Color("myblack"))
                             
                                .accentColor(Color("myblack"))

            
                    .padding()
//                    .offset(y:-250)
                    .transition(AnyTransition.move(edge: .leading))
                
            }
                
            
  



    }
}

