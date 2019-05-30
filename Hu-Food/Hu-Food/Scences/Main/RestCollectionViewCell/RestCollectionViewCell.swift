//
//  RestCollectionViewCell.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/24/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import UIKit
import Kingfisher

final class RestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var delivery: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        delivery.layer.cornerRadius = 5
        delivery.clipsToBounds = true
    }
    func setRestDetail(rest: RestSearchDetail) {
        imageView.kf.setImage(with: URL(string: rest.imageUrl))
        name.text = rest.name
        distance.text = String(format: "%.1f km", rest.distance * 0.01)
        delivery.text = rest.categoryFood?[0].title
    }
}
