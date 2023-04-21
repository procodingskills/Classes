({
    invokeEventPublisher : function(component, event, helper) {
        helper.invokeEventPublisherHelper(component, event, helper);
    },
    
    childMethodName : function(component , event , helper){
        let _activity = event.getParam('arguments');
        debugger;
        if(_activity.activity == "1"){
            return true;
        }
        else{
            return false;
        }
    }
})