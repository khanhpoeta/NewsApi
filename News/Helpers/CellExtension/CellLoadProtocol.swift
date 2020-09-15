//
//  CellLoadProtocol.swift
//  NeAlo
//
//  Created by Kent Nguyen on 12/28/19.
//  Copyright © 2019 NeAlo. All rights reserved.
//

import UIKit

@objc protocol CellLoadProtocol {
    @objc func load(entity:Any?)
}

extension UITableViewCell: CellLoadProtocol{
    func load(entity: Any?) {
        
    }
}

extension UICollectionViewCell : CellLoadProtocol{
    @objc func load(entity: Any?) {
        
    }
}
 
