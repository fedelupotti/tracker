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
    
    var status: Client.Status
    
    private let animationTime: TimeInterval = 5

    let color: Gradient = Gradient(colors: [Color(red: 0.0, green: 0.5, blue: 0.0), Color(red: 0.0, green: 0.8, blue: 0.2)])
    
    private func progressBarStatus() -> CGFloat {
        switch status {
        case .onGoing:
            return 0
        case .inZone:
            return 125
        case .alreadyDelivered:
            return 250
        case .toDeliver:
            return 0
        }
    }
 
    var body: some View {
        VStack(alignment: .leading) {
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(.systemGray6))
                    .frame(width: 250, height: 12)

                RoundedRectangle(cornerRadius: 3)
                    .fill(.indigo.gradient)
                    .fill(color)
                    
                    .frame(width: progressBarStatus(), alignment: .leading)
                    .animation(.easeInOut(duration: animationTime), value: status)
            }
            .frame(width: 250, height: 12)
            .overlay {
                ZStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .font( status == .onGoing ? .title : .callout)
                            .foregroundStyle(.white, status == .onGoing ? .green : .black)
                            .animation(.bouncy.delay(animationTime), value: status)
                            
                        Spacer()
                        VStack {
                            Image(systemName: "checkmark.seal.fill")
                                .font( status == .inZone ? .title : .callout)
                                .foregroundStyle(.white, status == .inZone ? .green : .black)
                                .animation(.bouncy.delay(animationTime), value: status)
                                
                        }
                        Spacer()
                        Image(systemName: "checkmark.seal.fill")
                            .font( status == .alreadyDelivered ? .title : .callout)
                            .foregroundStyle(.white, status == .alreadyDelivered ? .green : .black)
                            .animation(.bouncy.delay(animationTime), value: status)
                    }
                    
                    
                }
                .frame(width: 260)
            }
            
        }
    }
}
#Preview {
    ProgressAnimation(status: .toDeliver)
}
