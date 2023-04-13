//
//  HomeView.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2023/4/5.
//

import SwiftUI

struct HomeView: View {
    @State private var animate :Bool = false
    var body: some View {
        
        ZStack(alignment: .center){
            
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.primary, lineWidth: 2)
                .frame(height: 650)
                .padding()
            
            VStack{
                Text("Today")
                    .font(.title2)
                Text(" \(getDiaryTime2(date:Date()))")
                    .font(.title)
                    .fontWeight(.bold)
                
                
                Image("peep-45")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                Text("  Why Not Generate Your Record ?  ")
                    .foregroundColor(Color(UIColor.systemBackground))
                    .font(.headline)
                    .frame(height:55)
                    .frame(width: 300)
                    .background(.primary)
                    .cornerRadius(10)
                    .padding(.top,30)
                
                
                
            }

                Image(systemName: "hand.point.down")
                .resizable()
                .scaledToFit()
                .frame(width:40,height: 50)
                .offset(y:animate ? 300 :280)
                .opacity(animate ? 0 : 1)
                .onAppear{
                    addAnimation(animate: $animate,delay: 1.0)
                }

                
        }//zstack

        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
