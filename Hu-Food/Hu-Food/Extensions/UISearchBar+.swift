//
//  UISearchBar+.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/24/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter {$0 is T }).first as? T else { return nil }
        return element
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            
            @unknown default:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
            }
        }
    }
}
