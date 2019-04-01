//
//  ItemCollectionViewCell.swift
//  WebServiceParsing
//
//  Created by Sanith Raj on 4/1/19.
//  Copyright © 2019 Sanith Raj. All rights reserved.
//

import UIKit
import SDWebImage

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor(red: 36/255, green: 70/255, blue: 110/255, alpha: 1).cgColor
        layer.borderWidth = 1.0
        layer.masksToBounds = true
    }

    func updateItemInfo(topic: Topics) {
        titleLbl.text = topic.title
        descLbl.text = topic.desc
        if let urlString = topic.imageURL, let url = URL(string: urlString) {
            itemImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}
