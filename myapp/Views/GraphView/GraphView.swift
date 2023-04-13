//
//  GraphView.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2023/3/22.
//
import CoreData
import SwiftUI
import Charts
struct GraphView: View{
    @Environment(\.managedObjectContext) var managedObejectContext
    
    let fetchRequest: NSFetchRequest<Diary> = NSFetchRequest<Diary>(entityName: "Diary")
    @State var diaries: [Diary] = []
    
    @State private var selectedFilter : DateFilter = .week

    @State  var selectedDate: Date = Date()
    @State  var selectedMood:Double = 0
    @State private var xPosition = 0.0
//    @State private var yPosition = 0.0
    @State private var showSelectionBar = false


    
    var body: some View{
        ZStack {
            Color(UIColor.systemBackground)
                .onTapGesture {
                    showSelectionBar = false
                }
            VStack{
                Spacer()
    //            List{
    //                ForEach(diaries){
    //                    Text("\($0.mood_index)")
    //                }
    //            }
    //            .frame(height: 100)
    //            Text("\(selectedMood )")
                
            dateSegmentPicker
               TopRecord
                    .padding()
                Mychart
                Spacer()

                
            }
            .frame(width: 350)
            .onAppear(perform: {getPredicate()
                if let latestDiary = diaries.sorted(by: { $0.diaryDate > $1.diaryDate }).first {
                    self.selectedDate = latestDiary.diaryDate
                    self.selectedMood = latestDiary.mood_index}
                
        })
        }
    }
    
}
    
extension GraphView{
    var TopRecord:some View{
        let myArray = diaries.map { $0.mood_index}
        let average = myArray.reduce(0, +) / Double(myArray.count)
        return HStack{
            VStack{
                Text("\(String(format: "%.1f", average))")
                    .padding(.bottom,3)
                Text("Average ")
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            VStack{
                Text("\(myArray.count)")
                    .padding(.bottom,3)
                Text("records")
                    .fontWeight(.bold)
            }
            Spacer()
            
            VStack{
                Text("\(getDiaryTime2(date:selectedDate))")
                    .padding(.bottom,3)
                Text("Date")
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            VStack{
                Text("\(String(format: "%.1f",selectedMood))")
                    .padding(.bottom,3)
                Text("Mood")
                    .fontWeight(.bold)
            }
            
        }
    }
    
    private var  dateSegmentPicker: some View {
       
        Picker("Select a date range", selection: $selectedFilter) {
                ForEach(DateFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue)
                }
            }
            .frame(maxWidth: .infinity)
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedFilter){_ in getPredicate()}
        }
    
    
    private func returnStartDate(for dateFilter: DateFilter) -> Date {
        var startDate = Date()
        switch dateFilter {
        case .week:
            startDate = Date().startOfWeek
        case .month:
            startDate = Date().startOfMonth
        case .year:
            startDate = Date().startOfYear
            
        }
        return (startDate)
    }
    
    private func getPredicate() {
        let startDate = returnStartDate(for:selectedFilter)
        let predicate = NSPredicate(format: "diaryDate >= %@ && diaryDate < %@", startDate as NSDate, Date() as NSDate)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "diaryDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            diaries = try managedObejectContext.fetch(fetchRequest)
        } catch {
            print("Error fetching events: \(error.localizedDescription)")
        }
    }
    
    private var Mychart:some View{
  
       
            VStack{
                let myArray = diaries.map { $0.mood_index}
                let average = myArray.reduce(0, +) / Double(myArray.count)
                GroupBox("mood_Index"){
                    Chart{
                        ForEach(diaries){
                            diary in
                            LineMark(x: .value("date", diary.diaryDate),
                                     y: .value("Mood", diary.mood_index)
                                     
                            )
                            .foregroundStyle(Color("myblack"))
                            .interpolationMethod(.catmullRom)//刚柔和
//                            .symbol(.diamond)//数据点
                        
                            
                            PointMark(x: .value("date", diary.diaryDate),
                                     y: .value("Mood", diary.mood_index))
                            .foregroundStyle(.red)

                            //
                            //                            .annotation(position:.top){

                            //                            }
                            
                            //                        PointMark(x: .value("date", diary.diaryDate), y: .value("Mood", diary.mood_index))
                        }
                        RuleMark(y:.value(" Average Mood", average))
                            .foregroundStyle(.red)
                        
                    }//chart
                    //                    .chartXAxisLabel("Weeks", alignment: .center)
                    .chartYAxis{
                        AxisMarks(position: .leading)
    //                    AxisGridLine()
    //                                            AxisTick()
                    }
                    .chartXAxis {
                        
                        AxisMarks() { value in
                        
                            if selectedFilter == .week{
                              AxisValueLabel(format: .dateTime.weekday(.short))
                               
                            }
                            else if selectedFilter == .month {
                                AxisValueLabel(format: .dateTime.month().day())
                            }
                            else {
                                AxisValueLabel(format: .dateTime.month())
                            }
                            
                        }
                        
                    }//chartXAxis
                    .chartOverlay { proxy in
                        
                        GeometryReader { geometry in
                            Rectangle().fill(.clear).contentShape(Rectangle())
                                .gesture(DragGesture()
                                    .onChanged { value in
                                        if !showSelectionBar {
                                            showSelectionBar = true}
                                        updateSelectedDate(at: value.location,
                                                           proxy: proxy,
                                                           geometry: geometry)
                                    }//end on changed
                                )//end gesture
                                .onTapGesture { location in
                                    updateSelectedDate(at: location,
                                                       proxy: proxy,
                                                       geometry: geometry)
                                }//end on tap
                            
                            Rectangle().foregroundStyle(Color("myblack"))
                                .frame(width: 2, height: geometry.size.height * 0.95)
                                .opacity(showSelectionBar ? 1.0 : 0.0)
                                .offset(x: xPosition)
                            
                            
                        }
                    }
                    
                    
                    
//                                        .chartPlotStyle { plotContent in
//                                          plotContent
//                                            .background(.green.opacity(0.4))
//                                            .border(Color.blue, width: 2)
//                                        } //背景色和边缘
                    .frame(height: 300)
                }//groupbox
                
            }
        }//Vstack
        
        
    
    
    private func updateSelectedDate(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        xPosition = location.x
        
        guard let date: Date = proxy.value(atX: xPosition) else {
            return
        }
        selectedDate = diaries
            .sorted(by: {
                abs($0.diaryDate.timeIntervalSince(date)) < abs($1.diaryDate.timeIntervalSince(date))
            })
            .first?.diaryDate ?? Date()
        
        selectedMood = diaries.first(where: { getDiaryTime(date: $0.diaryDate )
            == getDiaryTime(date: selectedDate) })?.mood_index ?? 0
        
        
    }
}
  


struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
            .environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
    }
}
