//
//  CalendarView.swift
//  ClassRoom Attendance
//
//  Created by Rahul Roy on 15/05/22.
//

import UIKit

class CalendarView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.view.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
//        [self.tabBarController, setTitle:@"Title"];
        self.tabBarController?.title = "Title"
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
