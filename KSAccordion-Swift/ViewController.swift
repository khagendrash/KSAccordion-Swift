//
//  ViewController.swift
//  KSAccordion-Swift
//
//  Created by Mac on 1/10/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

// constants
let screenSize: CGSize = UIScreen.main.bounds.size;
let TAG_FOR_INNER_VIEW: Int = 0;

class ViewController: UIViewController {
    
    // outlets for view reference
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // variable declarations or initializations
    var isExpanded: Bool = false
    var tagForRowTapped: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // offset position for row items to start
        var yValue: CGFloat = 30;
        
        // create row items and added to parent view(ScrollView)
        for i in 1...10{
            
            let row:RowItemView = Bundle.main.loadNibNamed("Accordion", owner: nil, options: nil)?[0] as! RowItemView
            row.frame = CGRect.init(x: 0, y: yValue, width: screenSize.width, height:row.bounds.size.height)
            row.tag = i
            
            self.scrollView.addSubview(row)
            
            row.lblTitle.text = "Row Number \(i)"
            
            row.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(toggleItemTapped(_:))))
            
            yValue += row.bounds.size.height;
        }
        
        // set content size to scrollview to make all child items visible
        self.scrollView.contentSize = CGSize.init(width: screenSize.width, height: yValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // handler to control a row item tapped or clicked
    func toggleItemTapped(_ gesture: UITapGestureRecognizer){
    
        let tagValue = gesture.view?.tag
        
        for view in self.scrollView.subviews{
            
            if view is RowItemView{
                // customize the item row (header tab) here
            }
        }
        
        if !isExpanded{
            
            // a header tab is not expanded yet
            isExpanded = true
            
            self.expandRowItem(tag:tagValue!)
        }
        else{
            
            // the accordion header tab is already expanded
            isExpanded = false
            
            if tagValue == tagForRowTapped{
                self.collapseRowItem(tag: tagForRowTapped)
            }
            else{
                self.collapseRowItem(tag: tagForRowTapped)
                
                let when = DispatchTime.now() + 0.3
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.expandRowItem(tag: tagValue!)
                }
                
                isExpanded = true
            }
        }
    }
    
    // collapse a row item
    func collapseRowItem(tag tagValue:Int){
        
        var rowTapped: RowItemView?
        var yValue: CGFloat = 0
        
        for subview in self.scrollView.subviews{
            
            // remove the inner view in deed
            for subview in self.scrollView.subviews{
                
                if (subview.tag == TAG_FOR_INNER_VIEW){
                    
                    var rect = subview.frame
                    rect.size.height = 0.0
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        subview.frame = rect
                    })
                }
            }
            
            if subview.tag == tagValue{
                rowTapped = subview as? RowItemView
                yValue = rowTapped!.frame.origin.y + rowTapped!.frame.size.height;
            }
            
            if subview.tag > tagValue{
                
                self.scrollView.bringSubview(toFront: subview)
                
                UIView.animate(withDuration: 0.2, animations: {
                    subview.frame = CGRect.init(x: 0, y: yValue, width: screenSize.width, height: (rowTapped?.frame.size.height)!)
                    
                    yValue = yValue + (rowTapped?.frame.size.height)!;
                })
            }
        }
        
        self.scrollView.contentSize = CGSize.init(width: screenSize.width, height: yValue)
    }
    
    // expands a row item
    func expandRowItem(tag tagValue:Int){
    
        var yValue: CGFloat = 0
        
        var rowTapped: RowItemView?
        tagForRowTapped = tagValue
        
        for subview in self.scrollView.subviews{
            
            if subview.tag == TAG_FOR_INNER_VIEW{
                subview.removeFromSuperview()
            }
            
            if subview.tag == tagValue{
                
                rowTapped = subview as? RowItemView
                yValue = rowTapped!.frame.origin.y + rowTapped!.frame.size.height;
            }
        }
        
        
        let innerView = self.getInnerViewContent(y:yValue)
        var rect = innerView.frame
        rect.size.height = 200.0
        
        UIView.animate(withDuration: 0.3, animations: {
            innerView.frame = rect
        })
        
        yValue = yValue + innerView.frame.size.height;
    
        self.scrollView.addSubview(innerView)
        
        
        for subview in self.scrollView.subviews{
        
            if (subview.tag > tagValue){
                
                self.scrollView.bringSubview(toFront: subview)
                
                UIView.animate(withDuration: 0.3, animations: {
                    subview.frame = CGRect.init(x: 0, y: yValue, width: screenSize.width, height: (rowTapped?.frame.size.height)!)
                })
                
                yValue = yValue + (rowTapped?.frame.size.height)!;
            }
        }
        
        self.scrollView.contentSize = CGSize.init(width: screenSize.width, height: yValue)
    }
    
    // create view for inner content for accordion header items
    func getInnerViewContent(y yPos: CGFloat) -> UIView{
        
        let content: UIView = UIView.init(frame: CGRect.init(x: 0.0, y: yPos, width: screenSize.width, height: 0.0))
        content.tag = TAG_FOR_INNER_VIEW
        content.backgroundColor = UIColor.lightGray
        
        return content
    }
}

