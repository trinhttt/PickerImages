//
//  ImageCollectionViewCell.swift
//  PickerImages
//
//  Created by Trinh Thai on 11/28/19.
//  Copyright © 2019 Trinh Thai. All rights reserved.
//

import UIKit
import Photos

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ibImage: UIImageView!
    @IBOutlet weak var ibCheckButton: UIButton!
    @IBOutlet weak var ibCountNumber: UILabel!
    
    var checkActionHandler: ((Int) -> Void)?
    
    func setImage(imageAsset: PHAsset) {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.isSynchronous = true
        option.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: imageAsset, targetSize: CGSize(width: ibImage.frame.size.width, height: ibImage.frame.size.height), contentMode: .aspectFill, options: option, resultHandler: { (image, info) in
            self.ibImage.image = image
        })
    }
    
    @IBAction func ibCheckTapped(_ sender: Any) {
        let index = (sender as! UIButton).tag
        checkActionHandler?(index)
    }
    
    
}
