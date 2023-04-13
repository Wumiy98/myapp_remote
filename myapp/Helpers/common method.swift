//
//  common method.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2023/4/7.
//

import Foundation
import SwiftUI


func addAnimation(animate:Binding<Bool>,delay:Double){
    guard !animate.wrappedValue else {return}
    DispatchQueue.main.asyncAfter(deadline: .now() + delay){
        withAnimation(
            Animation
                .easeInOut(duration: 1.0)
                .repeatForever()
        ){
            animate.wrappedValue.toggle()
        }
    }
    
}
