//
//  AddStudentView.swift
//  ClassRoom Attendance
//
//  Created by Rahul Roy on 14/05/22.
//

import UIKit

class AddStudentView: UIViewController {

    @IBOutlet var studentImageView: UIImageView!
    @IBOutlet var studentName: UITextField!
    @IBOutlet var studentRoll: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func captureImage(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        if currentSection.sec.isEmpty
        {
            let alertController = UIAlertController(title:"Choose a Section First", message:nil, preferredStyle:.alert)
            self.present(alertController, animated:true, completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
            dismiss(animated: true, completion: nil)
            return
        }
        let text = studentRoll.text
        if realm.object(ofType: Student.self, forPrimaryKey: text) == nil
        {
            save()
        }
        else
        {
            let alertController = UIAlertController(title:"Student already Exists", message:nil, preferredStyle:.alert)
            self.present(alertController, animated:true, completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
            return
        }
    }
    
    func save()
    {
        guard let name = studentName.text else
        {
            return
        }
        guard let roll = studentRoll.text else
        {
            return
        }
        guard let image = studentImageView.image else
        {
            return
        }
        
        let student = Student()
        student.image = image.jpegData(compressionQuality: 1.0)
        student.name = name
        student.roll = roll
        realm.beginWrite()
        currentSection.students.append(student)
        try! realm.commitWrite()
        
        NotificationCenter.default.post(name: Notification.Name("text"), object: "Yes")
        dismiss(animated: true, completion: nil)
    }
}

extension AddStudentView: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else
        {
            return
        }
        studentImageView.image = image
    }
}
    
    
    
    
    
    
    
    
    
    
    
//
//    @IBAction func takePic(_ sender: UIButton) {
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.delegate = self
//        present(picker, animated: true)
//    }
//
//    @IBAction func submit(_ sender: UIButton) {
//    }
//
//    func save()
//    {
//        guard let name = nameField.text else
//        {
//            return
//        }
//        guard let roll = rollField.text else
//        {
//            return
//        }
//        guard let sec = sectionField.text else
//        {
//            return
//        }
//        guard let image = studentImage.image else
//        {
//            return
//        }
//
//        if let x = realm.object(ofType: Section.self, forPrimaryKey: sec)
//        {
////            if x != nil
////            {
//                let student = Student()
//                student.name = name
//                student.roll = Int(roll)!
//
//                let data = image.jpegData(compressionQuality: 1.0)
//                let NSdata = NSData(data: data!)
//                student.image = NSdata
//
//                x.students.append(student)
//           // }
//        }
//
//
//
//        //Normal
////        let data = NSData(data: image.jpegData(compressionQuality: 0.0)!)
//        //Advanced
////        let data = image.compress(to: 200)
////        let NSdata = NSData(data: data)
////        student.image = NSdata
////
////        realm.beginWrite()
////        realm.add(student)
////        try! realm.commitWrite()
//    }
//
//}
//
//extension AddStudentView: UITextFieldDelegate
//{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
//
//extension AddStudentView: UIImagePickerControllerDelegate, UINavigationControllerDelegate
//{
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
//    {
//        picker.dismiss(animated: true, completion: nil)
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
//        picker.dismiss(animated: true, completion: nil)
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else
//        {
//            return
//        }
//        studentImage.image = image
//    }
//}
