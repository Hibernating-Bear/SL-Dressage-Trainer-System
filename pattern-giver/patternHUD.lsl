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

//Initialisation 
init () {
    
    // make sure the file exists and is a notecard
    if(llGetInventoryType(configFile) != INVENTORY_NOTECARD)
    {
        // notify owner of missing file
        llOwnerSay("Missing inventory Notecard: " + configFile);
        return; // don't do anything else
    }
 
    // initialize to start reading from first line
    line = 0;
 
    // read the first line
    readLineID = llGetNotecardLine(configFile, line++);
 
}

processConfiguration(string data)
{
    // End of Configuration File
    if(data == EOF)
    {
        string commandStatus;
        string touchStatus;
        // Tell Owner What was Loaded
        llOwnerSay("System Initialised");
 
        // When Done Sending Config Values, Exit Sub-Routine
        llListen(channelID,"", NULL_KEY, "");
        return;
    }
 
    // if we are not working with a blank line
    if(data != "")
    {
        // if the line does not begin with a comment
        if(llSubStringIndex(data, "#") != 0)
        {
            // find first equal sign
            integer i = llSubStringIndex(data, "=");
 
            // if line contains equal sign
            if(i != -1)
            {
                // get name of name/value pair
                string name = llGetSubString(data, 0, i - 1);
 
                // get value of name/value pair
                string value = llGetSubString(data, i + 1, -1);
 
                // trim name
                list temp = llParseString2List(name, [" "], []);
                name = llDumpList2String(temp, " ");
 
                // make name lowercase (case insensitive)
                name = llToLower(name);
 
                // trim value
                temp = llParseString2List(value, [" "], []);
                value = llDumpList2String(temp, " ");
 
                // Parse Value in Config to Variable in Script
                    // Command Channel
                    if(name == "channelid"){
                        channelID = (integer)value;
                    }
                    // Command Name
                    else if(name == "cmdhudtune"){
                        cmdHUDTune = value;
                    }
                    // Unlock Command
                    else if(name == "unlockcmd"){
                        unlockCommand = value;
                    }
                    // Lock Command
                    else if(name == "lockcmd"){
                        lockCommand = value;
                    }
                    // Bow Animation
                    else if (name == "bowani"){
                        bowAni = value;
                    }
                    //Whip Sound
                    else if (name == "whipsound"){
                        whipSound = value;   
                    }    
                    //Whip Message Enabled
                    else if (name == "whipmsgenabled"){
                        string tempValue = llToLower(value);
                        if (tempValue == "true"){
                            whipMsgEnabled = TRUE;
                        }
                        else{
                            whipMsgEnabled = FALSE;
                        }    
                    }
                    //Whip Message
                    else if (name == "whipmsg"){
                        whipMsg = value;    
                    }    
                    
                    
                    
                    // Unknown Config Value    
                    else{
                        llOwnerSay("Unknown configuration value: " + name + " on line " + (string)line);
                    }
            }
            else  // Line has no Equals (=) Sign
            {
                llOwnerSay("Configuration could not be read on line " + (string)line);
            }
        }
    }
 
    // Read Next Line in Config File
    readLineID = llGetNotecardLine(configFile, line++);
 
}

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

default
{ 
    state_entry() {
        init();
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
        init();         
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
        
        if (id == idCom && llToLower(message) == llToLower(cmdHUDTune)) {
            gListener = llListen( returnChannel, "", "", "");
            llTextBox(id, "Please type the ID of the Pattern Giver you wish to Tune Your HUD to.\nCurrently Tuned to: " + hudID, returnChannel);
        }
        if (id == idCom && channel == returnChannel) {
            llOwnerSay((string)id);
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
                for (; i < 5; ++i){
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
        if(request_id == readLineID)
            processConfiguration(data);
 
    } 
    
}
