//
//  DetailViewController.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/30/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    deinit {
        logDeinit()
    }
    
    func configView() {
        
    }
}

extension DetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
