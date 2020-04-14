//
//  CLPopupFoodPickerModel.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/4/13.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SwiftyJSON

struct CLPopupFoodPickerModel {
    var baseGroup = [CLPopupFoodPickerBaseGroup]()
    init(json: JSON) {
        baseGroup = json["baseGroup"].arrayValue.compactMap({ CLPopupFoodPickerBaseGroup(json: $0)})
    }
}

struct CLPopupFoodPickerNutrients {
    var Val: String?
    var MUFA: String?
    var Ca: String?
    var Edible: String?
    var leu: String?
    var Arg: String?
    var Lle: String?
    var Ser: String?
    var Mg: String?
    var SFA: String?
    var Thr: String?
    var Met: String?
    var PUFA: String?
    var lys: String?
    var Trp: String?
    var Asp: String?
    var Energy: String?
    var Pro: String?
    var Protein: String?
    var Phe: String?
    var Na: String?
    var Ala: String?
    var Water: String?
    var Fat: String?
    var CHO: String?
    var P: String?
    var K: String?
    var Glu: String?
    var Cys: String?
    var Tyr: String?
    var His: String?
    var Dietaryfiber: String?
    var Fe: String?
    var Gly: String?

    init(json: JSON) {
        Val = json["Val"].stringValue
        MUFA = json["MUFA"].stringValue
        Ca = json["Ca"].stringValue
        Edible = json["Edible"].stringValue
        leu = json["leu"].stringValue
        Arg = json["Arg"].stringValue
        Lle = json["Lle"].stringValue
        Ser = json["Ser"].stringValue
        Mg = json["Mg"].stringValue
        SFA = json["SFA"].stringValue
        Thr = json["Thr"].stringValue
        Met = json["Met"].stringValue
        PUFA = json["PUFA"].stringValue
        lys = json["lys"].stringValue
        Trp = json["Trp"].stringValue
        Asp = json["Asp"].stringValue
        Energy = json["Energy"].stringValue
        Pro = json["Pro"].stringValue
        Protein = json["Protein"].stringValue
        Phe = json["Phe"].stringValue
        Na = json["Na"].stringValue
        Ala = json["Ala"].stringValue
        Water = json["Water"].stringValue
        Fat = json["Fat"].stringValue
        CHO = json["CHO"].stringValue
        P = json["P"].stringValue
        K = json["K"].stringValue
        Glu = json["Glu"].stringValue
        Cys = json["Cys"].stringValue
        Tyr = json["Tyr"].stringValue
        His = json["His"].stringValue
        Dietaryfiber = json["Dietaryfiber"].stringValue
        Fe = json["Fe"].stringValue
        Gly = json["Gly"].stringValue
    }
}

struct CLPopupFoodPickerFoods {
    var foodId: String?
    var foodName: String?
    var nutrients: CLPopupFoodPickerNutrients?

    init(json: JSON) {
        foodId = json["foodId"].stringValue
        foodName = json["foodName"].stringValue
        nutrients = CLPopupFoodPickerNutrients(json: json["nutrients"])
    }
}

struct CLPopupFoodPickerGroup {
    var foodGroupId: String?
    var foods = [CLPopupFoodPickerFoods]()
    var foodGroupName: String?

    init(json: JSON) {
        foodGroupId = json["foodGroupId"].stringValue
        foods = json["foods"].arrayValue.compactMap({ CLPopupFoodPickerFoods(json: $0)})
        foodGroupName = json["foodGroupName"].stringValue
    }
}

struct CLPopupFoodPickerBaseGroup {
    var group = [CLPopupFoodPickerGroup]()
    var foodBaseGroupName: String?

    init(json: JSON) {
        group = json["group"].arrayValue.compactMap({ CLPopupFoodPickerGroup(json: $0)})
        foodBaseGroupName = json["foodBaseGroupName"].stringValue
    }
}

