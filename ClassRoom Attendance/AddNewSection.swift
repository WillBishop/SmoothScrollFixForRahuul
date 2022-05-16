//
//  AddNewSection.swift
//  ClassRoom Attendance
//
//  Created by Rahul Roy on 14/05/22.
//

import UIKit
import RealmSwift

class AddNewSection: UIViewController {

//    @IBOutlet var newSectionTextField: UITextField!
    @IBOutlet var newSectionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addSection(_ sender: UIButton) {
        let text = newSectionTextField.text
        if realm.object(ofType: Section.self, forPrimaryKey: text) == nil
        {
            realm.beginWrite()
            let newSection = Section()
            newSection.sec = text!
            realm.add(newSection)
            try! realm.commitWrite()
            dropDownValues.append(newSection.sec)
            dropDown.dataSource = dropDownValues
            dismiss(animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title:"Section Already Exists", message:nil, preferredStyle:.alert)
            self.present(alertController, animated:true, completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
            dismiss(animated: true, completion: nil)
        }
    }
    //    @IBAction func submitButton(_ sender: UIButton) {
//        let text = newSectionTextField.text
//        if realm.object(ofType: Section.self, forPrimaryKey: text) == nil
//        {
//            realm.beginWrite()
//            let newSection = Section()
//            newSection.sec = text!
//            realm.add(newSection)
//            try! realm.commitWrite()
//        }
//        else
//        {
//            let alertController = UIAlertController(title:"Section Already Exists", message:nil, preferredStyle:.alert)
//            self.present(alertController, animated:true, completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
//                self.dismiss(animated: true, completion: nil)
//            })})
//        }
//    }
}
