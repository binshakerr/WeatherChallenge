//
//  SearchViewController.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import UIKit
import Combine

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
    
    private var viewModel: SearchViewModel!
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
    
    convenience init(viewModel: SearchViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    func setupUI(){
        navigationItem.title = viewModel.screenTitle
        view.addSubview(loadingIndicator)
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
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    
    @IBAction func goButtonPressed(_ sender: Any) {
        
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
