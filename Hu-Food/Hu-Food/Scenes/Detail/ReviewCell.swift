//
//  ReviewCell.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/31/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class ReviewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var review: UILabel!
    @IBOutlet private weak var holderContentView: UIView!
    @IBOutlet private weak var contentViewHeight: NSLayoutConstraint!
    
    func setData(reviews: Reviews) {
        imgView.kf.setImage(with: URL(string: reviews.user.imageUrl),
                            placeholder: UIImage(named: "imagePlaceHolder"))
        name.text = reviews.user.name
        rating.text = String(reviews.rating)
        date.text = reviews.timeCreated
        review.text = reviews.text
    }
}
