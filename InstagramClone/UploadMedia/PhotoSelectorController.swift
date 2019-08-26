//
//  PhotoSelectorController.swift
//  InstagramClone
//
//  Created by Ahmed Amr on 8/3/19.
//  Copyright © 2019 Ahmed Amr. All rights reserved.
//

import UIKit
import Photos
class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var deviceImages = [UIImage]()
    var deviceAssets = [PHAsset]()
    var selectedIndex: Int? {
        didSet {
            self.selectedImage = self.deviceImages[selectedIndex!]
        }
    }
    var selectedImage: UIImage?
    var previouslySelectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
        collectionView.backgroundColor = .white
        setupNavBar()
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: PhotoSelectorCell.reuseId)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoSelectorHeader.reuseId)
    }

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }

    private func assetFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOptions
    }

    private func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetFetchOptions())
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, _) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 250, height: 250)
                let imageOptions = PHImageRequestOptions()
                imageOptions.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: imageOptions, resultHandler: { (image, _) in
                    if let image = image {
                        self.deviceImages.append(image)
                        self.deviceAssets.append(asset)
                        if self.selectedIndex == nil {
                            self.selectedIndex = 0
                        }
                    }
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                })
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoSelectorCell.reuseId, for: indexPath) as? PhotoSelectorCell {
            cell.imageView.image = self.deviceImages[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.deviceImages.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-3)/4
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       if let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: PhotoSelectorHeader.reuseId, for: indexPath) as? PhotoSelectorHeader {
        if let selectedIndex = selectedIndex, selectedIndex != previouslySelectedIndex {
            let currentAsset = self.deviceAssets[selectedIndex]
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 500, height: 500)
            imageManager.requestImage(for: currentAsset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, _) in
                view.imageView.image = image
            }
        }
            return view
        }
        return UICollectionReusableView()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         previouslySelectedIndex = selectedIndex
         selectedIndex = indexPath.row
         collectionView.reloadData()
        let topItemIndex = IndexPath(row: 0, section: 0)
        collectionView.scrollToItem(at: topItemIndex, at: .bottom, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleNext() {
        let sharePhotoController = SharePhotoController()
        sharePhotoController.imageShared.image = selectedImage
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
}
