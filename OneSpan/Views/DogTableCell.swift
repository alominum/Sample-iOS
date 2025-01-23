//
//  TableCell.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-23.
//

import UIKit

class DogTableCell: UITableViewCell {

    @IBOutlet private(set) public var breedName: UILabel!
    @IBOutlet private(set) public var dogImageView: UIImageView!
    @IBOutlet private(set) public var dogImageContainer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        dogImageView.alpha = 0
        dogImageContainer.startLoading()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        dogImageView.alpha = 0
        dogImageContainer.startLoading()
    }

    func fadeIn(_ image: UIImage?) {
        dogImageView.image = image

        UIView.animate(withDuration: 0.3, delay: 0.3, options: [], animations:  {
            self.dogImageView.alpha = 1
        }, completion: { completed in
            if completed {
                self.dogImageContainer.startLoading()
            }
        })
    }
}

extension DogTableCell {
    func configure(with model: TableCellViewModel) {
        breedName.text = model.name
        fadeIn(model.image)
    }
}
