//
//  SearchResultCell.swift
//  Hu-Food
//
//  Created by Nguyen The Trinh on 5/26/19.
//  Copyright © 2019 nguyen.the.trinh. All rights reserved.
//

final class SearchResultCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var address: UILabel!
    @IBOutlet private weak var categoryFood: UILabel!
    @IBOutlet private weak var rating: UILabel!
    @IBOutlet private weak var distance: UILabel!
    
    func setRestDetail(rest: Restaurant) {
        imgView.kf.setImage(with: URL(string: rest.imageUrl),
                            placeholder: UIImage(named: "imagePlaceHolder"))
        name.text = rest.name
        distance.text = String(format: "%.1f km", rest.distance * 0.01)
        address.text = rest.address?.address1
        rating.text = String(rest.rating)
        if rest.categoryFood.isEmpty {
            categoryFood.text = ""
        } else {
            categoryFood.text = rest.categoryFood[0].title
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
