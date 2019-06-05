//
//  TextField+.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 6/5/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

extension UITextField {
   @IBInspectable var icon: UIImage? {
        get {
            return self.icon
        }
        set {
            guard let image = newValue else { return }
            leftViewMode = .always
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            leftView = imageView
        }
    }
}
