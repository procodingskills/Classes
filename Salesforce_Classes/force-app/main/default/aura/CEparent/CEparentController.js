({
    handleEvent : function(component, event, helper) {
        alert("Parent handler");
        helper.handleEventHelper(component, event, helper);
    }
})
