//
//  SearchViewController.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/26/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private let repoRestSearch = RepoFoodIplm(api: APIService.share)
    private let refreshControl = UIRefreshControl()
    var restSearchDetail: [RestSearchDetail] = []
    var location: [String: String] = ["latitude": "", "longitude": ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        fetchData(string: "")
    }
    
    deinit {
        logDeinit()
    }
    
    func configView() {
        searchbar.backgroundImage = UIImage()
        searchbar.delegate = self
        searchbar.becomeFirstResponder()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchResultCell", bundle: nil),
                           forCellReuseIdentifier: "SearchCell")
        tableView.refreshControl = refreshControl
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData(_: UIButton!) {
        fetchData(string: "")
        self.refreshControl.endRefreshing()
    }
    
    func fetchData(string: String) {
        guard let longitude = location["longitude"], let latitude = location["latitude"] else {
            return
        }
        repoRestSearch.fetchNearFood(longitude: longitude,
                                     latitude: latitude,
                                     offset: 0,
                                     term: string) { (result) in
                let data = result.restSearchDetail
                self.restSearchDetail += data
                self.tableView.reloadData()
        }
    }
    
    @IBAction func touchBack(_ sender: Any) {
        let mainVc = MainViewController.instantiate()
        self.navigationController?.viewControllers = [mainVc]
    }
    
}
extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
    
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
        restSearchDetail = []
        if let text = searchBar.text {
             fetchData(string: text)
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restSearchDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell",
                                                 for: indexPath) as! SearchResultCell
        cell.setRestDetail(rest: restSearchDetail[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
