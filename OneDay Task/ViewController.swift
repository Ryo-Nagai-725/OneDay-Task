//
//  ViewController.swift
//  OneDay Task
//
//  Created by 永井涼 on 2020/07/15.
//  Copyright © 2020 永井涼. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var textFiledTodo: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
       var todoTextArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.overrideUserInterfaceStyle = .light
        tableView.delegate = self
               tableView.dataSource = self
               textFiledTodo.delegate = self
               
               

            
               
               if UserDefaults.standard.object(forKey: "Todo") != nil {
                         
                         todoTextArray = UserDefaults.standard.object(forKey: "Todo") as! [String]
                   
                   
                   
                   tableView.reloadData()
                     }
           
    }

    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          
          navigationController?.isNavigationBarHidden = false
      }
      
      
      override func setEditing(_ editing: Bool, animated: Bool) {
          //override前の処理を継続してさせる
          super.setEditing(editing, animated: animated)
          //tableViewの編集モードを切り替える
          tableView.isEditing = editing//editingはBool型でeditButtonに依存する変数
    
}
    @IBAction func trashButton(_ sender: Any) {
        
        if(tableView.isEditing == true) {
                 tableView.isEditing = false
                    } else {
                 tableView.isEditing = true
                    }
    }
    
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           //tableViewCellの削除
        if editingStyle == UITableViewCell.EditingStyle.delete {
            todoTextArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            UserDefaults.standard.set(todoTextArray, forKey: "Todo")
        }
        
       }
//    テーブルに表示する配列の数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  todoTextArray.count
       }
    
    
       
    
    
//    Cellの値を設定
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = todoTextArray[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        return cell
        
       }
//cellを押した時
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        
        let alert: UIAlertController = UIAlertController(title: "お疲れ様です!", message: "タスクを完了しますか？", preferredStyle: UIAlertController.Style.actionSheet)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "完了", style: UIAlertAction.Style.default,handler:{ (action:UIAlertAction!)-> Void in
             tableView.allowsMultipleSelection = true
                   cell?.accessoryType = .checkmark
                   cell?.backgroundColor = .gray
                   cell?.textLabel?.text = "完了"
                   cell?.textLabel?.textColor = UIColor.white
                   cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        })

         let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel,handler:{ (action:UIAlertAction!)-> Void in
       print("キャンセル")
    })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        self.present(
        alert,
        animated:  true,
        completion: {
            print("アラートが表示された")
        })

    }
//    didSelectの後にやる処理
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        tableView.allowsMultipleSelection = true
        cell?.accessoryType = .none
        cell?.textLabel?.text = todoTextArray[indexPath.row]
        cell?.backgroundColor = .clear
        cell?.textLabel?.textColor = .black
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.frame.size.height/15
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        todoTextArray.append(textFiledTodo.text!)
        textFiledTodo.resignFirstResponder()
        textFiledTodo.text = ""
        UserDefaults.standard.set(todoTextArray, forKey: "Todo")
        tableView.reloadData()
        return true
    }
}
