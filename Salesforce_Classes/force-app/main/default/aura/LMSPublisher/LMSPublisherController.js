({
    notifyLMS : function(component, event, helper) {
        let b = {messageToSend : 'Random',sourceSystem : 'source'};
        component.find("lmsid").publish(b);
        alert("Published");
    }
})