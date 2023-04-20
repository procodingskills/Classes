({
    getUserName : function(component) {
        // What is the action that you want to call from JS
        let serverAction = component.get("c.getUserName");
        // Do we have arguments that we need to pass ?
        serverAction.setParams({});
        // create a Callback handler
        serverAction.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                let data = response.getReturnValue();
                component.set("v.userName", data);
            }
            else{
                alert("ERROR : "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(serverAction);
    },
    callServerType2 : function(component , event , helper){
        helper.callServer(component , event , helper , "getUserName" , {})
        .then(
            // resolver handler
            $A.getCallback(function(result){
               component.set("v.userName",result);
            }),
            // Reject Handler
            $A.getCallback(function(error){
                alert("ERROR : "+JSON.stringify(error));
            })
        )
        .catch(function(error){
            alert("ERROR at promise : "+JSON.stringify(error));
        });
    },
    callServer : function(component , event , helper , apexAction , params){
        let p = new Promise(
        $A.getCallback(
            function(resolve , reject){
                let action = component.get("c."+apexAction);
                action.setParams(params);
                action.setCallback(this,function(callBackResults){
                    let callBackState = callBackResults.getState();
                    if(callBackState === "SUCCESS"){
                        resolve(callBackResults.getReturnValue());
                    }
                    else if(callBackState === "ERROR"){
                        reject(callBackResults.getError());
                    }
                });
                $A.enqueueAction(action);
            })
       );
       return p;
    }
})
