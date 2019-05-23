//
//  Storyboards.swift
//  Hu-Food
//
//  Created by nguyen.the.trinh on 5/23/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//
extension UIViewController {
    func logDeinit() {
        print(String(describing: type(of: self)) + " deinit")
    }
}
