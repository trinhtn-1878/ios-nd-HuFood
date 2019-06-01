//
//  WritingReviewVC.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 6/2/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class WritingReviewVC: UIViewController {
    @IBOutlet private weak var namelb: UILabel!
    @IBOutlet private weak var addresslb: UILabel!
    @IBOutlet private weak var ratelb: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var textViewHeight: NSLayoutConstraint!
    var restaurants: Restaurant?
    var username: String!
    let defaulRateValue: Float = 2.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserName()
        configView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleSendTapped))
        navigationItem.title = "Write Review"
        configSlider()
        setData()
        textView.becomeFirstResponder()
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            textViewHeight.constant = view.bounds.height - contentViewHeight.constant - keyboardHeight - 12
        }
    }
    
    @objc
    func handleSendTapped() {
        guard let id = restaurants?.id,
            let text = textView.text,
            let date = getCurrentTime() else { return }
            let rate = Double(slider.value)
        ReviewRepository.shared.pushUsersReview(restId: id,
                                                text: text,
                                                rate: rate,
                                                date: date,
                                                name: username) { (result) in
                                                switch result {
                                                case .success:
                                                    self.navigationController?.popViewController(animated: true)
                                                case .failure(error: let error):
                                                    self.showError(message: error?.errorMessage)
                                                }
        }
    }
    
    @objc
    func sliderValueChange(sender: UISlider) {
        let value = round(sender.value / 0.5) * 0.5
        slider.setValue(value, animated: true)
        ratelb.text = String(value)
    }
    
    func configSlider() {
        slider.maximumValue = 5
        slider.minimumValue = 1
        slider.tintColor = .customRedColor
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        slider.value = defaulRateValue
    }
    
    func getCurrentTime() -> String? {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        return formatter.string(from: currentDateTime)
    }
    
    func getUserName() {
        UserRepository.shared.getCurrentUserName { (result) in
            self.username = result
        }
    }
    
    func setData() {
        namelb.text = restaurants?.name
        addresslb.text = restaurants?.address?.address1
        ratelb.text = String(defaulRateValue)
    }
}

extension WritingReviewVC: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
