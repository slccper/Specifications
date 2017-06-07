//
//  UICollectionView+Extension.swift
//  TestSku
//
//  Created by Su on 17/5/31.
//  Copyright © 2017年 Soan. All rights reserved.
//

import Foundation
import UIKit
private var indexPathKey: Void?
extension UICollectionView {
    var index :IndexPath?{
        get{
            return objc_getAssociatedObject(self, &indexPathKey) as? IndexPath
        }set{
            objc_setAssociatedObject(self, &indexPathKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
