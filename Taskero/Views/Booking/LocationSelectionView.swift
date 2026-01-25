import SwiftUI
import MapboxMaps
import CoreLocation

// ... imports


struct LocationSelectionView: View {
    let service: ServiceItem
    let totalPrice: Int
    let selectedDate: Date
    let selectedTime: String
    let serviceDetails: ServiceDetails
    
    @Environment(\.presentationMode) var presentationMode
    
    // Mapbox Viewport State
    @State private var viewport = Viewport.camera(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), zoom: 14, bearing: 0, pitch: 0)
    
    @StateObject private var searchService = AddressSearchService()
    // @State private var showConfirmationAlert = false -- Removed unused state
    @StateObject private var locationManager = LocationManager()
    
    // To track current center
    @State private var mapCenter: CLLocationCoordinate2D?
    @FocusState private var isSearchFocused: Bool
    @State private var selectedLocationAddress: String = "Louisiana, United States"
    
    var body: some View {
        ZStack {
            // Map
            Map(viewport: $viewport)
                .mapStyle(.streets)
                .ornamentOptions(OrnamentOptions(
                    scaleBar: ScaleBarViewOptions(visibility: .hidden),
                    compass: CompassViewOptions(visibility: .visible)
                ))
                .onCameraChanged { state in
                    mapCenter = state.cameraState.center
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    locationManager.requestLocation()
                }
                .onChange(of: locationManager.location) { newLocation in
                    if let location = newLocation {
                        // Only auto-center if user hasn't searched yet (optional logic, sticking to task requirement)
                        withAnimation {
                            viewport = .camera(center: location.coordinate, zoom: 15, bearing: 0, pitch: 0)
                        }
                    }
                }
                .onTapGesture {
                    isSearchFocused = false
                }
            
            // Center Pin
            Image(systemName: "mappin.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                .padding(.bottom, 40) // Adjust for visual center
            
            // Top Bar
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    Spacer()
                    
                    // Location Button
                    Button(action: {
                        locationManager.requestLocation()
                    }) {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
                .padding(.top, 50)
                .padding(.horizontal)
                
                Spacer()
                
                // Bottom Card
                VStack(spacing: 20) {
                    Text("Select Location")
                        .font(.headline)
                    
                    Text("Drag the map to pinpoint the exact location.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    // Search Field
                    VStack {
                        TextField("Search address...", text: $searchService.query)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .focused($isSearchFocused)
                            .onChange(of: searchService.query) { newValue in
                                if newValue.isEmpty {
                                    searchService.results = []
                                }
                            }
                        
                        // Autocomplete Results
                        if !searchService.results.isEmpty && isSearchFocused {
                            List(searchService.results) { result in
                                Button(action: {
                                    searchService.selectResult(result)
                                    selectedLocationAddress = result.place_name
                                    isSearchFocused = false
                                    withAnimation {
                                        viewport = .camera(center: result.coordinate, zoom: 16, bearing: 0, pitch: 0)
                                    }
                                }) {
                                    VStack(alignment: .leading) {
                                        Text(result.text)
                                            .font(.headline)
                                        Text(result.place_name)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .listStyle(.plain)
                            .frame(height: 200)
                            .cornerRadius(12)
                        }
                    }
                    
                    VStack {
                        NavigationLink(destination: PaymentMethodsView(
                            service: service,
                            totalPrice: totalPrice,
                            selectedDate: selectedDate,
                            selectedTime: selectedTime,
                            selectedLocation: selectedLocationAddress,
                            serviceDetails: serviceDetails
                        )) {
                            Text("Confirm Location")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.brandGreen)
                                .cornerRadius(24)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 30)
                .background(Color.white)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .shadow(radius: 10)
            }
        }
        .navigationBarHidden(true)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.location = location
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}


