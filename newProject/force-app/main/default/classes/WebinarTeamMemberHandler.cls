/**
 * Created by trajic on 2/28/2022.
 */

public with sharing class WebinarTeamMemberHandler {

    public static void handleBeforeInsert(List<Webinar_Team_Member__c> newList) {
        typeExternalForContactAssignment(newList);
        setContactOrUser(newList);
       // availableSeat(newList);

        addCommentWhenRejected(newList);
    }
    public static void handleBeforeUpdate(Map<Id, Webinar_Team_Member__c> newMap, Map<Id, Webinar_Team_Member__c> oldMap) {
        typeExternalForContactAssignment(newMap.values());
        setContactOrUser(newMap.values());

        addCommentWhenRejected(newMap.values());
    }


    //contact when external
    private static void typeExternalForContactAssignment(List<Webinar_Team_Member__c> newList){
        Map<Id,Webinar__c> webinarsMap = new Map<Id, Webinar__c>([SELECT Id,Type__c FROM Webinar__c]);
        for (Webinar_Team_Member__c member : newList){
            if( webinarsMap.get(member.Webinar__c).Type__c != 'External' && member.Contact__c!= null)
                member.addError('Contact can be added only to webinar with type External');
        }
    }

    //webinar member can be contact or user not both
    public static void setContactOrUser(List<Webinar_Team_Member__c> newList){
        for(Webinar_Team_Member__c member : newList){
            if(member.Contact__c != null && member.User__c != null){
                member.addError('webinar member can be contact or user not both');
            }
        }
    }
    /* GRE{KA - STAVLJENO U WEBINAR
    public static void availableSeat(List<Webinar_Team_Member__c> newList){

        Map<Id, Webinar__c> webinarMap = new Map<Id, Webinar__c>([SELECT Id, Type__c FROM Webinar__c]);
        for(Webinar_Team_Member__c member : newList){
            if(webinarMap.get(member.Webinar__c).Number_of_Participants__c != null && webinarMap.get(member.Webinar__c).Total_Number_of_Seats__c != null){
                if(webinarMap.get(member.Webinar__c).Number_of_Participants__c + newList.size() > webinarMap.get(member.Webinar__c).Total_Number_of_Seats__c){
                    member.addError('There are no more available seats!');
                }
            }
        }
    }

     */

    //When Webinar Member has status Rejected the Comment field must be filled
    public static void addCommentWhenRejected(List<Webinar_Team_Member__c> newList){
        for (Webinar_Team_Member__c member : newList){
            if(member.Status__c == 'Rejected' && member.Comment__c == null){
                member.addError('You have to add a comment!');
            }
        }


    }

}