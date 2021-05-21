//
//  GBCharacterListCell.swift
//  GBMarvel
//
//  Created by Aditya Deshmane on 17/05/21.
//

import Foundation
import UIKit

class GBCharacterListCell: UITableViewCell {
    
    static let cellIdentifierString = "GBCharacterListCell"
    @IBOutlet private weak var labelTitle: UILabel!

    func configure(strTitle: String) {
        labelTitle.text = strTitle
    }
}
