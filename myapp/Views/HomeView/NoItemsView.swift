//
//  NoItemsView.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2023/3/5.
//

import SwiftUI
import UIKit

struct NoItemsView: View {
    
    @State   private var animate :Bool = false
    
    let mycolor1 = Color("Color1")
    let mycolor2 = Color("Color2")
    var body: some View {

            VStack(alignment: .center, spacing: 10){
                Image("sitting1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .shadow(radius: 10)
                Text("There are no items")
                    .font(.title)
                    .fontWeight(.bold)
                Text("I will fix it later.we should add somethings here. Do you think so")
                    .padding(.bottom,20)
                NavigationLink(destination: AddDiaryView(isedited: false)){
                    Text("add something")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height:55)
                        .frame(maxWidth:.infinity)
                        .background(animate ? Color.primary : Color.primary)
                        .cornerRadius(10)
           

                }
                .padding(.horizontal,animate ? 30 : 50)//change long
                .shadow(color:animate ? Color.primary.opacity(0.7) : Color.secondary.opacity(0.7),
                        radius: animate ? 30 : 10,
                        x:0.0,
                        y:animate ? 50 : 30)
                .scaleEffect(animate ? 1.1 : 1.0)//change size
                .offset(y: animate ? -7 : 0) // up and down change
            }

                    .frame(maxWidth: 400)
                    .multilineTextAlignment(.center)
                    .padding(40)
                    .onAppear{addAnimation(animate: $animate,delay: 1.5)}
            

        }

    
}
    

    
    struct NoItemsView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView{
                NoItemsView()
            }
            
            
        }
    }

