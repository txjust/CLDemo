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
    var Tyr: String?
    var Water: String?
    var Val: String?
    var Edible: String?
    var P: String?
    var Ca: String?
    var Mg: String?
    var Gly: String?
    var Arg: String?
    var Energy: String?
    var CHO: String?
    var Thr: String?
    var Trp: String?
    var Fat: String?
    var lys: String?
    var Dietaryfiber: String?
    var K: String?
    var Na: String?
    var His: String?
    var Fe: String?
    var Ser: String?
    var Ala: String?
    var Asp: String?
    var leu: String?
    var Cys: String?
    var Lle: String?
    var SFA: String?
    var Phe: String?
    var Met: String?
    var PUFA: String?
    var Protein: String?
    var Glu: String?
    var MUFA: String?
    var Pro: String?

    init(json: JSON) {
        Tyr = json["Tyr"].stringValue
        Water = json["Water"].stringValue
        Val = json["Val"].stringValue
        Edible = json["Edible"].stringValue
        P = json["P"].stringValue
        Ca = json["Ca"].stringValue
        Mg = json["Mg"].stringValue
        Gly = json["Gly"].stringValue
        Arg = json["Arg"].stringValue
        Energy = json["Energy"].stringValue
        CHO = json["CHO"].stringValue
        Thr = json["Thr"].stringValue
        Trp = json["Trp"].stringValue
        Fat = json["Fat"].stringValue
        lys = json["lys"].stringValue
        Dietaryfiber = json["Dietaryfiber"].stringValue
        K = json["K"].stringValue
        Na = json["Na"].stringValue
        His = json["His"].stringValue
        Fe = json["Fe"].stringValue
        Ser = json["Ser"].stringValue
        Ala = json["Ala"].stringValue
        Asp = json["Asp"].stringValue
        leu = json["leu"].stringValue
        Cys = json["Cys"].stringValue
        Lle = json["Lle"].stringValue
        SFA = json["SFA"].stringValue
        Phe = json["Phe"].stringValue
        Met = json["Met"].stringValue
        PUFA = json["PUFA"].stringValue
        Protein = json["Protein"].stringValue
        Glu = json["Glu"].stringValue
        MUFA = json["MUFA"].stringValue
        Pro = json["Pro"].stringValue
    }
}

struct CLPopupFoodPickerFoods {
    var foodName: String?
    var foodId: String?
    var nutrients: CLPopupFoodPickerNutrients?

    init(json: JSON) {
        foodName = json["foodName"].stringValue
        foodId = json["foodId"].stringValue
        nutrients = CLPopupFoodPickerNutrients(json: json["nutrients"])
    }
}

struct CLPopupFoodPickerGroup {
    var foodGroupName: String?
    var foodGroupId: String?
    var foods = [CLPopupFoodPickerFoods]()

    init(json: JSON) {
        foodGroupName = json["foodGroupName"].stringValue
        foodGroupId = json["foodGroupId"].stringValue
        foods = json["foods"].arrayValue.compactMap({ CLPopupFoodPickerFoods(json: $0)})
    }
}

struct CLPopupFoodPickerBaseGroup {
    var foodBaseGroupName: String?
    var group = [CLPopupFoodPickerGroup]()

    init(json: JSON) {
        foodBaseGroupName = json["foodBaseGroupName"].stringValue
        group = json["group"].arrayValue.compactMap({ CLPopupFoodPickerGroup(json: $0)})
    }
}
