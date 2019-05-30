//
//  DetailViewController.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/30/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
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
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UITableViewCell .classForCoder(), forCellReuseIdentifier: "Celll")
            $0.sizeToFit()
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celll", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

extension DetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
