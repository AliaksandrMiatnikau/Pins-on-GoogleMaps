

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire

class ViewController: UIViewController {
    
    var markers = [Markers]()
    var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGMSMapView()
        getData()
    }
    
    private func setUpGMSMapView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 54, longitude: 28, zoom: 5.8)
        mapView = GMSMapView(frame: self.view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
  private  func getData() {
        AF.request("https://fish-pits.krokam.by/api/rest/points/").responseJSON { response in
            guard let result = response.data else { return }
            do {
                self.markers = try JSONDecoder().decode([Markers].self, from: result)
                DispatchQueue.main.async {
                    self.setPins(markers: self.markers)
                }
            } catch  {
                print(error.localizedDescription)
            }
        }
    }

    
    private func setPins(markers: [Markers]) {
        for pin in markers {
            let position = CLLocationCoordinate2D(latitude: pin.point.lat, longitude: pin.point.lng)
            let text = pin.point_name.dropFirst(3)
            let pointId = pin.point.id
            let pin = GMSMarker(position: position)
            pin.icon = GMSMarker.markerImage(with: .systemBlue)
            pin.title = "Водный поинт №\(pointId)"
            pin.snippet = "\(text.dropLast(4))"
            pin.map = self.mapView
        }
    }
}




