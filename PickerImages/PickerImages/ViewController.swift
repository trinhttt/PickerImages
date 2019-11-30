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
    
    // MARK: - IBOutlet
    @IBOutlet weak var ibCollectionView: UICollectionView!
    @IBOutlet weak var ibSelectInfoText: UILabel!
    
    // MARK: - Properties
    var imageAssets: [PHAsset] = [PHAsset]()
    var selectedImageAssets: [PHAsset] = [PHAsset]()
    var checkedImageIndexs: [Int] = [Int]()
    var removedImageIndex: Int = -1
    var isShowSelectedList: Bool = false
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCollectionItems(space: 1.5, numberOfItem: 3)
        fetchImagesFromLibrary()
    }
    
    // MARK: - Functions
    private func setupNavigation() {
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
        
        // Right bar button
        let logoutBarButtonItem = UIBarButtonItem(title: "Selected list", style: .done, target: self, action: #selector(selectedListTapped))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }
    
    private func setupCollectionItems(space: CGFloat, numberOfItem: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        let size = (screenWidth - space * (numberOfItem + 1)) / numberOfItem
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        ibCollectionView.collectionViewLayout = layout
    }
    
    private func fetchImagesFromLibrary() {
        // Ask for permissions
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.getAllImages { [weak self] isExist in
                    guard let weakSelf = self else { return }
                    DispatchQueue.main.async {
                        weakSelf.ibCollectionView.delegate = self
                        weakSelf.ibCollectionView.dataSource = self
                        weakSelf.ibCollectionView.reloadData()
                    }
                }
            case .denied, .restricted:
                break
            case .notDetermined:
                break
            default:
                break
            }
        }
    }
    
    private func getAllImages(completion: (_ isExist: Bool) -> Void) {
        let assets : PHFetchResult = PHAsset.fetchAssets(with: .image, options: self.assetsfetchOptions())
        let indexSet = IndexSet(integersIn: 0..<assets.count)
        self.imageAssets = assets.objects(at: indexSet)
        (imageAssets.count > 0) ? completion(true) : completion(false)
    }
    
    private func assetsfetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    private func updateSelectInfoText() {
        if checkedImageIndexs.count != 0 {
            ibSelectInfoText.text = "Selected photo: \(checkedImageIndexs.count)"
        } else {
            ibSelectInfoText.text = "Please select photo"
        }
    }
    
    private func updateCell(at index: Int) {
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
    
    @objc func selectedListTapped() {
        isShowSelectedList = !isShowSelectedList
        selectedImageAssets.removeAll()
        for i in checkedImageIndexs {
            selectedImageAssets.append(imageAssets[i])
        }
        
        //        for i in 0..<imageAssets.count {
        //            if checkedImageIndexs.contains(i) {
        //                selectedImageAssets.append(imageAssets[i])
        //            }
        //        }
        
        //        imageAssets = imageAssets.filter({(asset: PHAsset) -> Bool in
        //            if let index = imageAssets.index(of: asset) {
        //                return checkedImageIndexs.contains(index)
        //            }
        //            return false
        //        })
        ibCollectionView.reloadData()
    }
    
    
    // MARK: - IBActions
    @IBAction func ibSelectAllTapped(_ sender: Any) {
        print(checkedImageIndexs)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isShowSelectedList {
            return selectedImageAssets.count
        } else {
            return imageAssets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell {
            cell.ibCheckButton.tag = indexPath.row
            if isShowSelectedList {
                cell.ibCountNumber.text = "\(indexPath.row)"
                cell.ibCountNumber.isHidden = false
                cell.ibCheckButton.backgroundColor = .red
                cell.setImage(imageAsset: selectedImageAssets[indexPath.row])
            } else {
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
                cell.checkActionHandler = { index in
                    self.updateCell(at: indexPath.row)
                    self.updateSelectInfoText()
                }
                cell.setImage(imageAsset: imageAssets[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
