public with sharing class DemoClass {
    public static String userName; // declaration ( Default Value = NULL )
    public  String userPhone; // declaration ( Default Value = NULL )
    public static String userEmail = ''; // Intialization 
    public static List<User> users = [SELECT Id , Name FROM User ]; // Not a good practice 
    private static DemoClass instanceVar;
    public static Account acc;
    public static DemoWrraper childWrap;
    public static string apexProper{ 
        get{
            return apexProper;
        }
        private set{
            apexProper = value;
        }
    }
    public static Account accProper{ 
        get{
            return acc;
        }
        private set{
            accProper = value;
        }
    }
   
   
    // to access class variable what I need to use : ClassName.StaticVariableName
    static{
        userName = 'Random';
        // soqls , conditions 
        apexProper = userName; 
        acc = new Account();
        acc.Name = 'Prakash';
        accProper = acc;
    }
    public DemoClass(){
       // No-Argument Constructor 
    }
    public DemoClass(String userName,String userPhone){
        DemoClass.userName = userName;
        this.userPhone = userPhone;
        instanceVar = this;
    }
    public DemoClass(String userPhone ,String userName , Boolean isValid){
        DemoClass.userName = userName;
        this.userPhone = userPhone;
        instanceVar = this;
    }

    public static String userName(){
        return userName;
    }
    public static String userPhone(){
         return instanceVar.userPhone;
    }
     public void userEmail(){

    }

   

}