//
//  ViewController.swift
//  mineServer001
//
//  Created by mf-osaka on 2021/05/31.
//

import UIKit
import Foundation

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    //var mineJSON:[mineJSON]=[]

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var mineData001=[mineData]()
    
    struct mineJSON:Codable{
        var name:String
        var address:String
    }
    
    //jsonのデータ構造
       struct ResultJson: Codable {
           //複数要素
           let item:[mineJSON]?
       }
    
    /*
    var mineData: [[String: Any]] = [] { //パースした[String: Any]型のクーポンデータを格納するメンバ変数
            didSet{
                tableView.reloadData()
            }
        }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.delegate=self
        self.tableView.dataSource=self
        
        
        
        let url=URL(string:"http://windy-saiki-0663.greater.jp/mineServer_iOS/index002_json.php")!
        
        let request = URLRequest(url: url)
        //request.httpMethod = "POST"
        
        let task: URLSessionTask  = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            
            
            do{
                /*
                let jsonData = try JSONSerialization.data(withJSONObject:data!, options: [])
                let jsonStr = String(bytes: jsonData, encoding: .utf8)!
                print(jsonStr)
                
                let jsonData = jsonStr.data(using: .utf8)!
                let mineData = try? JSONDecoder().decode([mineJSON.self], from: data!)
                print(mineData)
                */
                
                /*
                let json = try JSONSerialization.jsonObject(with:data!, options:[]) //JSONパース。optionsは型推論可(".allowFragmets"等)
                    let top = json as! NSArray // トップレベルが配列
                    for roop in top {
                        let next = roop as! NSDictionary
                        print(next["name"] as! String) // 1, 2 が表示

                        //let content = next["content"] as! NSDictionary
                        //print(content["age"] as! Int) // 25, 20 が表示
                    }
                    */
                
                //let items = try JSONSerialization.jsonObject(with:data!) as! Dictionary<String, Any>
                    //print(items["id"] as! Int) // メンバid Intにキャスト
                    //print(items["name"] as! String)
                
                
                //let Data = String(data: data!, encoding:  .utf8)
                //print("php output: \(String(describing: Data))")
                
                
                
                /*
                let decoder = JSONDecoder()
                guard let mineData = try? decoder.decode([ResultJson].self, from: data!
                ) else {
                   fatalError("JOSN読み込みエラー")
            
                }

                for value in mineData {
                   print(value)
                }
                */
                struct ResultData: Decodable {
                    let shop: [mineJSON]
                
                    struct mineJSON:Decodable{
                        let name:String?
                        let address:String?
                    }
                }
//参考サイト
//https://qiita.com/Ajyarimochi/items/50cdc57f898b79cfb48e
                
                let jsonDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [Any]


                //print(jsonDict)
                
                let jsonData=jsonDict.map{(jsonDict)->[String:Any] in
                    return jsonDict as! [String:Any]
                }
                
                //print(jsonData)
                
                //print(jsonData[0]["name"] as! String)
                //print(jsonData[0]["address"] as! String)
                
                /*
                DispatchQueue.main.async(){()->Void in
                    self.mineData=jsonData
                }
                */
            
                
                //print(String(data: data!, encoding: .utf8) ?? "")
                 
                /// ③JSONデータ確認
                //print("***** JSONデータ確認 *****")
                //print(String(bytes: data!, encoding: .utf8)!)
                 
                /// ④JSONから変換
                /*
                let decoder = JSONDecoder()
                guard let mineData: ResultData = try? decoder.decode(ResultData.self, from:data!) else {
                    fatalError("Failed to decode from JSON.")
                }
                 
                /// ⑤最終データ確認
                print("***** 最終データ確認 *****")
                //print(mineData)
                */
                
                let decoder=JSONDecoder()
                
                if let mineData001=try? decoder.decode([mineData].self,from:data!){
                    //print(mineData001)
                    DispatchQueue.main.async{
                        self.mineData001=mineData001
                        self.tableView.reloadData()
                        //print(mineData001)
                    }
                }
                
                
 
                
            }catch let error{
                print(error)
            }
            
            
            })
            task.resume()
        
                
    }
    
    

    @IBAction func POST_SEND(_ sender: Any) {
        
        let urlString="http://windy-saiki-0663.greater.jp/mineServer_iOS/index001.php";
        
        //UIから氏名とメールアドレスを取得する
        let name=nameTextField.text
        let address=addressTextField.text
        
        let request=NSMutableURLRequest(url:URL(string:urlString)!)
        
        request.httpMethod="POST"
        
        request.addValue("application/json",forHTTPHeaderField:"Content-Type")
        
        //JSON作成
        let params:[String:Any]=[
            "name":"藤村太朗",
            "address":"sfujimura2@gmail.com"
        ]
        
        //UIのtextFieldから文字列を取得してJSON配列に挿入
        var jsonObj=Dictionary<String,Any>()
        jsonObj["name"]=name
        jsonObj["address"]=address
        
        do{
            request.httpBody=try JSONSerialization.data(withJSONObject:jsonObj,options:.prettyPrinted)
            
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                let resultData=String(data:data!,encoding:.utf8)!
            
            print("result:\(resultData)")
            print("response:\(response)")
            }
            )
            
            task.resume()
        }catch{
            print ("Error:\(error)")
        }
    
}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(mineData001)
        return mineData001.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print (mineData001)
        
        let cell:UITableViewCell=tableView.dequeueReusableCell(withIdentifier:"MyCell",for:indexPath)
        
        let Data=mineData001[indexPath.row]
        
        
        cell.textLabel?.text=Data.name
        cell.detailTextLabel?.text=Data.address
        
        return cell
    }

}
