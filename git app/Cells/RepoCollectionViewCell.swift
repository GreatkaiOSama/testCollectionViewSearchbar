//
//  RepoCollectionViewCell.swift
//  git app
//
//  Created by Henry Silva Olivo on 1/15/20.
//  Copyright © 2020 hsilva. All rights reserved.
//

import UIKit

class RepoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var bgcell: UIView!
    
    @IBOutlet var imgavatar: UIImageView!
    
    @IBOutlet var lblrepo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        self.bgcell.layer.masksToBounds = true
        self.bgcell.layer.cornerRadius = 3.f
        self.bgcell.clipsToBounds = true
    }

}
