//
//  Button.swift
//  ONS
//
//  Created by SHIVA KUMAR on 21/07/18.
//  Copyright © 2018 ashika kalmady. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class LeftAlignedIconButton: UIButton {
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageSize = currentImage?.size ?? .zero
        let availableWidth = contentRect.width - imageEdgeInsets.right - imageSize.width - titleRect.width
        return titleRect.offsetBy(dx: round(availableWidth / 2), dy: 0)
    }
}
