//
//  SpecificationsView.swift
//  TestSku
//
//  Created by Su on 17/5/31.
//  Copyright © 2017年 Soan. All rights reserved.
//

import Foundation
import UIKit
let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;
class SpecificationsView: UIView {
    fileprivate var bgView : UIView!
    fileprivate var titleLb : UILabel!
    fileprivate var priceTitleLb : UILabel!
    fileprivate var priceLb : UILabel!
    fileprivate var tbView : UITableView!
    fileprivate var sureBtn : UIButton!
    fileprivate var min :Float = 0
    fileprivate var max :Float = 0
    fileprivate var heights :[IndexPath:CGFloat] = [:]
    fileprivate var CollectionHeights :[Int:CGSize] = [:]
    fileprivate let StandardHeight :CGFloat = 471
    fileprivate var stock : [Dictionary<String,Any>] = []
    fileprivate var selectDict :Dictionary<String,Dictionary<String,Any>> = [:]
    fileprivate var list: [Dictionary<String,Any>] = []{
        didSet{
            if min == 0 {
                min = stock.reduce(0.00) { (data, stock) -> Float in
                    let min = Float(stock["newPrice"]as!Int)/100
                    if data == 0 {
                        return min
                    }
                    return data > min ? min : data
                }
            }
            if max == 0 {
                max = stock.reduce(0.00) { (data, stock) -> Float in
                    let max = Float(stock["newPrice"]as!Int)/100
                    if data == 0 {
                        return max
                    }
                    return data < max ? max : data
                }
            }
        }
    }
    init(data:[String:AnyObject]) {
        super.init(frame: UIScreen.main.bounds)
        
        self.bgView = UIView()
        self.titleLb = UILabel()
        self.priceTitleLb = UILabel()
        self.priceLb = UILabel()
        let line = UIView()
        self.tbView = UITableView()
        self.sureBtn = UIButton()
        
        bgView.backgroundColor = UIColor.white
        titleLb.text = "商品规格"
        titleLb.textColor = UIColor.black
        titleLb.textAlignment = .center
        titleLb.font = UIFont.systemFont(ofSize: 14)
        priceTitleLb.text = "商品单价:"
        priceTitleLb.textColor = UIColor.gray
        priceTitleLb.textAlignment = .left
        priceTitleLb.font = UIFont.systemFont(ofSize: 14)
        priceLb.textColor = UIColor.black
        priceLb.textAlignment = .left
        priceLb.font = UIFont.systemFont(ofSize: 14)
        line.backgroundColor = UIColor.lightGray
        tbView = UITableView(frame: CGRect(), style: .grouped)
        tbView.backgroundColor = UIColor.clear
        tbView.separatorStyle = .none
        tbView.register(SpecificationsCell.self, forCellReuseIdentifier: "SpecificationsCell")
        tbView.dataSource = self
        tbView.delegate = self
        tbView.estimatedRowHeight = 50
        sureBtn = UIButton()
        sureBtn.setTitle("完成", for: .normal)
        sureBtn.backgroundColor = UIColor.yellow
        sureBtn.setTitleColor(UIColor.black, for: .normal)
        sureBtn.isSelected = true
        addSubview(bgView)
        bgView.addSubview(titleLb)
        bgView.addSubview(priceTitleLb)
        bgView.addSubview(priceLb)
        bgView.addSubview(line)
        bgView.addSubview(tbView)
        bgView.addSubview(sureBtn)
        
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo(0)
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(snp.bottom)
        }
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.trailing.equalTo(0)
            make.height.greaterThanOrEqualTo(0)
            make.leading.equalTo(0)
        }
        priceTitleLb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(30)
            make.leading.equalTo(12)
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(0)
        }
        priceLb.snp.makeConstraints { (make) in
            make.left.equalTo(priceTitleLb.snp.right).offset(5)
            make.trailing.lessThanOrEqualTo(0)
            make.top.equalTo(priceTitleLb.snp.top)
            make.bottom.equalTo(priceTitleLb.snp.bottom)
        }
        line.snp.makeConstraints { (make) in
            make.top.equalTo(priceTitleLb.snp.bottom).offset(11)
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.height.equalTo(1)
        }
        sureBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        tbView.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(sureBtn.snp.top)
        }
        
        sureBtn.addTarget(self, action: #selector(didDismiss(_:)), for: .touchUpInside)
        self.stock = data["stock"]as?[[String:Any]] ?? []
        self.list = (data["props"]as?[Dictionary<String, Any>] ?? []).map({ (prop) -> Dictionary<String, Any> in
            var temp = prop
            temp["selectItem"] = ""
            let selects :[Bool] = Array(repeating: true, count: (temp["list"]as?[Dictionary<String,Any>] ?? []).count)
            temp["canSelect"] = selects
            return temp
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first
        if !(bgView.point(inside: touch!.location(in: bgView), with: event))  {
            dismiss()
        }
    }
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        bgView.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(self.StandardHeight)
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        self.tbView.perform(#selector(self.tbView.reloadData), with: nil, afterDelay: 0.1)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    func didDismiss(_ sender:UIButton?){
        dismiss()
    }
    func dismiss(){
        bgView.snp.remakeConstraints { (make) in
            make.bottom.equalTo(snp.bottom).offset(self.StandardHeight)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(self.StandardHeight)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }) { (isTrue) in
            self.removeFromSuperview()
        }
    }
    deinit {
        print("StandardView deinit")
    }
}
// MARK: - UITableViewDataSource
extension SpecificationsView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificationsCell", for: indexPath)as! SpecificationsCell
        cell.selectionStyle = .none
        cell.loadData(list[indexPath.row])
        return cell
    }
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if heights[indexPath] == nil {
            guard let cell = tableView.cellForRow(at: indexPath)as?SpecificationsCell,let cellHeight = cell.Height else{
                return 50
            }
            heights[indexPath] = cellHeight
        }
        return heights[indexPath]!
    }
}
// MARK: - UITableViewDelegate
extension SpecificationsView:UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let standardCell = cell as?SpecificationsCell
        standardCell?.parent = self
        standardCell?.index = indexPath
        standardCell?.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}
// MARK: - UICollectionViewDataSource UICollectionViewDelegateFlowLayout
extension SpecificationsView :UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let standard = list[collectionView.index?.row ?? 0]
        return (standard["list"]as?[Dictionary<String,Any>] ?? []).count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecificationsCVCell", for: indexPath)as! SpecificationsCVCell
        let standard = list[collectionView.index?.row ?? 0]
        cell.isSelected = (standard["list"]as?[Dictionary<String,Any>] ?? [])[indexPath.row]["name"]as?String == standard["selectItem"]as?String
        cell.setText((standard["list"]as?[Dictionary<String,Any>] ?? [])[indexPath.row]["name"]as?String ?? "",(standard["canSelect"]as?[Bool] ?? [])[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = collectionView.index?.row ?? 0
        if CollectionHeights[indexPath.row+index*100] != nil {
            return CollectionHeights[indexPath.row+index*100]!
        }
        let standard = list[index]
        let item = (standard["list"]as?[Dictionary<String,Any>] ?? [])[indexPath.row]
        let width = (item["name"] as?NSString ?? "").boundingRect(with: CGSize(width:SCREEN_WIDTH-24, height:28), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil).size.width
        CollectionHeights[indexPath.row+index*100] = CGSize(width:width+22, height:28)
        return CollectionHeights[indexPath.row+index*100]!
    }
}
//MARK: - UICollectionViewDelegate
extension SpecificationsView :UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let standard = list[collectionView.index?.row ?? 0]
        return (standard["canSelect"]as?[Bool] ?? [])[indexPath.row]
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = collectionView.index?.row ?? 0
        var standard = list[index]
        let item = (standard["list"]as?[Dictionary<String,Any>] ?? [])[indexPath.row]
        let label = standard["label"]as?String ?? ""
        if item["name"]as?String == standard["selectItem"]as?String {
            standard["selectItem"] = ""
            let index = selectDict.index(forKey: label)
            selectDict.remove(at: index!)
        }else{
            standard["selectItem"] = item["name"]as?String
            selectDict[label] =  item
        }
        list.remove(at: index)
        list.insert(standard, at: index)
        let littleCount = self.selectDict.keys.count - 1
        //获取选择的全部为条件的stock
        let selectStock = stock.filter { (stock) -> Bool in
            var count = 0
            for value in selectDict.values.enumerated(){
                if stock[value.element.keys.first ?? ""]as?String ?? "" == value.element.values.first as?String ?? ""{
                    count += 1
                }
            }
            return count == selectDict.keys.count
        }
        //获取选择的排列组合为条件的stock
        let littleStock = stock.filter { (stock) -> Bool in
            var count = 0
            for value in selectDict.values.enumerated(){
                if stock[value.element.keys.first ?? ""]as?String ?? "" == value.element.values.first as?String ?? ""{
                    count += 1
                }
            }
            let isCan = (count == littleCount || count == self.selectDict.keys.count) && stock["stock"]as?Int ?? 0 > 0
            return isCan
        }
        //筛选
        list = list.map { (data) -> Dictionary<String,Any> in
            for element in (data["list"]as?[Dictionary<String,Any>] ?? []).enumerated() {
                //被选择项处理
                var selects = (data["canSelect"]as![Bool])
                if self.selectDict.keys.count > 0 && self.selectDict[data["label"]as?String ?? ""] != nil {
                    //只选择了一项，当中的就全部可选
                    if self.selectDict.keys.count == 1{
                        
                        selects[element.offset] = true
                    }else{
                        //其余的就根据排列组合处理
                        selects[element.offset] = littleStock.filter{(stock) -> Bool in
                            for value in selectDict.values.enumerated(){
                                if stock[value.element.keys.first ?? ""]as?String ?? "" == value.element.values.first as?String ?? ""{
                                    return true
                                }
                            }
                            return false
                            }.count > 0
                    }
                }else if self.selectDict.keys.count > 0 && self.selectDict[data["label"]as?String ?? ""] == nil {
                    //选择后，非选择项处理
                    selects[element.offset] = selectStock.filter{(stock) -> Bool in
                        for value in selectDict.values.enumerated(){
                            if stock[value.element.keys.first ?? ""]as?String ?? "" == value.element.values.first as?String ?? ""{
                                return true
                            }
                        }
                        return false
                        }.count > 0
                }else{
                    //未选择时处理
                    selects[element.offset] =  true
                }
            }
            return data
        }
        self.tbView.reloadData()
    }
}
