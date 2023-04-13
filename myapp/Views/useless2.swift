//
//  useless2.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2023/3/25.
// 日期搜索，天气
//chart 动画，模拟器不显示

import SwiftUI

struct useless2:View {
 
//        var calendar = Calendar.current
    @State var rating:Int = 5

        var body: some View {

            ZStack{
                batt
                    .overlay(
                    
                        overlay.mask(batt))
                
            }
           
        }
    
    
    
    
    
    
    
    var batt:some View{
        Image(systemName:"battery.100")
            .resizable()
            .scaledToFit()
            .font(.headline.weight(.ultraLight))
            .foregroundColor(.primary)
        
    }
    
    var overlay:some View{
        Rectangle()
            .foregroundColor(.yellow)
        
    }
    }

 

struct useless2_Previews: PreviewProvider {
    static var previews: some View {
        useless2()
    }
}



