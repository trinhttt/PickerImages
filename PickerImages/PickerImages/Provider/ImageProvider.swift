//
//  ImageProvider.swift
//  PickerImages
//
//  Created by Trinh Thai on 12/1/19.
//  Copyright © 2019 Trinh Thai. All rights reserved.
//

import Foundation
import Photos

class ImageProvider {
    class func askForPermission(completion: @escaping (_ isAllowed: Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                completion(true)
            case .denied, .restricted:
                completion(false)
            case .notDetermined:
                completion(false)
            default:
                completion(false)
            }
        }
    }
    
    class func assetsfetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    class func getAllImages(completion: (_ result: [PHAsset]?) -> Void) {
        let assets : PHFetchResult = PHAsset.fetchAssets(with: .image, options: assetsfetchOptions())
        let indexSet = IndexSet(integersIn: 0..<assets.count)
        let imageAssets = assets.objects(at: indexSet)
        (imageAssets.count > 0) ? completion(imageAssets) : completion(nil)
    }
}
