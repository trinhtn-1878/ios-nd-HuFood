//
//  LoginViewController.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/24/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class LoginViewController: UIViewController {
    @IBOutlet private weak var errorShow: UILabel!
    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var btnSignIn: UIButton!
    
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        hideKeyboardWhenTappedAround() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    deinit {
        logDeinit()
    }
    
    func configView() {
        title = "Login"
        setup()
    }
    
    func setup() {
        btnSignIn.rx.tap.subscribe(onNext: { [unowned self] in
            guard let email = self.txtEmail.text, let pass = self.txtPassword.text else {
                    return
                }
                UserRepository.shared.signIn(email: email, password: pass) { (_) in
                    let mainVC = MainViewController.instantiate()
                    self.navigationController?.viewControllers = [mainVC]
                }
        })
        .disposed(by: disposebag)
    }
    
//    @IBAction private func handleSignInTapped(_ sender: Any) {
//        guard let email = txtEmail.text, let pass = txtPassword.text else {
//            return
//        }
//        UserRepository.shared.signIn(email: email, password: pass) { (_) in
//            let mainVC = MainViewController.instantiate()
//            self.navigationController?.viewControllers = [mainVC]
//        }
//    }
    
    @IBAction private func handleCreateAccountTapped(_ sender: Any) {
        let registerVC = RegisterViewController.instantiate()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

extension LoginViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.loginAndRegister
}
