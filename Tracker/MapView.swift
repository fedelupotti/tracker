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
    
    private func selectAnotherClient(_ client: Client) {
        clientSelected = client
    }
    
    private func startNewDeliveryFor(_ client: Client) {
        homeVM.startNewDeliveryFor(client)
    }
    
    private func imageForButton() -> String {
        switch clientSelected.status {
        case .inZone:
            return "shippingbox.fill"
        case .watingToBeSelectedForDelivering:
            return "truck.box.badge.clock.fill"
        case .selectedToDeliver:
            return "truck.box.badge.clock.fill"
        case .onGoing:
            return ""
        case .alreadyDelivered:
            return ""
        }
    }
    
    private func textForButton() -> String {
        switch clientSelected.status {
        case .inZone:
            "Deliver package"
        case .watingToBeSelectedForDelivering:
            "Start delivering for \(clientSelected.name ?? "")"
        case .selectedToDeliver:
            "Start delivering for \(clientSelected.name ?? "")"
        case .onGoing:
            "Start delivering for \(clientSelected.name ?? "")"
        case .alreadyDelivered:
            "Start delivering for \(clientSelected.name ?? "")"
        }
    }
    
    var body: some View {
        
        Map(position: $mapCamera, selection: $clientPinSelected) {
            
            ForEach(homeVM.clients) { client in
                
                Annotation(client.name ?? "", coordinate: client.coordinate) {
                    ZStack {
                        Image(systemName: "box.truck")
                            .font(.largeTitle)
                            .foregroundStyle(.blue.opacity(0.0001))
                            .onTapGesture {
                                selectAnotherClient(client)
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
            ZStack {
                Button {
                    if clientSelected.status == .watingToBeSelectedForDelivering {
                        startNewDeliveryFor(clientSelected)
                    } else if clientSelected.status == .inZone {
                        deliveredToClient()
                    }
                } label: {
                    HStack {
                        Image(systemName:  imageForButton())
                        Text(textForButton())
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                .animation(.snappy(duration: 0.3), value: textForButton())
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
