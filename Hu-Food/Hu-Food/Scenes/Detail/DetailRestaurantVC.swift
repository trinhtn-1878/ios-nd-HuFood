//
//  DetailRestaurantVC.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/31/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class DetailRestaurantVC: UIViewController {
    @IBOutlet private weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var inforRestaurantView: InforRestaurantView!
    private let repoRestDetail = FoodRepository(api: APIService.share)
    var reviews: [Reviews] = []
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        fetchDataReview()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
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
            $0.isScrollEnabled = false
            $0.register(cellType: ReviewCell.self)
        }
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .customRedColor
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = restaurant.name
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func updateHeight() {
        tableView.updateConstraints()
        tableView.layoutIfNeeded()
        tableViewHeight.constant = tableView.contentSize.height
        contentViewHeight.constant = inforRestaurantView.bounds.height
            + tableViewHeight.constant + imageView.bounds.height
    }
    
    func fetchDataReview() {
        repoRestDetail.fetchReviews(id: restaurant.id) { (result) in
            switch result {
            case .success(let response):
                guard let data = response?.reviews else { return }
                if data.isEmpty { return }
                self.reviews = data
                self.tableView.reloadData()
                self.updateHeight()
            case.failure(error: let error):
                self.showError(message: error?.errorMessage)
            }
        }
    }
    
    func setupData() {
        imageView.kf.setImage(with: URL(string: restaurant.imageUrl),
                              placeholder: UIImage(named: "imagePlaceHolder"))
        inforRestaurantView.setRestaurant(rest: restaurant)
    }
}

extension DetailRestaurantVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReviewCell = tableView.dequeueReusableCell(for: indexPath)
        cell .setData(reviews: reviews[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

extension DetailRestaurantVC: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
