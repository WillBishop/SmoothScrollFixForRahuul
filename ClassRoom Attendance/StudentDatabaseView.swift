//
//  StudentDatabaseView.swift
//  ClassRoom Attendance
//
//  Created by Rahul Roy on 13/05/22.
//

import UIKit
import RealmSwift
import DropDown

let dropDown = DropDown()
var currentSection = Section()
var dropDownValues: [String] = []

class StudentDatabaseView: UIViewController{
    
    
    @IBOutlet var studentCollectionView: UICollectionView!
    @IBOutlet var dropDownView: UIView!
    @IBOutlet var availableSectionsLabel: UIButton!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding buttons to Navigation item bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapRight))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(didTapLeft))

        //Setting drop down attributes
        dropDown.backgroundColor = .systemBackground
        dropDown.textColor = .label
        dropDown.selectionBackgroundColor = .quaternaryLabel
        dropDownView.layer.cornerRadius = 15
        
        //Initial drop down button text
        availableSectionsLabel.setTitle("Choose a Section", for: .normal)
        
        //Collection View
        studentCollectionView.dataSource = self
        studentCollectionView.delegate = self
        studentCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        //Deletes all the data from the database
//        realm.beginWrite()
//        realm.delete(realm.objects(Student.self))
//        realm.delete(realm.objects(Section.self))
//        try! realm.commitWrite()
        
        //Adding section names to drop down
        for section in sections
        {
            dropDownValues.append(section.sec)
        }
        
        //Adding constraints for drop down
        dropDown.anchorView = dropDownView
        dropDown.dataSource = dropDownValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        
        //Loads the data of selected Section to collection view
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.availableSectionsLabel.setTitle(item, for: .normal)
            if let currSec = realm.object(ofType: Section.self, forPrimaryKey: item)
            {
                currentSection = currSec
                self.studentCollectionView.reloadData()
            }
        }
        
        //Gets Student object when new student is added
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("text"), object: nil)
    }
    
    @IBAction func checkAvailableSections(_ sender: UIButton) {
        dropDown.show()
    }
    
    @objc func didGetNotification(_ notification: Notification)
    {
        DispatchQueue.main.async { [self] in
            self.studentCollectionView.reloadData()
        }
    }
    
    //Adds new section
    @objc func didTapRight()
    {
        let alert = UIAlertController(title: "Add a New Section", message: "" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addTextField { field in
            field.placeholder = "Section Name"
            field.returnKeyType = .continue
        }
        alert.addAction(UIAlertAction(title: "Add", style: .destructive, handler: { action in
            guard let field = alert.textFields, field[0].text! != "" else
            {
                let alertWrong = UIAlertController(title: "Incorrect Input", message: "" , preferredStyle: .alert)
                self.present(alertWrong, animated:true, completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
                    self.dismiss(animated: true, completion: nil)
                })})
                return
            }
            let inputSection = field[0]
            if self.realm.object(ofType: Section.self, forPrimaryKey: inputSection.text!) == nil
            {
                self.realm.beginWrite()
                let newSection = Section()
                newSection.sec = inputSection.text!
                self.realm.add(newSection)
                try! self.realm.commitWrite()
                dropDownValues.append(newSection.sec)
                dropDown.dataSource = dropDownValues
            }
            else
            {
                let alertController = UIAlertController(title:"Section Already Exists", message:nil, preferredStyle:.alert)
                self.present(alertController, animated:true, completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
                    self.dismiss(animated: true, completion: nil)
                })})
            }
        }))
        present(alert, animated: true)
    }
    
    //Deletes current Section
    @objc func didTapLeft()
    {
        guard !currentSection.sec.isEmpty else
        {
            let alertController = UIAlertController(title:"Select a Section First", message:nil, preferredStyle:.alert)
            self.present(alertController, animated:true, completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
            return
        }
        let alert = UIAlertController(title: "Are you sure you want to delete the Section?", message: "This would permanently delete the Section and the Students." , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            var iterator = 0
            while iterator < dropDownValues.count
            {
                if dropDownValues[iterator] == currentSection.sec
                {
                    dropDownValues.remove(at: iterator)
                    break
                }
                iterator += 1
            }
            dropDown.dataSource = dropDownValues
            
            self.realm.beginWrite()
            self.realm.delete(currentSection.students)
            self.realm.delete(currentSection)
            try! self.realm.commitWrite()
            
            guard let firstSec = sections.first else
            {
                currentSection = Section()
                self.availableSectionsLabel.setTitle("Choose a Section", for: .normal)
                self.studentCollectionView.reloadData()
                return
            }
            currentSection = firstSec
            self.availableSectionsLabel.setTitle(currentSection.sec, for: .normal)
            self.studentCollectionView.reloadData()
        }))
        present(alert, animated: true)
    }
}



extension StudentDatabaseView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentSection.students.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudentCollectionViewCell", for: indexPath) as! StudentCollectionViewCell
        cell.setup(with: currentSection.students[indexPath.row])
        return cell
    }
}

extension StudentDatabaseView: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/3)-3, height: (view.frame.size.height/4))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}


//Shows data of student when cell is tapped
extension StudentDatabaseView: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Name: \(currentSection.students[indexPath.row].name) \n Roll No.: \(currentSection.students[indexPath.row].roll)", message: "" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        let image = UIImage(data:currentSection.students[indexPath.row].image! as Data)
        alert.addImage(image: image!)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.realm.beginWrite()
            self.realm.delete(currentSection.students[indexPath.row])
            try! self.realm.commitWrite()
            self.studentCollectionView.reloadData()
        }))
        present(alert, animated: true)
    }
}

//To get image in an alert with peoper dimensions
extension UIImage {
    func imageWithSize(_ size:CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth:CGFloat = size.width / self.size.width
        let aspectHeight:CGFloat = size.height / self.size.height
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        self.draw(in: scaledImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

// To get image in an alert with peoper dimensions
extension UIAlertController
{
    func addImage(image: UIImage)
    {
        let maxSize = CGSize(width: 245, height: 300)
        let imgSize = image.size
        var ratio: CGFloat!
        if (imgSize.width > imgSize.height)
        {
            ratio = maxSize.width / imgSize.width
        }
        else
        {
            ratio = maxSize.height / imgSize.height
        }
        let scaledSize = CGSize(width: imgSize.width * ratio, height: imgSize.height * ratio)
        var resizedImage = image.imageWithSize(scaledSize)
        if (imgSize.height > imgSize.width)
        {
            let left = (maxSize.width - resizedImage.size.width) / 2
            resizedImage = resizedImage.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -left, bottom: 0, right: 0))
            let imgAction = UIAlertAction(title: "", style: .default, handler: nil)
            imgAction.isEnabled = false
            imgAction.setValue(resizedImage.withRenderingMode(.alwaysOriginal),forKey:"image")
            self.addAction(imgAction)
        }
    }
}
