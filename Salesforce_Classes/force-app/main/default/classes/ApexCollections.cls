public with sharing class ApexCollections {
   // When you have a qulified key for record ort a memeber the you a;lways to map
   // When you are trying to generate a new objects or members always to be a set
   // When you want to process the aggregations or processing all dependent members always to be List

   public static void listType(){
     //? How to add an Element or Member to collection --> add(element)
     //? How to read value ? : Iterators [you can also refer Index (not a good practice)]
     //? How to delete or replace a value ? based on INdex 
     List<string> names = new List<String>();
     // i have 100 values
     names.add('Lakshmi');
     names.add('Rupa');
     // for each 
     for(String loopVariable : names){
        system.debug(''+loopVariable);
     }

   }
    public void test(){
        getUserNames();
    }
   public static void getUserNames(){
        Map<String,String> users = new Map<String,String>();
        users = getUser();
        Integer i = 0;
        for(String loopVariable :users.values() ){
            system.debug(loopVariable.indexOf(loopVariable)+'.'+loopVariable);
            i++;
        }
   }

   private static map<String,String> getUser(){
    Map<String,String> names = new Map<String,String>();
        List<User> users = [SELECT Id , Name  FROM User ];
        for(User loopVariable : users){
            names.put(loopVariable.Name , loopVariable.Name);
        }
        return names;
   }
  
}