//
//  ParserFactory.swift
//  BanHuuDuongXa
//
//  Created by Nguyen Minh Khanh on 6/6/16.
//  Copyright © 2016 Poeta Digital. All rights reserved.
//

import UIKit
import ObjectMapper


class ParserFactory<T:BaseMappable>: NSObject {
    
    func entity(_ dic:[String : Any])->T?{
        let entity = Mapper<T>().map(JSON: dic)
        return entity
    }
    
    func entity(jsonString:String)->T?{
        let entity = Mapper<T>().map(JSONString: jsonString)
        return entity
    }
    
    func entity(from fileName:String)->T?{
        let entity = Mapper<T>().map(JSONfile: fileName)
        return entity
    }
    
    func entities(_ list:[[String : Any]])->[T]?{
        return Mapper<T>().mapArray(JSONArray: list)
    }
    
    func entities(from fileName:String)->[T]?{
        return Mapper<T>().mapArray(JSONfile: fileName)
    }
    
    func toDic(_ entity:T)->[String:Any]?{
        return Mapper<T>().toJSON(entity)
    }
    
    func toDic(_ entities:[T])->[[String:Any]]?{
        return Mapper<T>().toJSONArray(entities)
    }
    
    func toString(_ entity:T)->String?{
        return Mapper<T>.toJSONString(entity, prettyPrint: false)
    }
    
    func toString(_ entities:[T])->String?{
        return Mapper<T>.toJSONString(entities, prettyPrint: false)
    }

    func copyItem(item:T)->T?{
        let dic = item.toJSON()
        if let copyItem = ParserFactory<T>().entity(dic)
        {
            return copyItem
        }
        return nil
    }
}


