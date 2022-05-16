//
//  SelectSectionView.swift
//  ClassRoom Attendance
//
//  Created by Rahul Roy on 14/05/22.
//

import UIKit
//import RealmSwift

class SelectSectionView: UIViewController {

    @IBOutlet var selectSecTB: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func submitSecTB(_ sender: UIButton) {
        let text = selectSecTB.text
        if let secData = realm.object(ofType: Section.self, forPrimaryKey: text)
        {
//            realm.beginWrite()
//            let newSection = Section()
//            newSection.sec = text!
//            realm.add(newSection)
//            try! realm.commitWrite()
            NotificationCenter.default.post(name: Notification.Name("xyz"), object: secData)
        }
        else
        {
            let alertController = UIAlertController(title:"Section does not Exists", message:nil, preferredStyle:.alert)
            self.present(alertController, animated:true, completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
        }
    }
    
}
