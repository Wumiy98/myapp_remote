//
//  Diary.swift
//  myapp
//
//  Created by 吴明翔翔翔 on 2023/3/7.
//

import Foundation

import CoreData

public class Diary: NSManagedObject,Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var diaryDate: Date
    @NSManaged public var mood_index: Double
    @NSManaged public var mytext: String
    @NSManaged public var weather: String
}


class TabBarStore: ObservableObject {
    @Published var isHidden = false
}
