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

    private func fetchPhotos() {
        let fetchOption = PHFetchOptions()
        fetchOption.fetchLimit = 10
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOption)
        allPhotos.enumerateObjects { (asset, count, _) in
            print(asset)
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 350, height: 350)
            let imageOptions = PHImageRequestOptions()
            imageOptions.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: imageOptions, resultHandler: { (image, _) in
                if let image = image {
                    self.deviceImages.append(image)
                }
                if count == allPhotos.count - 1 {
                    self.collectionView.reloadData()
                }
            })
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
         view.imageView.image = self.deviceImages[0]
            return view
        }
        return UICollectionReusableView()
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
        print("Next")
    }
}
