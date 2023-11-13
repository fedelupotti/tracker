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
    
    @State var clientSelected = Client(name: "", packages: nil, location: nil)
    
    @State var mapCamera: MapCameraPosition = .region(MKCoordinateRegion())
    
    @State var circularStroke: StrokeStyle = StrokeStyle(lineWidth: 0.8, lineCap: .round, lineJoin: .round, dash: [10, 10])
    
    @State var clientPinSelected: MKMapView?
    
    @Environment(\.dismiss) var dismiss
    
    let onCommitClient: (_ delivered: Client) -> Void
    
    private func userMapCamera() {
        mapCamera = .region(MKCoordinateRegion(center: clientSelected.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
    }
    
    private func circleColorFor(_ client: Client) -> some ShapeStyle {
        if client.isInGeofence { 
            return .green.opacity(0.5)
        } else if clientSelected.id == client.id {
            return .blue.opacity(0.5)
        } else {
            return .gray.opacity(0.5)
        }
    }
    
    private func deliveredToClient() {
        onCommitClient(clientSelected)
        dismiss.callAsFunction()
    }
    
    var body: some View {
        
        Map(position: $mapCamera, selection: $clientPinSelected) {
            
            ForEach(homeVM.clients) { client in
                
                Annotation(client.name ?? "", coordinate: client.coordinate) {
                    ZStack {
                        Image(systemName: "box.truck")
                            .onTapGesture {
                                print("tapped!")
                            }
                    }
                }
                
                Marker(client.name ?? "", systemImage: "box.truck", coordinate: client.coordinate)
                MapCircle(center: client.coordinate, radius: CLLocationDistance(integerLiteral: 100))
                    .foregroundStyle(circleColorFor(client))
                    .stroke(Color(.black).opacity(0.2), style: circularStroke)
            }
            

            UserAnnotation()
            
        }
        .safeAreaInset(edge: .bottom, content: {
            if clientSelected.isInGeofence {
                ZStack {
                    Button {
                        deliveredToClient()
                    } label: {
                        HStack {
                            Image(systemName: "shippingbox.fill")
                            Text("Deliver package")
                        }
                        
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
        })
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        
        .onAppear(perform: {
            userMapCamera()
        })
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
