
//  rowview.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2022/4/3.



import SwiftUI


struct Rowview: View {

    
    var diaryDate :Date
    var mood_index: Double
    let mydate:Date
    
    
    var body: some View {
        
//        ZStack{
//            RoundedRectangle(cornerRadius: 10)
//            //                .stroke(Color.black,lineWidth:1)
//                .fill(Color(UIColor.systemBackground))
//                .frame(width: 325)
//            //                .frame(maxWidth: .infinity,maxHeight: .infinity)
//                .shadow(color: .gray, radius: 5, x: 1, y: 1)
            
            
            HStack{
                VStack(alignment: .leading,spacing: 10){
                    
                    
                    
                    
                    Text(getDiaryTime(date:diaryDate))
                        .font(.callout)
                        .foregroundColor(Color("myblack"))
                        .fontWeight(.bold)
                        .italic()
                    
                    Static_BatteryView(mood_index: mood_index)
                            .frame(width: 70)

                    
                }
                
                
                Spacer()
                
                Text(calcTimeSince(date:mydate))
                    .foregroundColor(Color("myblack"))
                //                        .font(.caption)
                    .italic()
                    .padding(.top,-8)
                
                
                
            }//hstack
            .padding()
//            .onAppear{
//                if let diary = self.diary{
//                    diaryDate = diary.diaryDate
//                    mood_index = diary.mood_index
//                }
//            }


        
            
        
    }}
struct Static_BatteryView: View {
    var mood_index : Double
    let outline :Color = .primary
//        var fill :Color = .green
    var fill : Color {
        switch mood_index {
        case 0...2:
            return .red
        case 2...5:
            return .yellow
        default:
            return .green
        }}
    
    
    @State var opacity:Double = 0.0
    

    var body: some View {
        
        ZStack{
            Image(systemName:"battery.0")
                .resizable()
                .scaledToFit()
                .font(.headline.weight(.ultraLight))
                .foregroundColor(outline)
                .background(
                Rectangle()
                    .fill(fill)
                    .scaleEffect(x:mood_index/10,y:1,anchor:.leading)
                )
                .mask(
                
                    Image(systemName:"battery.100")
                        .resizable()
                        .scaledToFit()
                        .font(.headline.weight(.ultraLight))
                )
//                    .frame(width: 70)
//                    .padding()
            Text("\(Int(self.mood_index*10))%")
                .foregroundColor(.secondary)
                .animation(nil)
                .opacity(self.opacity)
        }
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                withAnimation{self.opacity = 1}
            }
        }
        
    }
    
    
}
    struct BatteryView: View {
        @Binding var mood_index : Double
        let outline :Color = .primary
//        var fill :Color = .green
        var fill : Color {
            switch mood_index {
            case 0...2:
                return .red
            case 2...5:
                return .yellow
            default:
                return .green
            }}
        

        
        @State var opacity:Double = 0.0
        
  
        var body: some View {
            
//            let gradient = Gradient(colors: [
//                Color.red.opacity(1.0 - mood_index/10),
//                Color.green.opacity(mood_index/10)
//            ])
            
            ZStack{
                Image(systemName:"battery.0")
                    .resizable()
                    .scaledToFit()
                    .font(.headline.weight(.ultraLight))
                    .foregroundColor(outline)
                    .background(
                    Rectangle()
                        .fill(fill)
//                        .fill(LinearGradient(gradient: gradient, startPoint:.leading, endPoint: .trailing))
                        .scaleEffect(x: mood_index/10,y:1,anchor:.leading)
                    )
                    .mask(

                        Image(systemName:"battery.100")
                            .resizable()
                            .scaledToFit()
                            .font(.headline.weight(.ultraLight))
                    )
//                    .frame(width: 70)
//                    .padding()
                Text("\(Int(self.mood_index * 10))%")
                    .foregroundColor(.secondary)
                    .animation(nil)
                    .opacity(self.opacity)
            }
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                    withAnimation{self.opacity = 1}
                }
            }
            
        }
        
        
    }
    
    struct Rowview_Previews: PreviewProvider {
        static var previews: some View {
            List{ Rowview(diaryDate :Date(), mood_index:5, mydate:Date())
                .previewLayout(.device)}

            }

    }

