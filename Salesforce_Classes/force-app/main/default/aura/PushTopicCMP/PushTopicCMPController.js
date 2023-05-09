({
    initHandler : function(component, event, helper) {
        const empapi = component.find("empApi");
        empapi.onError(
            $A.getCallback(
                error => {
                    console.log("NO EMPAPI is Aviable in the Org");
                }
            )
        );
    },
    subscribeEmpApi : function(c , e , h){
        const empapi = c.find("empApi");
        const channel = "/topic/AccountChanges";
        const replayId = -1; 
        empapi.subscribe(channel,replayId , $A.getCallback( eventReceived => {
                let data = JSON.stringify(eventReceived);
                c.set("v.eventData",data);
            })).then(subscription => {
                let channelSub = JSON.stringify(subscription);
                c.set("v.channelSub",channelSub);
            });
    }
})
