//
//  MapView.swift
//  Tracker
//
//  Created by Federico Lupotti on 25/10/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject private var homeVM: HomeViewModel
    
    @State var client = Client(name: "", packages: nil, location: nil)
    
    @State var mapCamera: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State var circularStroke: StrokeStyle = StrokeStyle(lineWidth: 0.8, lineCap: .round, lineJoin: .round, dash: [10, 10])
    
    private func userMapCamera() {
        mapCamera = .region(MKCoordinateRegion(center: client.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        
        
        
    
    }
    
    var body: some View {
        
        Map(position: $mapCamera) {
            
            ForEach(homeVM.clients) { client in
                Marker(client.name ?? "", systemImage: "box.truck", coordinate: client.coordinate)
                MapCircle(center: client.coordinate, radius: CLLocationDistance(integerLiteral: 100))
                    .foregroundStyle(client.isOnGoing ? .blue.opacity(0.5) : .gray.opacity(0.5))
                    .stroke(Color(.black).opacity(0.2), style: circularStroke)
                    
                
                    
                
                
            }
            
            UserAnnotation()
            
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        
//        .onAppear(perform: {
//            userMapCamera()
//        })
    }
}


//struct Container: View {
//    @State var client = Truck.mock.first?.clients?.first!
//    var body: some View {
//        MapView(client: client!)
//    }
//}
//
//
//#Preview {
//    Container()
//}
