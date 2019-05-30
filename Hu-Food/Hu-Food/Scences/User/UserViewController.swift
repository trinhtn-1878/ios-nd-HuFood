//
//  UserViewController.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/24/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import UIKit
import Firebase

final class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    deinit {
        logDeinit()
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Username: "
        } else {
            cell.textLabel?.text = "Sign out"
            cell.textLabel?.textColor = .red
            cell.textLabel?.textAlignment = .center
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            do {
                try Auth.auth().signOut()
                let LoginVc = LoginViewController.instantiate()
                self.navigationController?.viewControllers = [LoginVc]
            } catch {
                print(error)
            }
        }
        
    }
}

extension UserViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
    
}
