//
//  RegisterViewController.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/24/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import Firebase

final class RegisterViewController: UIViewController {
    @IBOutlet private weak var btnRegister: UIButton!
    @IBOutlet private weak var txtConfirmation: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtName: UITextField!
    @IBOutlet private weak var errorShow: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    deinit {
        logDeinit()
    }
    
    func configView() {
        title = "Register"
    }
    
    @IBAction private func handleRegisterTapped(_ sender: Any) {
        guard let userName = txtName.text,
            let email = txtEmail.text,
            let password = txtPassword.text,
            let confirmPassword = txtConfirmation.text else {
            print("invalid")
            return
        }
        guard confirmPassword == password else {
            showError(message: BaseError.confirmPasswordInvalid.errorMessage)
            return
        }
        UserRepository.shared.register(email: email, password: password, name: userName) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction private func handleGoToSignInTapped(_ sender: Any) {
         navigationController?.popViewController(animated: true)

    }
}

extension RegisterViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.loginAndRegister
}
