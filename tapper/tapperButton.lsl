//Global Variables
integer tapTotal = 1;
list transmit = [" ", "one", "two", "three", "four", "five"];

default
{
    state_entry()
    {
        
    }

    touch_start(integer total_number)
    {
        llMessageLinked(LINK_ROOT, 0, llList2String(transmit, tapTotal), "");    
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if (msg == "query"){
            llMessageLinked(LINK_ROOT, 0, llGetObjectDesc(), "");       
        }
        if (tapTotal == 1){
            if (msg == "change2Whip"){
                llSetObjectDesc("whip");
                llMessageLinked(LINK_ROOT, 0, llGetObjectDesc(), "");   
            }
            if (msg == "change2Tap"){
                llSetObjectDesc("tap");
                llMessageLinked(LINK_ROOT, 0, llGetObjectDesc(), "");  
            }
            if (msg == "change2Rein"){
                llSetObjectDesc("rein");
                llMessageLinked(LINK_ROOT, 0, llGetObjectDesc(), "");  
            }
        }
        if (tapTotal == 2){
            if (msg == "chatToggle"){
                if (llGetObjectDesc() == "Showing"){
                    llSetObjectDesc("Hidden");
                }else{
                    llSetObjectDesc("Showing");
                }
                llMessageLinked(LINK_ROOT, 0, llGetObjectDesc(), "");
            }
        }
    }
}
