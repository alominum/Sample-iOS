//
//  TableViewModel.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-24.
//

import UIKit

struct TableCellViewModel {
    let dog: Dog

    init(_ model: Dog) {
        self.dog = model
    }

    var breedsDescription: String {
        if dog.subBreed.isEmpty {
            return ""
        } else {
            return "Breed: \(dog.breed) has Sub-breeds: \(dog.subBreed.joined(separator: ", "))"
        }
    }

    var title: String {
        dog.breed
    }

}
