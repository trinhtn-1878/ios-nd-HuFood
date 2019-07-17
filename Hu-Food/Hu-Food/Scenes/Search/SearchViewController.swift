//
//  SearchViewController.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/26/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class SearchViewController: UIViewController {
    @IBOutlet private weak var searchbar: UISearchBar!
    @IBOutlet private weak var btnback: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    private let repoRestSearch = FoodRepository(api: APIService.share)
    private let refreshControl = UIRefreshControl()
    var activityIndicatorView: UIActivityIndicatorView!
    var restaurants: [Restaurant] = []
    var location: [String: String] = ["latitude": "", "longitude": ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        fetchData(term: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(repoRestSearch)
    }
    
    deinit {
        logDeinit()
    }
    
    func configView() {
        searchbar.do {
            $0.backgroundImage = UIImage()
            $0.delegate = self
            $0.becomeFirstResponder()
        }
       
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: SearchResultCell.self)
            $0.refreshControl = refreshControl
            $0.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        tableView.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
    }
    
    @objc
    func refreshData(sender: Any) {
        fetchData(term: "")
        refreshControl.endRefreshing()
    }
    
    func fetchData(term: String) {
        guard let longitude = location["longitude"], let latitude = location["latitude"] else {
            return
        }
        repoRestSearch.fetchNearFood(longitude: longitude,
                                     latitude: latitude,
                                     offset: restaurants.count,
                                     term: term) { (result) in
                                        switch result {
                                        case .success(let response):
                                            guard let data = response?.restaurants else { return }
                                            if data.isEmpty { return }
                                            self.restaurants += data
                                            self.tableView .reloadData()
                                            self.activityIndicatorView.stopAnimating()
                                        case .failure(error: let error):
                                            self.showError(message: error?.errorMessage)
                                        }
        }
    }
    
    @IBAction private func touchBack(_ sender: Any) {
        let mainVC = MainViewController.instantiate()
        navigationController?.viewControllers = [mainVC]
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        restaurants.removeAll()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
        
    }
    
    @objc
    func reload() {
        let text = searchbar.text ?? ""
        fetchData(term: text)
        if restaurants.isEmpty {
            tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailRestaurantVC.instantiate()
        if restaurants.isEmpty == false {
            detailVC.restaurant = restaurants[indexPath.row]
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultCell = tableView.dequeueReusableCell(for: indexPath)
        if restaurants.isEmpty == false {
            cell.setRestDetail(rest: restaurants[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == restaurants.count - 1 {
            let text = searchbar.text ?? ""
            fetchData(term: text)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
