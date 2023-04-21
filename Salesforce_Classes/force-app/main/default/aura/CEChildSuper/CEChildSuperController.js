({
    handleEvent : function(component, event, helper) {
        alert("child Super");
        let sValue = event.getParam("searchValue");
       if(sValue === 'a'){
        alert("STopped");
        event.stopPropagation();
       }
    }
})