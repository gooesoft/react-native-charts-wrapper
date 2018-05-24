//
//  LargeValueFormatter.swift
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//
import Foundation
import Charts

extension Double {
  var cleanValue: String {
    let remainder = self.truncatingRemainder(dividingBy: 1)
    print("distanceFloat = ",remainder)
    return remainder == 0 ? String(format: "%.0f", self) : String(self)
  }
}

open class LargeValueFormatter: NSObject, IValueFormatter, IAxisValueFormatter
{
    fileprivate static let MAX_LENGTH = 5
    
    /// Suffix to be appended after the values.
    ///
    /// **default**: suffix: ["", "k", "m", "b", "t"]
    open var suffix = ["", "k", "m", "b", "t"]
  
    /// An appendix text to be added at the end of the formatted value.
    open var appendix: String?
    
    public override init()
    {
        
    }
    
    public init(appendix: String?)
    {
        self.appendix = appendix
    }
  
  
  fileprivate func formatImprovement(_ value: Double) -> String
  {
  
    var fValue : Double = 0.0
    var suffix : String = ""
    
    let absValue = Double(round(value))
    
    if absValue < 1000 {
        fValue = value
    } else if absValue >=  1000  && absValue < 1000000   {
      fValue = value / 1000
      suffix = "k";
    } else if absValue >= 1000000 && absValue < 1000000000 {
      fValue = value / 1000000
      suffix = "m"
    } else if absValue >= 1000000000 && absValue < 1000000000000 {
      fValue = value / 1000000000
      suffix = "b"
    } else if  absValue >= 1000000000000 {
      fValue = value / 1000000000000
      suffix = "t"
    }
    
    fValue = round(fValue * 10) / 10
    

    var r = fValue.cleanValue + suffix
    if appendix != nil
    {
      r += appendix!
    }

    
    return r
  }

  
    fileprivate func format(_ value: Double) -> String
    {
        var sig = value
        var length = 0
        let maxLength = suffix.count - 1
        
        while sig >= 1000.0 && length < maxLength
        {
            sig /= 1000.0
            length += 1
        }
   
        var r = String(format: "%2.f", sig) + suffix[length]
        
        if appendix != nil
        {
            r += appendix!
        }
        
        return r
    }
    
    open func stringForValue(
        _ value: Double, axis: AxisBase?) -> String
    {
        return formatImprovement(value)
    }
    
    open func stringForValue(
        _ value: Double,
        entry: ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: ViewPortHandler?) -> String
    {
        return format(value)
    }
}
