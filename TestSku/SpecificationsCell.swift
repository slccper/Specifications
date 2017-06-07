//
//  SpecificationsCell.swift
//  TestSku
//
//  Created by Su on 17/5/31.
//  Copyright © 2017年 Soan. All rights reserved.
//

import Foundation
import UIKit
class SpecificationsCell: UITableViewCell {
    fileprivate var titleLb : UILabel!
    fileprivate var contentCV : UICollectionView!
    fileprivate var standard :Dictionary<String,Any> = [:]
    weak var parent:SpecificationsView!{
        didSet{
            contentCV.delegate = parent
            contentCV.dataSource = parent
        }
    }
    var index :IndexPath?{
        didSet{
            contentCV.index = index
        }
    }
    var Height :CGFloat? {
        get{
            var height = contentCV.collectionViewLayout.collectionViewContentSize.height
            if height == 0{
                return nil
            }
            height += titleLb.frame.size.height + titleLb.frame.origin.y
            return height
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        titleLb = UILabel()
        let flowlayout = UICollectionViewFlowLayout()
        contentCV = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        titleLb.textAlignment = .left
        titleLb.backgroundColor = UIColor.clear
        titleLb.textColor = UIColor.black
        titleLb.font = UIFont.systemFont(ofSize: 14)
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumInteritemSpacing = 12
        flowlayout.minimumLineSpacing = 12
        flowlayout.sectionInset = UIEdgeInsetsMake(10, 12, 0, 12)
        contentCV.bounces = false
        contentCV.backgroundColor = UIColor.white
        contentCV.register(SpecificationsCVCell.self, forCellWithReuseIdentifier: "SpecificationsCVCell")
        contentCV.showsVerticalScrollIndicator = false
        contentCV.showsHorizontalScrollIndicator = false
        
        self.addSubview(titleLb)
        self.addSubview(contentCV)
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.width.greaterThanOrEqualTo(60)
            make.leading.equalTo(12)
            make.height.greaterThanOrEqualTo(14)
        }
        contentCV.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func reloadData(){
        self.contentCV.reloadData()
    }
    func loadData(_ data:Dictionary<String,Any>){
        standard = data
        titleLb.text = data["label"]as?String ?? ""
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
