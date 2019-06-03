//
//  InforRestaurantView.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/31/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class InforRestaurantView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var address: UITextField!
    @IBOutlet private weak var phoneNumber: UITextField!
    @IBOutlet private weak var rating: UITextField!
    @IBOutlet private weak var price: UITextField!
    @IBOutlet private weak var category: UILabel!
    @IBOutlet private weak var reviewLb: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("InforRestaurantView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setRestaurant(rest: Restaurant) {
        rating.text = "Rating: " + String(rest.rating)
        phoneNumber.text = "Phone Number: " + rest.phone
        price.text = "Price: " + rest.price
        address.text = "Address: " + (rest.address?.address1 ?? "")
        category.text = rest.categoryFood.isEmpty ? "" : rest.categoryFood[0].title
    }
}

