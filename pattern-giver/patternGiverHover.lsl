//Silent Dressage Random Pattern Giver Hover Text Display
//by Bear(bearaus)
//Created 5 September 2018
//

//You are free to use this code, or modify it, but please acknowledge 
//and let the original author if you do make changes.

//
// Global Variables
//
//Channel to Listen for Commands on
integer channelID;
//Command to Listen for
string commandName;
//System Information
string hudLoc;
string hudID;
integer hudLinkEnabled;
integer commandEnabled;
integer hoverDisp;
//Notecard Configuration Variables
integer line;
string configFile = "patternGiver.cfg";
key readLineID;
integer loaded = FALSE;

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
        if (hoverDisp == TRUE){
            string outputText;
            if (hudLinkEnabled == TRUE) {
                if (hudLoc == "Remote") {
                    outputText = outputText + "\nHUD Channel: " + hudID;
                }
                if (commandEnabled == TRUE) {
                    outputText = outputText + "\nCommand Set to: /" + (string)commandID + " " + commandName;
                }
                outputText = outputText + "\n \n \n ";
        }
       
 
        // When Done Sending Config Values, Exit Sub-Routine
        
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
                    else if(name == "commandname"){
                        commandName = value;
                    }
                    // Command Enabled
                    else if(name == "commandenabled"){
                        string tempValue = llToLower(value);
                        if (tempValue == "true"){
                            commandEnabled = TRUE;
                        }
                        else {
                            commandEnabled = FALSE;    
                        }
                    }
                    // Touch Enabled
                    else if(name == "touchenabled"){
                    
                    }
                    // Chat Display Enabled
                    else if(name == "displaychat"){
                    
                    }
                    // Popup Display Enabled
                    else if(name == "displaypopup"){

                    }
                                       
                    // HUD Link Enabled
                    else if (name == "hudlinkenabled"){
                        string tempValue = llToLower(value);
                        if (tempValue == "true"){
                            hudLinkEnabled = TRUE;
                        }
                        else {
                            hudLinkEnabled = FALSE;    
                        }
                    }   
                    // HUD Link ID 
                    else if (name == "hudloc"){
                        string tempValue = llToLower(value);
                        if (tempValue == "remote"){
                            hudLoc = "Remote";
                        }
                        else {
                            hudLoc = "Local";
                        }
                    }
                    // HUD Link ID 
                    else if (name == "hudid"){ 
                        hudID = value;   
                    }
                    // Hover Display Enabled
                    else if (name == "hoverdisp"){
                        string tempValue = llToLower(value);
                        if (tempValue == "true"){
                            hoverDisp = TRUE;
                        }
                        else {
                            hoverDisp = FALSE;
                        }    
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


/Main Script
default
{ 
    state_entry() {
        llSetText("", ZERO_VECTOR, 0);
        init();       
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
        init();         
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
