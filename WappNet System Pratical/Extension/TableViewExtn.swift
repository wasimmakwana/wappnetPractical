//
//  TableViewExtn.swift
//  WappNet System Pratical
//
//  Created by Wasim on 30/09/21.
//

import Foundation
import UIKit

extension UITableView
{
    func indexPathForView(_ view: UIView) -> IndexPath?
    {
        return self.indexPathForRow(at: convert(view.center, from: view.superview))
    }
    
}
