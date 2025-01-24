//
//  TableCell.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import UIKit

class DogTableCell: UITableViewCell {

    @IBOutlet weak var breedName: UILabel!
    @IBOutlet weak var subBreedNames: UILabel!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogImageContainer: UIView!
    @IBOutlet weak var retryButton: UIButton!

    var onRetry: (() -> Void)?

//    var imageLoader: FeedImageDataLoader?

    override func awakeFromNib() {
        super.awakeFromNib()

        dogImageView.alpha = 0
        dogImageContainer.isLoading = true
    }

    override func prepareForReuse() {
        super.prepareForReuse() 

        dogImageView.alpha = 0
        dogImageContainer.isLoading = true
    }

    func fadeIn(_ image: UIImage?) {
        dogImageView.image = image

        UIView.animate(withDuration: 0.3, delay: 0.3, options: [], animations:  {
            self.dogImageView.alpha = 1
        }, completion: { completed in
            if completed {
                self.dogImageContainer.isLoading = false
            }
        })
    }

    @IBAction private func retryButtonTapped() {
        onRetry?()
    }

    
}
