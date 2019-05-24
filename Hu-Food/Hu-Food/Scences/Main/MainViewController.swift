//
//  MainViewController.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    private let repoRestSearch =  RepoFoodIplm(api: APIService.share)
    private var restDetail: RestDetail!
    private var reviews: [Reviews] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchDataSearch(id: String) {
        repoRestSearch.fetchInforRestaurant(id: id) { (result) in
            switch result {
            case .success(let response):
                guard let data = response else { return }
                self.restDetail = data
            case .failure(let error):
                self.showError(message: error?.errorMessage)
            }
        }
    }
    
    func fetchReviews(id: String) {
        repoRestSearch.fetchReviews(id:id ) { (result) in
            switch result {
            case .success(let response):
                guard let data = response?.reviews else { return }
                self.reviews = data
            case .failure(let error):
                self.showError(message: error?.errorMessage)
            }

        }
    }
}

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
