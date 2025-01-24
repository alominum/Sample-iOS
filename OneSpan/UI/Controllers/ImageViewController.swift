//
//  ImageViewController.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//
//

import UIKit

final class DogCellController {
    private var task: Task<Void, Never>?
    private let model: TableCellViewModel
    private let imageLoader: FeedImageDataLoader

    init(model: TableCellViewModel, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    func view(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogTableCell", for: indexPath) as! DogTableCell
        cell.breedName.text = model.title.capitalized
        cell.subBreedNames.text = model.breedsDescription
        cell.dogImageView.image = nil
        cell.retryButton.isHidden = true
        cell.dogImageContainer.isLoading = true

        let loadImage = { [weak self] in
            guard let self = self, let imageUrl = self.model.imageURL else { return }

            self.task = Task {
                do {
                    let imageData = try await self.imageLoader.loadImageData(from: imageUrl)
                    let image = UIImage(data: imageData)
                    await MainActor.run {
                        cell.fadeIn(image)
                        cell.retryButton.isHidden = (image != nil)
                        cell.dogImageContainer.isLoading = false
                    }
                } catch {
                    await MainActor.run {
                        cell.dogImageContainer.isLoading = false
                    }
                }
            }
        }

        cell.onRetry = loadImage
        loadImage()

        return cell
    }

    func preload() {

        self.task = Task {
            if let imageUrl = self.model.imageURL {
                _ = try? await self.imageLoader.loadImageData(from: imageUrl)
            }
        }
    }

    deinit {
        task?.cancel()
    }
}


