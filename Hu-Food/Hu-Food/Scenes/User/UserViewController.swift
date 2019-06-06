//
//  UserViewController.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/24/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class UserViewController: UIViewController {
    @IBOutlet private weak var userNamelb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    deinit {
        logDeinit()
    }
    
    func configView() {
        setName()
        guard let nav = navigationController else { return }
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.barTintColor = .customRedColor
        nav.navigationBar.tintColor = .white
        navigationItem.title = "User"
        nav.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func setName() {
        UserRepository.shared.getCurrentUserName { (name) in
            self.userNamelb.text = name
        }
    }
    
    @IBAction private func handleSignoutTapped(_ sender: Any) {
        let loginVC = LoginViewController.instantiate()
        navigationController?.viewControllers = [loginVC]
    }
}

extension UserViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
