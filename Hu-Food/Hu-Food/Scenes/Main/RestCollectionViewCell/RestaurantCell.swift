//
//  RestCollectionViewCell.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/24/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class RestaurantCell: UICollectionViewCell, NibReusable {
    @IBOutlet private weak var delivery: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var distance: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    func setRestDetail(rest: Restaurant) {
        imageView.kf.setImage(with: URL(string: rest.imageUrl), placeholder: UIImage(named: "imagePlaceHolder"))
        name.text = rest.name
        distance.text = String(format: "%.1f km", rest.distance * 0.01)
        if rest.categoryFood.isEmpty {
            delivery.text = ""
        } else {
            delivery.text = rest.categoryFood[0].title
        }
    }
}
