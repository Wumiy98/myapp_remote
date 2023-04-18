
//  TabBar.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2023/4/5.




import SwiftUI

struct TabBar: View {

    @Binding var currentSelected: Tab
//    @State var currentSelected: Tab = .home
    @Namespace var animationNamespace
    @State private var showingAddView = false
    var body: some View {



        
            HStack{

                tabButton(slectedButton: .home)
                    .padding(.leading,30)
                 Spacer()
                tabButton(slectedButton: .diary)
                    .padding(.trailing,30)

            

             }
             .padding()
             .background(Color(UIColor.systemBackground))//
             .cornerRadius(10)
             .background(RoundedRectangle(cornerRadius: 10))
             .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 4)
             .overlay{
                 Image(systemName: "plus")
                     .font(.system(size: 50))
                     .foregroundColor(.white)
                     .padding()
                     .background(Color.red)
                    .clipShape(Circle())
                    .offset(y:-20)
                    .onTapGesture{
                        showingAddView = true
                    }
             }
             .sheet(isPresented:$showingAddView){
                 NavigationView{
                     AddDiaryView(isedited: false)}}
//                     .padding()}



     }



}//End Viw

extension TabBar{
    
    func tabButton(slectedButton: Tab) -> some View{
        Button{
            withAnimation(.spring(response: 0.3,dampingFraction: 0.7)) {currentSelected = slectedButton}
        } label:{
            VStack{
                Image(systemName: slectedButton.icon)
                    .font(.system(size: 18))
                    .frame(height: 20)
                Text(slectedButton.text)
//                    .font(.system(size: 15))
                    .font(.caption)
//                    .font(.body.bold())
                    
            }
            .foregroundColor(currentSelected == slectedButton ? Color(UIColor.systemBackground) : .secondary)
            .background(
                ZStack{
                    if currentSelected == slectedButton {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("myblack").opacity(1))
                        .frame(width:70,height: 60)
                        .matchedGeometryEffect(id: "background_rectangle", in: animationNamespace)
                    }
                }
            )


        }
        
    }
    
}

enum Tab: CaseIterable{
    case home
    case diary

    var text:String{
        switch self{
        case .home:
            return "Home"

        case .diary:
            return "Diary"

        }
    }

    var icon:String{
        switch self{
        case .home:
            return "house"
        case .diary:
            return "book"
        }
    }
}








