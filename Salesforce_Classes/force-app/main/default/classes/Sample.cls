public class Sample {
   
    /*
    1. Class variables
        a. Static Variables
        b. Non-Static Variables
    2. Methods
        a. Static Methods 
        b. Non-Static Methods
    3. Properties 
        a. Static Property
        b. Non-Static Property
    4. Contructors
        ClassName obj = new Contructor();
    5. SIB : Static Intialization Block
    6. IIB : Instance Intialization Block
     */
    // To define anything within the class (Public , Private , Global and Protected)
        // AccessSpecifier Static || Non-Static DataType variable|Method|Prperty
    public static  String userName{private set; public get;} // Declaration
    public static String userEmail = null; // Intialization
    public static Boolean isActive = null ; // Intialization

    public static String userAlias {get;set;}

    public static String userPreference{
        get{
            return userPreference ;
        }
        set {
            userPreference = value;
        }
    }

    public static Integer getSum(Integer number1 , Integer number2){
        return number1 + number2;
    }
    public static Decimal getSum(List<Decimal> numbers){
            Decimal result = 0;
            // Iterators for loops
            for(Decimal forLoopVariable : numbers ){
                result = result + forLoopVariable;
            }

        return result;
    }
    /*
        1. How can add valu4es to collection 
            .add()
     */
    public Sample(){
        system.debug('I am constructor');
    }
     static{
        system.debug('Static1');
        userName = 'Lakshmi Deepak0';
     }
     static{
        userName = 'Lakshmi Deepak1';
        system.debug('Static2');

     }
     static{
        userName = 'Lakshmi Deepak2';
        system.debug('Static3');
     }
     // IIB
     {
        system.debug('IIB1');

     }
     {
        system.debug('IIB2');
     }

}