//
//  UserViewController.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/24/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class UserViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    deinit {
        logDeinit()
    }
    
    func configView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
        }
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        switch indexPath.row {
        case 0:
            UserRepository.shared.getCurrentUserName { (name) in
                cell.textLabel?.text = "Username: " + name
            }
        default:
            cell.textLabel?.text = "Sign out"
            cell.textLabel?.textColor = .red
            cell.textLabel?.textAlignment = .center
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            UserRepository.shared.signOut(completion: {
                let loginVC = LoginViewController.instantiate()
                self.navigationController?.viewControllers = [loginVC]
            })
        }
    }
}

extension UserViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
