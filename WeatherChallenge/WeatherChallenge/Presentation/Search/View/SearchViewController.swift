//
//  SearchViewController.swift
//  WeatherChallenge
//
//  Created by Eslam Shaker on 17/12/2021.
//

import UIKit

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
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var goButton: UIButton!{
        didSet {
            goButton.roundCorners(.allCorners, radius: 10)
        }
    }
    
    private var viewModel: SearchViewModelProtocol!
    
    convenience init(viewModel: SearchViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.screenTitle
    }
    
    
    
    @IBAction func goButtonPressed(_ sender: Any) {
        
    }
    

}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    
    
}
