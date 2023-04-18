//
//  useless2.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2023/3/25.
// 日期搜索
//chart 动画，模拟器不显示
//记录日记数量

import SwiftUI

struct Useless2: View {
    
    @State var a:Int = 1
    @State var b:Int = 2
//    var pickWeather: String
    
    var body: some View {
        
        VStack{
            
            let calendar = Calendar.current // 获取当前的日历

            let year = Int(calendar.component(.year, from: Date())) // 获取当前的年份
            let month = Double(calendar.component(.month, from: Date())) // 获取当前的月份
            Text("\(year)")
            Text("\(month)")
        }
        .background(.blue)
        .frame(width: 40)



    }
    

}


 

struct Useless2_Previews: PreviewProvider {
    static var previews: some View {
        Useless2()
    }
}



