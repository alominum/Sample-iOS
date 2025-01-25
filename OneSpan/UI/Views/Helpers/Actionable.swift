//
//  Actionable.swift
//  OneSpan
//
//  Created by Nima Nassehi on 2025-01-25.
//

import UIKit.UIControl

protocol Actionable {
    func addAction(_ action: UIAction, for controlEvents: UIControl.Event)
}
