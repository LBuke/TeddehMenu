#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/_utility;
#include maps/mp/zombies/_zm_utility;

/*
 * Created By Teddeh
 * Version 0.1
 */
init() {
	initUtil();
    level thread onplayerconnect();
}

onplayerconnect() {
    for(;;) {
        level waittill("connecting", player);
        player.status = player isHost() ? "Host" : "Admin";
        player thread onplayerspawned();
    }
}

onplayerspawned() {
    self endon("disconnect");
    level endon("game_ended");

	for(;;) {
		self waittill("spawned_player");
		
		thread doHeart();
		
		if(self isHost()) {
			self thread initTeddehMenu();
			self thread teddehControls();
			
			wait 2;
			self welcomeMessage();
		}
	}
}

welcomeMessage() {
    if(self.status != "Unverified") {
        if(level.GAMEMODE_TYPE == "ZOMBIES") {//ZOMBIES.
            wait 3.0;
            sendMessage("default", " ^3Welcome to " + level.PROJECT_NAME + " ^7[^1v" + level.PROJECT_VERSION + "^7] \n ^3Permission Status: ^2" + self.status + " \n ^3Enjoy your stay "+ self.name + "^3!" + "^7 \n \n \n \n \n \n \n \n \n \n \n ^2Press [{+speed_throw}] & ^3KNIFE ^2to Open Menu.", 10);
            return;
        }
    }
}



