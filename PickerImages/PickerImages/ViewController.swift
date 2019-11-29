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
    var checkedImageIndexs: [Int] = [Int]()
    var removedImageIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupForCollectionItems(space: 1.5, numberOfItem: 3)
        fetchImagesFromDeviceLibrary()
    }

    fileprivate func fetchImagesFromDeviceLibrary() {
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
    
    fileprivate func setupForCollectionItems(space: CGFloat, numberOfItem: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        let size = (screenWidth - space * (numberOfItem + 1)) / numberOfItem
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        ibCollectionView.collectionViewLayout = layout
    }
    
    fileprivate func updateCell(at index: Int) {
        if let removeIndex = checkedImageIndexs.index(of: index) {
            removedImageIndex = removeIndex
            for i in removedImageIndex + 1..<checkedImageIndexs.count {
                removedImageIndex += 1
                ibCollectionView.reloadItems(at: [IndexPath(row: checkedImageIndexs[i], section: 0)])
            }
            checkedImageIndexs.remove(at: removeIndex)
            removedImageIndex = -1
        }else{
            checkedImageIndexs.append(index)
        }
        ibCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    fileprivate func updateSelectInfoText() {
        if checkedImageIndexs.count != 0 {
            ibSelectInfoText.text = "Selected photo: \(checkedImageIndexs.count)"
        } else {
            ibSelectInfoText.text = "Please select photo"
        }
    }
    
    fileprivate func setupNavi() {
        if let naviController = navigationController {
            let naviBar = naviController.navigationBar
            naviBar.topItem?.title = "Title"
            naviBar.isTranslucent = false
            naviBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            naviBar.tintColor = .white
            naviBar.barTintColor = #colorLiteral(red: 0.8458752036, green: 0.0433992222, blue: 0.1414211988, alpha: 1)
            naviBar.setBackgroundImage(UIImage(), for: .default)
            naviBar.shadowImage = UIImage()
        }
    }
    
    @IBAction func ibSelectAllTapped(_ sender: Any) {
        print(checkedImageIndexs)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell {
            if checkedImageIndexs.contains(indexPath.row){
                if removedImageIndex == -1 { // append new image
                     cell.ibCountNumber.text = "\(checkedImageIndexs.count)"
                } else {
                     cell.ibCountNumber.text = "\(removedImageIndex)"
                }
                cell.ibCountNumber.isHidden = false
                cell.ibCheckButton.backgroundColor = .red
            }else{
                cell.ibCountNumber.isHidden = true
                cell.ibCheckButton.backgroundColor = .clear
            }
            cell.setImage(imageAsset: imageAssets[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateCell(at: indexPath.row)
        updateSelectInfoText()
    }
}
