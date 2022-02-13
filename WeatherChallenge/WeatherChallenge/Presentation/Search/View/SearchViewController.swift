//
//  SearchViewController.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import UIKit
import Combine
import CoreLocation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.placeholder = viewModel.searchBarPlaceHolder
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: viewModel.searchCellIdentifier)
        }
    }
    @IBOutlet weak var goButton: UIButton!{
        didSet {
            goButton.roundCorners(.allCorners, radius: 10)
        }
    }
    
    private let viewModel: SearchViewModel
    private var cancellables = Set<AnyCancellable>()
    private lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = viewModel.noResultsText
        label.textAlignment = .center
        return label
    }()
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor(appColor: .red)
        indicator.center = view.center
        return indicator
    }()
    var searchWorkItem: DispatchWorkItem?
    let manager = CLLocationManager()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func setupUI(){
        navigationItem.title = viewModel.screenTitle
        view.addSubview(loadingIndicator)
        hideBackButtonTitle()
    }
    
    func bindViewModel() {
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
        
        viewModel.$cities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cities in
                guard let self = self, let cities = cities else { return }
                if cities.count == 0 {
                    self.tableView.backgroundView = self.noResultsLabel
                    self.tableView.separatorStyle = .none
                } else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = .singleLine
                }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$selectedRow
            .receive(on: DispatchQueue.main)
            .sink { [weak self] row in
                guard let self = self else { return }
                self.changeButtonAvailability(self.goButton, enabled: row != nil)
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$geocodedAddress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] string in
                guard let self = self, let address = string else { return }
                self.searchBar.text = address
                self.viewModel.searchCities(name: address)
            }
            .store(in: &cancellables)
    }
    
    func openDetailsScreen(name: String){
        let logger = Logger()
        let networkHandler = NetworkHandler(apiHandler: APIHanndler(logger: logger), logger: logger, parser: Parser())
        let repository = SearchRepository(networkHandler: networkHandler)
        let viewModel = WeatherDetailsViewModel(cityName: name, repository: repository)
        let controller = WeatherDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func changeButtonAvailability(_ button: UIButton, enabled: Bool){
        button.isUserInteractionEnabled = enabled
        button.backgroundColor = enabled ? UIColor(appColor: .red) : .gray
    }
    
    func setupLocationManager(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        openDetailsScreen(name: viewModel.selectedCityName ?? "")
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
        setupLocationManager()
    }

}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.searchCellIdentifier, for: indexPath)
        guard let city = viewModel.cityAt(indexPath.row) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = city.name
        cell.accessoryType = (indexPath.row == viewModel.selectedRow) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectedRow = indexPath.row
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchString = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), searchString.count >= 2 else {
            return
        }
        viewModel.searchCities(name: searchString)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchString = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), searchString.count >= 2 else {
            return
        }
        // Cancel any outstanding search
        searchWorkItem?.cancel()
        
        // Set up a DispatchWorkItem to perform the search
        searchWorkItem = DispatchWorkItem { [weak self] in
            self?.viewModel.searchCities(name: searchString)
        }
        
        // Run this block after 300 milliseconds (standard for search)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: searchWorkItem!)
    }
    
}


extension SearchViewController: CLLocationManagerDelegate {
    
    ///to get most recent location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let location = locations.last else { return }
        viewModel.reverseGeocodeLocation(location)
    }
    
    ///request location first time after authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    ///to hanlde cases of denied access
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        switch (error as NSError).code {
        case 1: //denied
            showDeniedLocationAlert()
        default:
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    ///shown when user has denied access to open app settings
    func showDeniedLocationAlert(){
        let alert = UIAlertController(title: "Error", message: "You have denied access to location before, to enable it again you have to change it from app settings.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
