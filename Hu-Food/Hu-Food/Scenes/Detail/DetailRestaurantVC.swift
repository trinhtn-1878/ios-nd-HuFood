//
//  DetailRestaurantVC.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/31/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class DetailRestaurantVC: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var inforRestaurantView: InforRestaurantView!
    private let repoRestDetail = FoodRepository(api: APIService.share)
    private let refreshControl = UIRefreshControl()
    var activityIndicatorView: UIActivityIndicatorView!
    var reviews: [Reviews] = []
    var reviewTotal: [Reviews] = []
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        fetchDataReview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    deinit {
        logDeinit()
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: ReviewCell.self)
            $0.refreshControl = refreshControl
            $0.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        tableView.tableFooterView = activityIndicatorView
        activityIndicatorView.startAnimating()
        guard let nav = navigationController else { return }
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.barTintColor = .customRedColor
        nav.navigationBar.tintColor = .white
        navigationItem.title = restaurant.name
        nav.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc
    func refreshData(sender: Any) {
        fetchDataReview()
        refreshControl.endRefreshing()
    }
    
    func fetchDataReview() {
        repoRestDetail.fetchReviews(id: restaurant.id) { (result) in
            switch result {
            case .success(let response):
                guard let data = response?.reviews else { return }
                if data.isEmpty { return }
                self.reviews = data
                self.loadReviewFirebase()
            case.failure(error: let error):
                self.showError(message: error?.errorMessage)
            }
        }
    }
    
    func loadReviewFirebase() {
        ReviewRepository.shared.getUserReview(restId: restaurant.id, limit: UInt(5 + reviewTotal.count)) { result in
            if result.count == self.reviewTotal.count - self.reviews.count { return }
            self.reviewTotal = self.reviews + result
            self.tableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    func setupData() {
        imageView.kf.setImage(with: URL(string: restaurant.imageUrl),
                              placeholder: UIImage(named: "imagePlaceHolder"))
        inforRestaurantView.setRestaurant(rest: restaurant)
    }
    
    @IBAction private func handleMapTapped(_ sender: Any) {
        let mapVC = MapViewController.instantiate()
        mapVC.restaurants = restaurant
        navigationController?.pushViewController(mapVC, animated: true)
    }

    @IBAction private func handleWriteReviewTapped(_ sender: Any) {
        let reviewVC = WritingReviewVC.instantiate()
        reviewVC.restaurants = restaurant
        navigationController?.pushViewController(reviewVC, animated: true)
    }
}

extension DetailRestaurantVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewTotal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReviewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setData(reviews: reviewTotal[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == reviewTotal.count - 1 {
            loadReviewFirebase()
        }
    }
}

extension DetailRestaurantVC: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
