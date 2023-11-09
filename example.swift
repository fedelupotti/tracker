//
//  example.swift
//  Tracker
//
//  Created by Federico Lupotti on 02/11/23.
//

//import SwiftUI
//
//struct example: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    example()
//}

import SwiftUI
 
struct ProgressAnimation: View {
    @State private var drawingWidth = false

    let color: Gradient = Gradient(colors: [Color(red: 0.0, green: 0.5, blue: 0.0), Color(red: 0.0, green: 0.8, blue: 0.2)])
 
    var body: some View {
        VStack(alignment: .leading) {
            Text("RAM")
                .bold()
 
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(.systemGray6))
                    .frame(width: 250, height: 12)

                RoundedRectangle(cornerRadius: 3)
                    .fill(.indigo.gradient)
                    .fill(color)
                
                    .frame(width: drawingWidth ? 125 : 0, height: 12, alignment: .leading)
                    .animation(.easeInOut(duration: 5), value: false)
//                        .repeatForever(autoreverses: false), value: drawingWidth)
            }
//            .frame(width: 250, height: 12)
            .onAppear {
                drawingWidth.toggle()
            }
            .overlay {
                ZStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            
                            .font( drawingWidth ? .callout : .title)
                            .animation(.easeInOut)
                            .foregroundStyle(.white, .green)
                            
                        Spacer()
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title2)
                            .foregroundStyle(.white, .black)
                        Spacer()
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title2)
                            .foregroundStyle(.white, .black)
                    }
                    
                    
                }
                .frame(width: 260)
            }
            
        }
    }
}
#Preview {
    ProgressAnimation()
}
