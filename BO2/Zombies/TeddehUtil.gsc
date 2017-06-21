/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Name : TeddehUtil
*	 Description : 
*	 Date : 2017/06/21 - 23:16:21	
*
*/	

initUtil() {
    level.GAMEMODE_TYPE = "ZOMBIES";

    level.PROJECT_NAME = "Teddeh";
    level.PROJECT_VERSION = 0.1;
    level.MENU_NAME = level.PROJECT_NAME + " " + level.PROJECT_VERSION;
}

teddehLog(type, message) {
    str = "";
    switch(type) {
        case "ERROR":   str = "^1Error";   break;
        case "WARNING": str = "^5Warning"; break;
        case "SUCCESS": str = "^2Success"; break;
    }
    self iPrintln(str + "^3: ^7" + message);
}

sendMessage(type, str, time, override) {
    if(!override && self.message == 1) return;
    alex = createfontstring( type, 1.9 );
    alex.x = 0;
    alex.y = 20.11;
    alex settext(str);
    alex.glowcolor = ( 0, 0, 1 );
    alex.glowalpha = 1;
    alex.alpha = 1;
    alex settypewriterfx( 30, 999999999, 999999999 );
    alex.archived = 0;
    alexicon = self drawshader( "lui_loader_no_offset", 0, 80.11, 41, 41, ( 1, 1, 1 ), 0, 0 );
    alexicon.archived = 0;
    alexicon.alpha = 1;
    wait time;
    alex destroy();
    alexicon destroy();
}

toggleMessage(str, status) {
    self iprintln( "^5" + str + " : [" + (status ? "^2On" : "^1Off") + "^5]" );
}
