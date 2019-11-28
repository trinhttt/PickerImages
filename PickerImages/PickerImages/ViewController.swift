//
//  ViewController.swift
//  PickerImages
//
//  Created by Trinh Thai on 11/28/19.
//  Copyright © 2019 Trinh Thai. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var ibCollectionView: UICollectionView!
    @IBOutlet weak var ibSelectInfoText: UILabel!
    
    fileprivate var imageAssets = [PHAsset]()
    var checkIndexArray: [Int] = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavi()
        setupForCollectionItems(space: 1.5, numberOfItem: 3)
        fetchImagesFromDeviceLibrary()
    }

    func fetchImagesFromDeviceLibrary(){
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("Good to proceed")
                let imageAsset = PHAsset.fetchAssets(with: .image, options: nil)
                for index in 0..<imageAsset.count{
                    self.imageAssets.append((imageAsset[index]))
                }
                
                DispatchQueue.main.async {
                    self.ibCollectionView.delegate = self
                    self.ibCollectionView.dataSource = self
                    self.ibCollectionView.reloadData()
                }
            case .denied, .restricted:
                print("Not allowed")
            default://case .notDetermined:
                print("Not determined yet")
            
            }
        }
    }
    
    func setupForCollectionItems(space: CGFloat, numberOfItem: CGFloat){
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        let size = (screenWidth - space * (numberOfItem + 1)) / numberOfItem
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        ibCollectionView.collectionViewLayout = layout
    }
    
    func selectItem(at index: Int){
        if checkIndexArray.contains(index){
            for i in 0..<checkIndexArray.count{
                if checkIndexArray[i] == index{
                    checkIndexArray.remove(at: i)
                    break
                }
            }
        }else{
            checkIndexArray.append(index)
        }
        if checkIndexArray.count != 0 {
            ibSelectInfoText.text = "Selected photo: \(checkIndexArray.count)"
        } else {
            ibSelectInfoText.text = "Please select photo"
        }
        ibCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    private func initNavi() {
        if let naviController = navigationController {
            let naviBar = naviController.navigationBar
            naviBar.isTranslucent = false
            naviBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            naviBar.tintColor = .white
            naviBar.barTintColor = #colorLiteral(red: 0.8458752036, green: 0.0433992222, blue: 0.1414211988, alpha: 1)
            naviBar.setBackgroundImage(UIImage(), for: .default)
            naviBar.shadowImage = UIImage()
            
            //set title
            naviBar.topItem?.title = " Title"
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell {
            if checkIndexArray.contains(indexPath.row){
                cell.ibCheckButton.backgroundColor = .red
            }else{
                cell.ibCheckButton.backgroundColor = .clear
            }
            let option = PHImageRequestOptions()
            option.isNetworkAccessAllowed = true
            option.isSynchronous = true
            option.deliveryMode = .highQualityFormat
            PHImageManager.default().requestImage(for: imageAssets[indexPath.row], targetSize: CGSize(width :cell.ibImage.frame.size.width, height : cell.ibImage.frame.size.height), contentMode: .aspectFill, options: option, resultHandler: { (image, info) in
                cell.ibImage.image = image
            })
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItem(at: indexPath.row)
    }
}
