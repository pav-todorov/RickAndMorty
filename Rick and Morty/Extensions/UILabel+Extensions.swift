//
//  UILabel+Extensions.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 28.07.21.
//

import Foundation
import UIKit

// Custom UILabel to accommodate the custom font

class ExpandedLabel: UILabel {

  override var intrinsicContentSize: CGSize {

    let size = super.intrinsicContentSize

    // you can change 'addedHeight' into any value you want.
    let addedHeight = font.pointSize * 0.5

    return CGSize(width: size.width, height: size.height + addedHeight)
  }
}
