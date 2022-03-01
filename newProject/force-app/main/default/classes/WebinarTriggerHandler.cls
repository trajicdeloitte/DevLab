/**
 * Created by trajic on 2/28/2022.
 */

public with sharing class WebinarTriggerHandler {
    // *** Handlers ***

    public static void handleBeforeInsert(List<Webinar__c> newList) {
        approveWebinarUnder100e(newList);
       cancelRejectedWebinars(newList);
        pricePerParticipant(newList);
       checkNumOfSeats(newList);
    }
    /*
    public static void handleAfterInsert(Map<Id, Case> newMap) {
        //createRelatedObject(newMap);


    }
*/
    public static void handleBeforeUpdate(Map<Id, Webinar__c> newMap, Map<Id, Webinar__c> oldMap) {
        //modifyBasicDataForTechnicalCases(newMap.values(), oldMap, false);
        cancelRejectedWebinars(newMap.values());
        pricePerParticipant(newMap.values());
        checkNumOfSeats(newMap.values());
        statusValue(newMap,oldMap);
    }

/*
    public static void handleBeforeUpdate(Map<Id, Webinar__c> newMap, Map<Id, Webinar__c> oldMap) {
        //modifyBasicDataForTechnicalCases(newMap.values(), oldMap, false);
        cancelRejectedWebinars(newMap);
    }
    public static void handleAfterUpdate(Map<Id, Case> newMap, Map<Id, Case> oldMap) {
        updateRelatedObject(newMap, oldMap);
    }

    public static void handleAfterDelete(Map<Id, Case> oldMap) {

    }

    public static void handleAfterUndelete(Map<Id, Case> newMap) {

    }

    // *** Logic ***

    private static void setUpBasicDataForTechnicalCases(List<Case> newList) {
        //logic here
    }

    private static void createRelatedObject(Map<Id, Case> newMap) {
        //logic here
    }

    private static void modifyBasicDataForTechnicalCases(List<Case> newList, Map<Id, Case> newMap, Boolean technicalFlag) {
        //logic here
    }

    private static void updateRelatedObject(Map<Id, Case> newMap, Map<Id, Case> oldMap) {
        //logic here
    }
    */
    private static void approveWebinarUnder100e(List<Webinar__c> webinarsList){
        for(Webinar__c webinar : webinarsList){
            if(webinar.Cost__c < 100){
                webinar.Approval_Status__c = 'Approved';
            }
        }
    }

    private static void cancelRejectedWebinars (List<Webinar__c> newList){
        for(Webinar__c webinar : newList){
            if(webinar.Approval_Status__c == 'Rejected'){
                webinar.Status__c = 'Canceled';
            }
        }
    }

    //seats
    private static void checkNumOfSeats(List<Webinar__c> newList){
        for (Webinar__c webinar : newList){
            if(webinar.Number_of_Participants__c > webinar.Total_Number_of_Seats__c){
                webinar.addError('The number of participants can not exceed seats');
            }
        }

    }

    //The price per participant is calculated automatically
    private static void pricePerParticipant(List<Webinar__c> newList){
        for(Webinar__c webinar : newList){
            if(webinar.Cost__c != null && webinar.Number_of_Participants__c != null && webinar.Cost__c != 0 && webinar.Number_of_Participants__c != 0){
                webinar.Price_per_participant__c = webinar.Cost__c / webinar.Number_of_Participants__c;

            }


        }
    }

    //As soon as the status changes the value from New to anything else (except for Canceled) the
    //value of Approval Status cannot be Pending any longer

    private static void statusValue(Map<Id,Webinar__c> newMap, Map<Id,Webinar__c> oldMap){
        for(Webinar__c webinar : newMap.values()){
            if(oldMap.get(webinar.Id).Status__c == 'New'  && webinar.Status__c != 'Canceled' && webinar.Status__c != 'New' && webinar.Approval_Status__c == 'Pending'){
                webinar.addError('Status can not be pending now.');
            }
        }


    }

}