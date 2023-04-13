//
//  uselesstest files.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2023/3/14.
//


//加入天气segment
//图表
//Tab

import SwiftUI
import Charts
import CoreData



struct chartsView:View{

        @Binding var diaries: [Diary]
        var body: some View{
            VStack{
                GroupBox("mood_Index"){
                    Chart{
                        ForEach(diaries){
                            diary in
                            LineMark(x: .value("date", diary.diaryDate),
                                    y: .value("Mood", diary.mood_index)
                            )
                            //                        .interpolationMethod(.catmullRom)//刚柔和
                            //                        .symbol(.diamond)//数据点
                            //
                            .annotation(position:.top){
                                Text("\(diary.mood_index, specifier: "%.0f")")
                            }
                            //                        PointMark(x: .value("date", diary.diaryDate), y: .value("Mood", diary.mood_index))
                            .accessibilityLabel(getDiaryTime(date: diary.diaryDate))
                            .accessibilityValue("\(diary.mood_index) Steps")
                        }
                    }//chart


                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                }//groupbox

            }//Vstack
        }
 }//mychart

            
 
    


struct chartsView_Previews: PreviewProvider {
    static var previews: some View {
        chartsView()            
            .environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
    }
}
