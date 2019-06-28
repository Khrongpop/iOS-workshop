//
//  Article.swift
//  iOS-workshop
//
//  Created by Muang on 27/6/2562 BE.
//  Copyright © 2562 ict. All rights reserved.
//

import Foundation
struct Article: Codable {
    var id : Int
    var title : String
    var detail : String
    var image : String?
    var created_at : String
}
