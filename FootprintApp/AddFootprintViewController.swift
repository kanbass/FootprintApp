//
//  ConfirmationViewController.swift
//  FootprintApp
//
//  Created by 神戸悟 on 2019/12/18.
//  Copyright © 2019 SatoruKambe. All rights reserved.
//

import UIKit

class AddFootprintViewController: UIViewController {
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var pickerView: UIPickerView = UIPickerView()
    
    let endTimePickerList: [String] = ["30分間","1時間", "2時間", "3時間", "4時間", "5時間", "6時間", "7時間", "8時間","9時間","10時間","11時間","12時間",""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Start ピッカー関係
        // ピッカー設定
        pickerView.delegate = self as UIPickerViewDelegate
        pickerView.dataSource = self as UIPickerViewDataSource
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        finishTimeTextField.inputView = pickerView
        finishTimeTextField.inputAccessoryView = toolbar
        
        // Do any additional setup after loading the view.
    }
    // 決定ボタン押下
    @objc func done() {
        finishTimeTextField.endEditing(true)
        finishTimeTextField.text = "\(endTimePickerList[pickerView.selectedRow(inComponent: 0)])"
    }
    //End ピッカー設定終了
    
    

    @IBAction func titleTextField(_ sender: Any) {
    }
    
    @IBAction func finishTimeTextField(_ sender: Any) {
    }
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBOutlet weak var finishTimeTextField: UITextField!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    
    
    
    
    var titleText:String?
    var finishTimeText:String?
    
    //位置情報取得開始時に画面に該当タスクを表示させるためのフラグ
    var viewController:ViewController?
    
    @IBAction func startButton(_ sender: Any) {
        //バリデーションを確認する。
        
        if self.titleTextField.text != nil && self.finishTimeTextField.text != nil{
            //UserDefaultsにこれから実行するtaskIdをセットする,加え実行フラグを立てる
            let userDefaults = UserDefaults.standard
            var value = userDefaults.integer(forKey: "taskId")
            value = value + 1
            userDefaults.set(value, forKey: "taskId")
            //CoreDataに今回のtaskIdについて保存する
            let f = DateFormatter()
            f.dateFormat = "yyyyMMddHHmmss"
            let startTime = Date()
            let endTime = Calendar.current.date(byAdding: .hour, value: Int(self.finishTimeTextField.text!)!, to: startTime)!
            if let dataController = appDelegate.dataController {
                let footprint = dataController.saveFootprint(title: self.titleTextField.text!, startTime: f.string(from: startTime), endTime: f.string(from: endTime), taskId: Int32(value))
                if let footprint = footprint{
                    if let viewController = self.viewController{
                        viewController.footprints.append(footprint)
                        viewController.footprintTableView.reloadData()
                    }
                }
            }
            //現在の画面を閉じる
            self.dismiss(animated: true, completion:nil)
        }else{
            //警告文を加える
            if self.titleTextField.text != nil{
                titleLabel.text = "タイトルを入力してください"
            }
            if self.finishTimeTextField.text != nil{
                endTimeLabel.text = "位置情報取得時間を入力してください"
            }
        }
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        //キャンセルボタン押下時は何もせず戻る
        self.dismiss(animated: true, completion:nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}


//Start ピッカー関係
extension AddFootprintViewController : UIPickerViewDelegate, UIPickerViewDataSource {

    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        /*
         列が複数ある場合は
         if component == 0 {
         } else {
         ...
         }
         こんな感じで分岐が可能
         */
        return endTimePickerList.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        /*
         列が複数ある場合は
         if component == 0 {
         } else {
         ...
         }
         こんな感じで分岐が可能
         */
        return endTimePickerList[row]
    }
    
    /*
    // ドラムロール選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = list[row]
    }
     */
}
//End ピッカー関係
