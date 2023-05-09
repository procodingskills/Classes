public with sharing class Recursion {
    public static Boolean isRan = false;
    public static boolean isValid(){
        if(isRan){
            return false;
        }
        isRan = true;
        return !isRan;
    }
}