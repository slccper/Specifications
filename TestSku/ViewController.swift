//
//  ViewController.swift
//  TestSku
//
//  Created by Su on 17/5/31.
//  Copyright © 2017年 Soan. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    fileprivate var skuinfo :[String:AnyObject] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        var request = URLRequest(url: URL(string: "http://m.mogujie.com/detail/mgj/v1/h5?_ajax=1&iid=1kc66r0&cparam=")!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) {data1, response, err in
            guard let data = data1 else{return}
            print(String(data: data, encoding: .utf8))
            var json :[String:AnyObject] = [:]
            do {
                let any = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                guard let anydata = any as?[String:AnyObject] else{return}
                json = anydata
            } catch {
                print(error)
            }
            guard let result = json["result"]as?[String:AnyObject],let skuinfo = result["skuInfo"]as?[String:AnyObject] else{return}
            self.skuinfo = skuinfo
            }.resume()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func clickAction(_ sender: AnyObject) {
        let skuview = SpecificationsView(data: skuinfo)
        skuview.show()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

