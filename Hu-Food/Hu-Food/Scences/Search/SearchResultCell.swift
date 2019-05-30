//
//  SearchResultCell.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/26/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

import UIKit
import Kingfisher

final class SearchResultCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var categoryFood: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setRestDetail(rest: RestSearchDetail) {
        imgView.kf.setImage(with: URL(string: rest.imageUrl))
        name.text = rest.name
        distance.text = String(format: "%.1f km", rest.distance * 0.01)
        address.text = rest.address?.address1
        rating.text = String(rest.rating)
        guard let category = rest.categoryFood?[0] else {
            return
        }
            categoryFood.text = category.title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
