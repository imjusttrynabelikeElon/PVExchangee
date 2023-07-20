//
//  photoCollectionViewController.swift
//  PVExchange
//
//  Created by Karon Bell on 7/10/23.
//
//

import UIKit
import Photos

private let reuseIdentifier = PhotoCollectionViewCell.reuseIdentifier


class photoCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = PhotoCollectionViewCell.reuseIdentifier
    var photosArray: [Photo] = []  // Update the access level to internal or public
        
    // Custom initializer to receive the photosArray
    init(photosArray: [Photo]) {
           self.photosArray = photosArray.reversed()  // Reverse the photosArray
           
           // Call the designated initializer of the superclass
           super.init(collectionViewLayout: UICollectionViewFlowLayout())
       }
    // this is the required init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()

        // Register the cell class with the reuse identifier
               collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
           // ...

           // Set the delegate and data source of the collection view
           collectionView.delegate = self
           collectionView.dataSource = self
        
        // Set the navigation title
           let titleLabel = UILabel()
           titleLabel.text = "Flicks"
           titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
           titleLabel.textColor = .black
           navigationItem.titleView = titleLabel

           // Set the delegate and data source of the collection view
           collectionView.delegate = self
           collectionView.dataSource = self

           // Set the item size of the collection view flow layout
           if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
               let itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 20, height: UIScreen.main.bounds.width / 1.3 - 73) // Adjust the size as desired
               layout.itemSize = itemSize
               layout.minimumInteritemSpacing = 8 // Adjust the spacing as desired
               layout.minimumLineSpacing = 10 // Adjust the spacing as desired
               layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Adjust the insets as desired
           }
       }
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

           // Check if the database is initialized before retrieving photos
           guard SQliteDatabase.sharedInstance.isInitialized else {
               // Delay the retrieval until the database is initialized
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Adjust the delay time as needed
                   self.viewWillAppear(animated)
               }
               return
           }

           // Create the "photos" table if it doesn't exist
           SQliteDatabase.sharedInstance.createTable()

           // Retrieve photos from the database and update the photosArray
           photosArray = SQliteDatabase.sharedInstance.getAllPhotos()
           collectionView.reloadData()
       }




    
    // MARK: - Collection View Data Source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photosArray[indexPath.item]
        let detailViewController = PhotoDetailViewController(photo: photo)
        navigationController?.pushViewController(detailViewController, animated: true)

        // Save the photo to the database when selected
        SQliteDatabase.sharedInstance.insertPhoto(photo: photo)
    }


      

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return photosArray.count
        
       }

       override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell

           let photo = photosArray[indexPath.item]
           cell.configure(with: photo)

           return cell
       }

    
    // MARK: - Action
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

class PhotoCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureImageView()
    }
    // this is the amount
    // go to the collectionViewTime
    // goToTheAmountofDidTapBackButton
    // goToTheAmountTheTheirIsTheFrontButton
    // goToThisAmountTheAmountOfVibeItTakesTo
  
    
    // thisIsforcollectionThis
    // thisShowsThisAmount
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with photo: Photo) {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat

        // Fetch the image from the asset
        imageManager.requestImage(for: photo.asset, targetSize: frame.size, contentMode: .aspectFill, options: requestOptions) { image, _ in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }

}
