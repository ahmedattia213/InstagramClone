//
//  PhotoSelectorCell.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 8/3/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit

class PhotoSelectorCell: BaseCollectionViewCell {
    static let reuseId = "PhotoSelectorCellReuseId"
    let imageView: UIImageView = {
        let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
        imageView.clipsToBounds = true
        return imageView
    }()
    override func setupViews() {
        addSubview(imageView)
        imageView.fillSuperview()
    }
}

class PhotoSelectorHeader: BaseCollectionViewCell {
    static let reuseId = "PhotoSelectorHedaerReuseId"
    let imageView: UIImageView = {
        let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
        imageView.clipsToBounds = true
        return imageView
    }()
    override func setupViews() {
        addSubview(imageView)
        imageView.fillSuperview()
    }
}
