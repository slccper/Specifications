//
//  SpecificationsCVCell.swift
//  TestSku
//
//  Created by Su on 17/5/31.
//  Copyright © 2017年 Soan. All rights reserved.
//

import Foundation
import UIKit
class SpecificationsCVCell: UICollectionViewCell {
    fileprivate var lbtitle :UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView(){
        lbtitle = UILabel()
        lbtitle.textAlignment = .center
        lbtitle.font = UIFont.systemFont(ofSize: 13)
        lbtitle.clipsToBounds = true
        lbtitle.layer.cornerRadius = 2
        contentView.addSubview(lbtitle)
        lbtitle.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    override var isSelected: Bool{
        didSet{
            lbtitle.backgroundColor = super.isSelected ? UIColor.yellow : UIColor.lightGray.withAlphaComponent(0.4)
        }
    }
    func setText(_ text:String,_ canSelect:Bool){
        lbtitle.text = text
        lbtitle.textColor = canSelect ? UIColor.black : UIColor.darkText
    }
}
