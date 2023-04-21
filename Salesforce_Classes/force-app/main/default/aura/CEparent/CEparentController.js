({
    handleEvent : function(component, event, helper) {
        alert("Parent handler");
        helper.handleEventHelper(component, event, helper);
    },
    callChild : function(component , event){
        let cmpMetaData = component.find("childId");
        alert("_-- : "+cmpMetaData.length);
        debugger;
        let result = true;
        for(let i = 1 ; i <= cmpMetaData.length ; i++){
            let _activity = component.find("outputv").get("v.value");
            
            let childOutcome  = cmpMetaData.childMethodName(""+i);
            if(result){
                result = childOutcome;
            }
         
        }
        
        alert("Final Result : " + result);
        
    }
})