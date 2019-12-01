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
    var removedImageIndex: Int = -1
    var isShowSelectedList: Bool = false
    var checkedInfo: Dictionary<Int, Int> = [Int : Int]() // [<collectionItemIndex>:<checkedIndex>]
    
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
            // Bar button color
            naviBar.tintColor = .white
            // Navigation background color
            naviBar.barTintColor = UIColor(hexString: "D80B24")
            // Remove the navigation shadow
            naviBar.setBackgroundImage(UIImage(), for: .default)
            naviBar.shadowImage = UIImage()
        }
        
        // Right bar button
        let rightBarButtonItem = UIBarButtonItem(title: "Selected list", style: .done, target: self, action: #selector(selectedListTapped))
        self.navigationItem.rightBarButtonItem  = rightBarButtonItem
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
        ImageProvider.askForPermission { (isAllowed) in
            if isAllowed {
                ImageProvider.getAllImages(completion: { [weak self] (assets) in
                    guard let weakSelf = self else { return }
                    if let assets = assets {
                        weakSelf.imageAssets = assets
                        //init dictionary
                        for i in 0..<weakSelf.imageAssets.count {
                            weakSelf.checkedInfo[i] = -1 // Unchecked image
                        }
                        DispatchQueue.main.async {
                            weakSelf.ibCollectionView.delegate = self
                            weakSelf.ibCollectionView.dataSource = self
                            weakSelf.ibCollectionView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    private func updateSelectedInfoText() {
        let checkedCount = checkedInfo.values.max()
        if checkedCount != -1 {
            ibSelectInfoText.text = "Selected photo: \(String(describing: checkedCount ?? 0))"
        } else {
            ibSelectInfoText.text = "Please select photo"
        }
    }
    
    private func updateCheckedInfo(at index: Int) {
        if checkedInfo[index] == -1 {
            if let checkedCount = checkedInfo.values.max() {
                checkedInfo[index] = checkedCount + 1
            }
        } else {
            let needToChangeIndexs = checkedInfo.keys.filter { checkedInfo[$0] ?? -1 > checkedInfo[index] ?? -1}
            // Update larger count-numbers when unchecked an image
            for i in needToChangeIndexs {
                if let countNumber = checkedInfo[i] {
                    checkedInfo[i] = countNumber - 1
                }
            }
            ibCollectionView.reloadItems(at: needToChangeIndexs.map{IndexPath(row: $0, section: 0)})
            checkedInfo[index] = -1
        }
    }
    
    @objc func selectedListTapped() {
        isShowSelectedList = !isShowSelectedList
        ibCollectionView.reloadData()
    }
    
    
    // MARK: - IBActions
    @IBAction func ibSelectAllTapped(_ sender: Any) {
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isShowSelectedList {
            return checkedInfo.filter{ $0.value != -1 }.count
        } else {
            return checkedInfo.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell {
            cell.ibCheckButton.tag = indexPath.item
           
            if isShowSelectedList {
                let assetIndex = checkedInfo.filter{ $0.value == indexPath.item }.first?.key
                cell.ibCountNumber.isHidden = false
                cell.ibCheckButton.backgroundColor = .red
                
                if let assetIndex = assetIndex {
                    cell.ibCountNumber.text = "\(String(describing: checkedInfo[assetIndex] ?? 0))"
                    cell.setImage(imageAsset: imageAssets[assetIndex])
                    
                    ///Hande tap button after
                    cell.ibCheckButton.isUserInteractionEnabled = false
//                    cell.checkActionHandler = { index in
//                        self.updateCheckedInfo(at: assetIndex)
//                        self.ibCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
//                        self.updateSelectedInfoText()
//                    }
                }
            } else {
                ///Remove this line
                cell.ibCheckButton.isUserInteractionEnabled = true
                
                if let checkedCount = checkedInfo[indexPath.item] {
                    if checkedCount == -1 {
                        cell.ibCountNumber.isHidden = true
                        cell.ibCheckButton.backgroundColor = .clear
                    } else {
                        cell.ibCountNumber.text = "\(checkedCount)"
                        cell.ibCountNumber.isHidden = false
                        cell.ibCheckButton.backgroundColor = .red
                    }
                }
                cell.setImage(imageAsset: imageAssets[indexPath.item])
                cell.checkActionHandler = { index in
                    self.updateCheckedInfo(at: index)
                    self.ibCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    self.updateSelectedInfoText()
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
