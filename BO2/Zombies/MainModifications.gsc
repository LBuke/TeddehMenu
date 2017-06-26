/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Name : MainModifications
*	 Description : 
*	 Date : 2017/06/21 - 23:13:33	
*
*/	

/* GODMODE */
godmode() {
    if(self.godv4 == 0) {
        self.godv4 = 1;
        self.health = 9999999;
        self.maxhealth = self.health;
        toggleMessage("Godmode", true);
        self thread loopgod();
    }
    else {
        self.godv4 = 0;
        self.maxhealth = 100;
        self.health = 100;
        toggleMessage("Godmode", false);
        self notify("stoploopingod");
    }
}

loopgod() {
    self endon("stoploopingod");
    while(self.godv4 == 1) {
        self.health = self.maxhealth;
        wait 0.1;
    }
}

/* UNLIMITED AMMO */
unlimited_ammo() {
    self endon("disconnect");
    self endon("death");

    if(self.unlimitedAmmo) {
        self.unlimitedAmmo = false;
        toggleMessage("Unlimited Ammo", false);
    }
    else {
        self.unlimitedAmmo = true;
        toggleMessage("Unlimited Ammo", true);
    }

    while(self.unlimitedAmmo) {
        wait 0.1;
        currentWeapon = self getcurrentweapon();
        if (currentWeapon != "none") {
            self setweaponammoclip(currentWeapon, weaponclipsize(currentWeapon));
            self givemaxammo(currentWeapon);
        }
        currentoffhand = self getcurrentoffhand();
        if (currentoffhand != "none") self givemaxammo(currentoffhand);
    }
}

/* FORCE HOST */
forceHost() {
    if(self.fhost == false) {
        self.fhost = true;
        setDvar("party_connectToOthers" , "0");
        setDvar("partyMigrate_disabled" , "1");
        setDvar("party_mergingEnabled" , "0");
        toggleMessage("Force Host", true);
    }
    else {
        self.fhost = false;
        setDvar("party_connectToOthers" , "1");
        setDvar("partyMigrate_disabled" , "0");
        setDvar("party_mergingEnabled" , "1");
        toggleMessage("Force Host", false);
    }
}

/* NO CLIP */
noClip() {
    self endon("stop_noclip");

    self.originObj = spawn("script_origin", self.origin, 1);
    self.originObj.angles = self.angles;

    self playerlinkto(self.originObj, undefined);

    self iprintln("^3Hold [{+breath_sprint}] & [{+speed_throw}] to Move.");

    for(;;) {
        if(self sprintbuttonpressed() && self throwbuttonpressed()) {
            normalized = anglesToForward(self getPlayerAngles());
            scaled = vectorScale(normalized, 20);
            originpos = self.origin + scaled;
            self.originObj.origin = originpos;
            self enableweapons();
        }
        wait 0.05;
    }
}

toggleNoClip() {
    if(!isDefined(self.noclip)) {
        self thread noclip();
        self.noclip = true;
        toggleMessage("No Clip", true);
    }
    else {
        self notify("stop_noclip");
        self.noclip = undefined;
        toggleMessage("No Clip", false);
        self unlink();
        self.originObj delete();
    }
}

/* ONSCREEN DISPLAY */
doHeart() {
    if(!isDefined(level.SA)) {
        level.SA=level createServerFontString("hudbig",2.1);
        level.SA setPoint("TOPLEFT","TOPLEFT",0,30 + 100);
        level.SA setText("^1" + level.PROJECT_NAME + " Project");
        level.SA.archived=false;
        level.SA.hideWhenInMenu=true;
        
        level.SA2=level createServerFontString("hudbig",1.6);
        level.SA2 setPoint("TOPLEFT","TOPLEFT",0,30 + 125);
        level.SA2 setText(" ^8Version " + level.PROJECT_VERSION);
        level.SA2.archived=false;
        level.SA2.hideWhenInMenu=true;
        
        for(;;) {
            level.SA ChangeFontScaleOverTime(0.4);
            level.SA.fontScale = 2.0;
            level.SA FadeOverTime(0.3);
            level.SA.glowAlpha=1;
            level.SA.glowColor =((randomint(255)/255),(randomint(255)/255),(randomint(255)/255));
            level.SA SetPulseFX(40,2000,600);
            
            level.SA2 ChangeFontScaleOverTime(0.4);
            level.SA2.fontScale = 1.6;
            level.SA2 FadeOverTime(0.3);
            level.SA2.glowAlpha=1;
            level.SA2.glowColor =((randomint(255)/255),(randomint(255)/255),(randomint(255)/255));
            level.SA2 SetPulseFX(40,2000,600);
            wait 0.4;
            level.SA ChangeFontScaleOverTime(0.4);
            level.SA.fontScale = 2.3;
            level.SA FadeOverTime(0.3);
            level.SA.glowAlpha=1;
            level.SA.glowColor =((randomint(255)/255),(randomint(255)/255),(randomint(255)/255));
            level.SA SetPulseFX(40,2000,600);
            
            level.SA2 ChangeFontScaleOverTime(0.4);
            level.SA2.fontScale = 1.9;
            level.SA2 FadeOverTime(0.3);
            level.SA2.glowAlpha=1;
            level.SA2.glowColor =((randomint(255)/255),(randomint(255)/255),(randomint(255)/255));
            level.SA2 SetPulseFX(40,2000,600);
            wait 0.4;
        }
    }
    if(level.doheart==0) {
        toggleMessage("Do Heart", true);
        level.doheart=1;
        level.SA.alpha=1;
        level.SA2.alpha=1;
    }
    else if(level.doheart==1) {
        toggleMessage("Do Heart", false);
        level.SA.alpha=0;
        level.SA2.alpha=0;
        level.doheart=0;
    }
}

/* DEATH BARRIER */
deathBarrier() {
    ents = getEntArray();
    for (index = 0; index < ents.size; index++) {
        if(isSubStr(ents[index].classname, "trigger_hurt"))
            ents[index].origin = (0, 0, 9999999);
    }
    self iPrintLn("^3Death barries have been removed.");
}

/* POWER ON */
turnPowerOn(user) {
    trig = getent("use_elec_switch", "targetname");
    master_switch = getent("elec_switch", "targetname");
    master_switch notsolid();
    trig sethintstring("ZOMBIE_ELECTRIC_SWITCH");
    trig setvisibletoall();
    trig setinvisibletoall();
    master_switch rotateroll(-90,0,3);
    master_switch playsound("zmb_switch_flip");
    master_switch playsound("zmb_poweron");
    level delay_thread(11,8,::pOn);
    if(isDefined(user)) user thread maps/mp/zombies/_zm_audio::create_and_play_dialog("power","power_on");
    trig notify("trigger", user);
    level thread maps/mp/zombies/_zm_perks::perk_unpause_all_perks();
    master_switch waittill("rotatedone");
    playfx( level._effect["switch_sparks"],master_switch.origin+( 0, 12, -60 ), anglesToForward(master_switch.angles));
    master_switch playsound("zmb_turn_on");
    level notify("electric_door");
    clientnotify("power_on");
    flag_set("power_on");
    level setclientfield("zombie_power_on", 1);
}
pOn() {
    level thread maps/mp/zombies/_zm_audio::sndmusicstingerevent("poweron");
}

/* SCORE */
givescore(amount) {
	self.score = self.score + amount;
	teddehLog("SUCCESS", "^2+^8" + amount + " Score");
}

takescore(amount) {
	self.score = self.score - amount
	teddehLog("SUCCESS", "^1-" + amount + " Score");
}




