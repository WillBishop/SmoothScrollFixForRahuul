//
//  StudentClass.swift
//  ClassRoom Attendance
//
//  Created by Rahul Roy on 13/05/22.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class Student: Object, Identifiable
{
    @Persisted var name: String = ""
    @Persisted var email: String = ""
    @Persisted var roll: String = ""
    @Persisted var isPresent: Bool = false
    @Persisted var image: Data?
    convenience init(name: String, email: String, roll: String, isPresent: Bool)
    {
        self.init()
        self.name = name
        self.email = email
        self.roll = roll
        self.isPresent = isPresent
    }
    override static func primaryKey() -> String? {
        return "roll"
    }
}

class Section: Object, Identifiable
{
    @Persisted var sec: String = ""
    @Persisted var students = List<Student>()
    convenience init(sec: String)
    {
        self.init()
        self.sec = sec
    }
    override static func primaryKey() -> String? {
        return "sec"
    }
}

let sections = realm.objects(Section.self)
