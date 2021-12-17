//
//  WeatherDetailsViewController.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import UIKit
import Combine
import MapKit

class WeatherDetailsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    
    private var viewModel: WeatherDetailsViewModel!
    private var cancellables = Set<AnyCancellable>()
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor(appColor: .red)
        indicator.center = view.center
        return indicator
    }()
    
    convenience init(viewModel: WeatherDetailsViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.getCurrentWeatherDetails()
    }
    
    func setupUI(){
        navigationItem.title = viewModel.screenTitle
        view.addSubview(loadingIndicator)
    }
    
    func bindViewModel(){
        viewModel.$dataStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self, let state = state else { return }
                switch state {
                case .loading:
                    self.loadingIndicator.startAnimating()
                case .finished(let outcome):
                    self.loadingIndicator.stopAnimating()
                    switch outcome {
                    case .success:
                        break
                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }}
            .store(in: &cancellables)
        
        viewModel.$details
            .receive(on: DispatchQueue.main)
            .sink { [weak self] city in
                guard let self = self, let city = city else { return }
                self.populateWeatherInfo(city)
            }
            .store(in: &cancellables)
    }
    
    func populateWeatherInfo(_ item: DetailsItemViewModel){
        centerMapOnLocation(item.location)
        temperatureLabel.text = item.temperature
        pressureLabel.text = item.pressure
        humidityLabel.text = item.humidity
        precipitationLabel.text = item.chanceOfPrecipitation
        if let url = URL(string: item.conditionImage) {
            if let data = try? Data(contentsOf: url) {
                conditionImage.image = UIImage(data: data)
            }
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }


}
