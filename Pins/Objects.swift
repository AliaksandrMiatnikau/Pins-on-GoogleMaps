


import Foundation

struct Markers: Codable {
    let point: Point
    let point_name: String
    

    
    struct Point: Codable {
        let lat: Double
        let lng: Double
        let id: Int
    }
}
