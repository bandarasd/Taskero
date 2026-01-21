import Foundation
import Combine
import CoreLocation

struct MapboxFeature: Codable, Identifiable {
    let id: String
    let text: String
    let place_name: String
    let center: [Double] // [long, lat]
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: center[1], longitude: center[0])
    }
}

struct MapboxGeocodingResponse: Codable {
    let features: [MapboxFeature]
}

class AddressSearchService: ObservableObject {
    @Published var query = ""
    @Published var results: [MapboxFeature] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.search(query: query)
            }
            .store(in: &cancellables)
    }
    
    func search(query: String) {
        guard !query.isEmpty else {
            results = []
            return
        }
        
        guard let token = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String else {
            print("Mapbox Access Token not found")
            return
        }
        
        let endpoint = "https://api.mapbox.com/geocoding/v5/mapbox.places/\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "").json"
        
        // Add query parameters
        var components = URLComponents(string: endpoint)
        components?.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "autocomplete", value: "true"),
            URLQueryItem(name: "limit", value: "5")
        ]
        
        guard let url = components?.url else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(MapboxGeocodingResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results = response.features
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
    
    func selectResult(_ result: MapboxFeature) {
        self.query = result.place_name
        self.results = []
    }
}
