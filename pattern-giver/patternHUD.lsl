//Silent Dressage Random Pattern Giver HUD
//by Bear(bearaus)
//Created 5 September 2018
//

//You are free to use this code, or modify it, but please acknowledge 
//and let the original author if you do make changes.


//Global Variables

//Channel to Listen for Commands on
integer channelID;

//Command to Tune HUD
string cmdHUDTune;

//Unlock Command
string unlockCommand;
//Lock Command
string lockCommand;

//HUD Settings
integer hudChannel = -2784831;
string hudID;

//Notecard Configuration Variables
integer line;
string configFile = "patternHUD.cfg";
key readLineID;
integer loaded = FALSE;

//Whip Settings
string whipSound;
integer whipMsgEnabled;
string whipMsg;

//Bow Animation
string bowAni;

//Variables
integer returnChannel = -2784832;
integer gListener;
key id;
string userID;
list currentPattern;
integer hudListenerCom;
key globalUserID;


string left(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, index, -1);
    return src;
}

string right(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, 0, index + llStringLength(divider) - 1);
    return src;
}

string uniqueUserID(key id) {
    string name = llKey2Name(id);
    string nameID = (string)id;
    string lastName = right(name, " ");
    string uniqueNum = llGetSubString(nameID, 0, 7);
    string first = llGetSubString(name, 0, 0);
    string second = llGetSubString(lastName, 0, 0);
    string firstSecond = uniqueNum + first + second;
    return firstSecond;
}
hudClear(){
    integer d = 0;
    integer dis;
    key bID;
    for (d=0; d < 5; ++d){ 
        dis = d + 1;
        llMessageLinked(LINK_ALL_CHILDREN, 0, (string)dis + "|blank", bID);
    }
}

default
{ 
    state_entry() {
        currentPattern = [];
        id = llGetOwner();
        globalUserID = id;
        userID = uniqueUserID(id);
        hudID = userID + "HUD";
        llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
        hudListenerCom = llListen(hudChannel,"", NULL_KEY, "");
        
    }

    
     on_rez(integer start_param)
    {
        llResetScript();       
    }
    listen(integer channel, string name, key id, string message) {
        
        key idCom = llGetOwner();
        if (id == idCom && llToLower(message) == llToLower(lockCommand)){
            llListenRemove(hudListenerCom);  
            llOwnerSay("HUD Locked");  
        }
        if (id == idCom && llToLower(message) == llToLower(unlockCommand)){
            hudListenerCom = llListen(hudChannel,"", NULL_KEY, "");
            llOwnerSay("HUD Unlocked");
            
        }
        if (id == idCom && llToLower(message) == "settings"){
        llRegionSayTo(id, 0, "\nCurrent Settings\n\n\nCommand Channel: " + (string)channelID + "\nTune HUD Command: " + cmdHUDTune + "\nLock HUD Command: " + lockCommand + "\nUnlock HUD Command: " + unlockCommand + "\nHUD Tuned to: " + hudID);
        }
        if (id == idCom && llToLower(message) == "reset"){
            llOwnerSay("HUD Resetting");
            hudClear();
            llResetScript();
        }
        if (id == idCom && llToLower(message) == "clear"){
            llOwnerSay("Clearing Pattern");
            hudClear();
        }
        
        if (id == idCom && llToLower(message) == llToLower(cmdHUDTune)) {
            gListener = llListen( returnChannel, "", "", "");
            llTextBox(id, "Please type the ID of the Pattern Giver you wish to Tune Your HUD to.\nCurrently Tuned to: " + hudID, returnChannel);
        }
        if (id == idCom && channel == returnChannel) {
            llListenRemove(gListener);
            hudID = llStringTrim(message,STRING_TRIM);
            llOwnerSay("HUD Tuned to: " + hudID);
        }
        if (channel == hudChannel) {
            string incomingID = left(message, "|");
            if (incomingID == hudID) {
                currentPattern = llParseString2List(message, ["|"],[]);
                integer i = 0;
                integer discip = 0;
                integer letter = 0;
                integer order = 0;
                key aID;
                for (i=0; i < 5; ++i){
                    order = 1 + i;                    
                    discip = (2 * i) + 1;
                    letter = (2 * i) + 2;
                    llMessageLinked(LINK_ALL_CHILDREN, 0, (string)order + "|" + llList2String(currentPattern,discip) + llList2String(currentPattern,letter), aID);
                }
            }
        }
    }
    

    
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if (msg == "bow"){
            llStartAnimation(bowAni); 
        }
        if (msg == "whip"){
            llTriggerSound(whipSound, 1.0);
            if (whipMsgEnabled == TRUE){
                llSay(0, llGetDisplayName(globalUserID) + " " + whipMsg);
            }
        } 
    }
    
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY) init();
        else if(change & CHANGED_OWNER) init();
    }
    dataserver(key request_id, string data)
    {
        if(request_id == readLineID){
            if(data!=EOF){
                list lList=llParseString2List(data,[" = "," "],[]);
                if(llList2String(lList,0)=="#") {}//Ignore
                else if(llList2String(lList,0) == "channelID"){
                    channelID = llList2Integer(lList,1);
                
                }else if(llList2String(lList,0) == "cmdHUDTune"){
                    cmdHUDTune=llList2String(lList,1);
                }else if(llList2String(lList,0) == "lockCommand"){
                    lockCommand=llList2String(lList,1);
                }else if(llList2String(lList,0) == "unlockCommand"){
                    unlockCommand=llList2String(lList,1);
                }else if(llList2String(lList,0) == "lockCommand"){
                    lockCommand=llList2String(lList,1);
                }else if(llList2String(lList,0) == "bowAni"){
                    bowAni=llList2String(lList,1);
                }else if(llList2String(lList,0) == "whipSound"){
                    whipSound=llList2String(lList,1);
                }else if(llList2String(lList,0) == "whipMsg"){
                    whipMsg=llList2String(lList,1);
                }else if(llList2String(lList,0) == "whipMsgEnabled"){
                    if(llToLower(llList2String(lList,1))=="true"){
                        whipMsgEnabled=TRUE;
                    }else
                        whipMsgEnabled=FALSE;
                }
                readLineID = llGetNotecardLine(configFile,line++);
            } else {
                llListen(channelID, "", "", "");
                llOwnerSay("System Initialized");
            }
        }
 
    } 
    
}
