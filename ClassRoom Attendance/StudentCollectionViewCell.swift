//
//  StudentCollectionViewCell.swift
//  ClassRoom Attendance
//
//  Created by Rahul Roy on 13/05/22.
//

import UIKit

class StudentCollectionViewCell: UICollectionViewCell {
    @IBOutlet var studentImage: UIImageView!
    @IBOutlet var studentName: UILabel!
    @IBOutlet var studentRoll: UILabel!
    func setup(with student: Student)
    {
        let image = UIImage(data:student.image! as Data)
        studentImage.image = image
        studentName.text = student.name
        studentRoll.text = String(student.roll)
    }
}
