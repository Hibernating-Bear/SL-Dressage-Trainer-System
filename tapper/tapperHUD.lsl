//Tapper HUD
//by Bear(bearaus)
//Created 18 September 2018
//

//This code is licenced under the GNU GPL v2.0
//If you wish to view the code on GitHub the repository is at
//https://github.com/Hibernating-Bear/SL-Dressage-Trainer-System
//
//If you do modify the code, please let the original author know or fork the code
//on GitHub.


//Global Variables

//Channel to Listen for Commands on
integer channelID;

//Change Mode Whip
string cmdWhip;
//Change Mode Tap
string cmdTap;

//Mode
string curMode;

//Toggle Chat Output
string cmdToggle;
string chatStatus;

//Notecard Configuration Variables
integer line;
string configFile = "tapper.cfg";
key readLineID;
integer loaded = FALSE;

//Whip Settings
string whipSound;
string oneWhip;
string twoWhip;
string threeWhip;
string fourWhip;
string fiveWhip;

//Tap Settings
string tapSound;
string oneTap;
string twoTap;
string threeTap;
string fourTap;
string fiveTap;


//Variables
key id;
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



default
{ 
    state_entry() {
        id = llGetOwner();
        globalUserID = id;
        init();
        llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
        
    }

    
     on_rez(integer start_param)
    {
        llResetScript();       
    }
    listen(integer channel, string name, key id, string message) {
        
        key idCom = llGetOwner();
        if (id == idCom && llToLower(message) == llToLower(cmdWhip)){ 
            llMessageLinked(LINK_ALL_CHILDREN, 0, "change2Whip", "");
            llOwnerSay("Set to Whip Mode");  
        }
        if (id == idCom && llToLower(message) == llToLower(cmdTap)){
            llMessageLinked(LINK_ALL_CHILDREN, 0, "change2Tap", "");
            llOwnerSay("Set to Tap Mode");
        }
        if (id == idCom && llToLower(message) == llToLower(chatToggle)){
            llMessageLinked(LINK_ALL_CHILDREN, 0, "chatToggle", "");
            if (chatStatus == "Showing"){
            
            }else{
            
            }
            llOwnerSay("Chat Toggle");
        }
        if (id == idCom && llToLower(message) == "settings"){
            llRegionSayTo(id, 0, "\nCurrent Settings\n\nCommand Channel: " + (string)channelID + "\nChange to Whip: " + cmdWhip + "\nChange to Tap: " + cmdTap + "\nToggle Chat Output: " + chatToggle + "\nChat Output: " + chatStatus);
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
        if(change & CHANGED_INVENTORY) llResetScript();
        else if(change & CHANGED_OWNER) llResetScript();
    }
    dataserver(key request_id, string data)
    {
        if(request_id == readLineID){
            if(data!=EOF){
                list lList=llParseString2List(data, [" = "], ["#"]);
                if(llList2String(lList,0)=="#") {}//Ignore
                else if(llList2String(lList,0) == "channelID"){
                    channelID = llList2Integer(lList,1);
                }else if(llList2String(lList,0) == "cmdWhip"){
                    cmdWhip=llList2String(lList,1);
                }else if(llList2String(lList,0) == "cmdTap"){
                    cmdTap=llList2String(lList,1);
                }else if(llList2String(lList,0) == "cmdToggle"){
                    cmdToggle=llList2String(lList,1);
                }else if(llList2String(lList,0) == "whipSound"){
                    whipSound=llList2String(lList,1);
                }else if(llList2String(lList,0) == "oneWhip"){
                    oneWhip=llList2String(lList,1);
                }else if(llList2String(lList,0) == "twoWhip"){
                    twoWhip=llList2String(lList,1);
                }else if(llList2String(lList,0) == "threeWhip"){
                    threeWhip=llList2String(lList,1);
                }else if(llList2String(lList,0) == "fourWhip"){
                    fourWhip=llList2String(lList,1);
                }else if(llList2String(lList,0) == "fiveWhip"){
                    fiveWhip=llList2String(lList,1);
                }else if(llList2String(lList,0) == "tapSound"){
                    tapSound=llList2String(lList,1);
                }else if(llList2String(lList,0) == "oneTap"){
                    oneTap=llList2String(lList,1);
                }else if(llList2String(lList,0) == "twoTap"){
                    twoTap=llList2String(lList,1);
                }else if(llList2String(lList,0) == "threeTap"){
                    threeTap=llList2String(lList,1);
                }else if(llList2String(lList,0) == "fourTap"){
                    fourTap=llList2String(lList,1);
                }else if(llList2String(lList,0) == "fiveTap"){
                    fiveTap=llList2String(lList,1);
                }
                readLineID = llGetNotecardLine(configFile,line++);
            } else {
                llListen(channelID, "", "", "");
                llOwnerSay("System Initialized");
            }
        }
 
    } 
    
}
