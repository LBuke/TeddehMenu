#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/_utility;
#include maps/mp/zombies/_zm_utility;



init() {
    level.menuType = "ZOMBIES";

    level thread onplayerconnect();
}

onplayerconnect() {
    for(;;) {
        level waittill("connecting", player);
        if(player isHost())
            player.status = "Host";
        else
            player.status = "Unverified";

        player thread onplayerspawned();
    }
}

onplayerspawned() {
    self endon("disconnect");
    level endon("game_ended");

    //Initialise Variables
    self.MenuInit = false;
    self.godv4 = 0;
    self.unlimitedAmmo = false;

    for(;;) {
        self waittill( "spawned_player" );
        if( self.status == "Host" || self.status == "CoHost" || self.status == "Admin" || self.status == "VIP" || self.status == "Verified") {
            if (!self.MenuInit) {
                self.MenuInit = true;
                self thread MenuInit();
                self thread closeMenuOnDeath();

                wait 2;
                self welcomeMessage();
            }
        }
    }
}

drawText(text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort) {
    hud = self createFontString(font, fontScale);
    hud setText(text);
    hud.x = x;
    hud.y = y;
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    hud.alpha = alpha;
    return hud;
}

drawShader(shader, x, y, width, height, color, alpha, sort) {
    hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud.x = x;
    hud.y = y;
    return hud;
}

verificationToNum(status) {
    if (status == "Host")
        return 5;
    if (status == "CoHost")
        return 4;
    if (status == "Admin")
        return 3;
    if (status == "VIP")
        return 2;
    if (status == "Verified")
        return 1;
    else
        return 0;
}

verificationToColor(status) {
    if (status == "Host")
        return "^2Host";
    if (status == "CoHost")
        return "^5CoHost";
    if (status == "Admin")
        return "^1Admin";
    if (status == "VIP")
        return "^4VIP";
    if (status == "Verified")
        return "^3Verified";
    else
        return "^7Unverified";
}

changeVerificationMenu(player, verlevel) {
    if( player.status != verlevel) {
        player.status = verlevel;

        self.menu.title destroy();
        self.menu.title = drawText("[" + verificationToColor(player.status) + "^7] " + player.name, "objective", 2, 280, 30, (1, 1, 1), 0, (0, 0.58, 1), 1, 3);
        self.menu.title FadeOverTime(0.3);
        self.menu.title.alpha = 1;

        if(player.status == "Unverified")
            self thread destroyMenu(player);

        player suicide();
        self iPrintln("Set Access Level For " + player.name + " To " + verificationToColor(verlevel));
        player iPrintln("Your Access Level Has Been Set To " + verificationToColor(verlevel));
        player welcomeMessage();
    }
    else {
        self iPrintln("Access Level For " + player.name + " Is Already Set To " + verificationToColor(verlevel));
    }
}

changeVerification(player, verlevel) {
    player.status = verlevel;
}

Iif(bool, rTrue, rFalse) {
    if(bool)
        return rTrue;
    else
        return rFalse;
}

welcomeMessage() {
    if( self.status == "Verified" || self.status == "VIP" || self.status == "Admin" || self.status == "Co-Host" || self.status == "Host" ) {
        if(level.menuType == "ZOMBIES") {//ZOMBIES.
            wait 3.0;
            sendMessage("default", " ^3Welcome to Teddeh ^7[^1v1.0^7] \n ^3Permission Status: ^2" + verificationToColor(self.status) + " \n ^3Enjoy your stay "+ self.name + "^3!" + "^7 \n \n \n \n \n \n \n \n \n \n \n ^2Press [{+speed_throw}] & V to Open Menu.", 15, true);
            return;
        }
    }
}

CreateMenu() {
    self add_menu("Main Menu", undefined, "Unverified");
    self add_option("Main Menu", "Main Modifications", ::submenu, "Main Modifications", "Main Modifications");
    self add_option("Main Menu", "VIP Category", ::submenu, "VIP Category", "VIP Category");
    self add_option("Main Menu", "Fun Category", ::submenu, "Fun Category", "Fun Category");
    self add_option("Main Menu", "Players", ::submenu, "PlayersMenu", "Players");

    self add_menu("Main Modifications", "Main Menu", "Admin");
    self add_option("Main Modifications", "Godmode", ::godmode);
    self add_option("Main Modifications", "Unlimited Ammo", ::unlimited_ammo);
    self add_option("Main Modifications", "No Clip", ::toggleNoClip);
    self add_option("Main Modifications", "Force Host", ::forceHost);
    self add_option("Main Modifications", "DoHeart", ::doHeart);
    self add_option("Main Modifications", "Death Barrier", ::deathBarrier);
    self add_option("Main Modifications", "Restart", ::map_restart(false));
    self add_option("Main Modifications", "Power On", ::turnPowerOn());

    self add_menu("VIP Category", "Main Menu", "VIP");
    self add_option("VIP Category", "Option 1");
    self add_option("VIP Category", "Option 2");
    self add_option("VIP Category", "Option 3");

    self add_menu("Fun Category", "Main Menu", "Verified");
    self add_option("Fun Category", "Option 1");
    self add_option("Fun Category", "Option 2");
    self add_option("Fun Category", "Option 3");

    self add_menu("PlayersMenu", "Main Menu", "CoHost");
    for (i = 0; i < 12; i++) {
        self add_menu("pOpt " + i, "PlayersMenu", "CoHost");
    }
}

updatePlayersMenu() {
    self.menu.menucount["PlayersMenu"] = 0;
    for (i = 0; i < 12; i++) {
        player = level.players[i];
        name = player.name;

        playersizefixed = level.players.size - 1;
        if(self.menu.curs["PlayersMenu"] > playersizefixed) {
            self.menu.scrollerpos["PlayersMenu"] = playersizefixed;
            self.menu.curs["PlayersMenu"] = playersizefixed;
        }

        self add_option("PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + player.name, ::submenu, "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + player.name);

        self add_menu_alt("pOpt " + i, "PlayersMenu");
        self add_option("pOpt " + i, "Give CoHost", ::changeVerificationMenu, player, "CoHost");
        self add_option("pOpt " + i, "Give Admin", ::changeVerificationMenu, player, "Admin");
        self add_option("pOpt " + i, "Give VIP", ::changeVerificationMenu, player, "VIP");
        self add_option("pOpt " + i, "Verify", ::changeVerificationMenu, player, "Verified");
        self add_option("pOpt " + i, "Unverify", ::changeVerificationMenu, player, "Unverified");
    }
}

add_menu_alt(Menu, prevmenu) {
    self.menu.getmenu[Menu] = Menu;
    self.menu.menucount[Menu] = 0;
    self.menu.previousmenu[Menu] = prevmenu;
}

add_menu(Menu, prevmenu, status) {
    self.menu.status[Menu] = status;
    self.menu.getmenu[Menu] = Menu;
    self.menu.scrollerpos[Menu] = 0;
    self.menu.curs[Menu] = 0;
    self.menu.menucount[Menu] = 0;
    self.menu.previousmenu[Menu] = prevmenu;
}

add_option(Menu, Text, Func, arg1, arg2) {
    Menu = self.menu.getmenu[Menu];
    Num = self.menu.menucount[Menu];
    self.menu.menuopt[Menu][Num] = Text;
    self.menu.menufunc[Menu][Num] = Func;
    self.menu.menuinput[Menu][Num] = arg1;
    self.menu.menuinput1[Menu][Num] = arg2;
    self.menu.menucount[Menu] += 1;
}

openMenu() {
    self freezeControls( false );
    self StoreText("Main Menu", "Main Menu");

    self.menu.background FadeOverTime(0.3);
    self.menu.background.alpha = 0.65;

    self.menu.line MoveOverTime(0.15);
    self.menu.line.y = -50;

    self.menu.scroller MoveOverTime(0.15);
    self.menu.scroller.y = self.menu.opt[self.menu.curs[self.menu.currentmenu]].y+1;
    self.menu.open = true;
}

closeMenu() {
    for(i = 0; i < self.menu.opt.size; i++) {
        self.menu.opt[i] FadeOverTime(0.3);
        self.menu.opt[i].alpha = 0;
    }

    self.menu.background FadeOverTime(0.3);
    self.menu.background.alpha = 0;

    self.menu.title FadeOverTime(0.3);
    self.menu.title.alpha = 0;

    self.menu.line MoveOverTime(0.15);
    self.menu.line.y = -550;

    self.menu.scroller MoveOverTime(0.15);
    self.menu.scroller.y = -500;
    self.menu.open = false;
}

destroyMenu(player) {
    player.MenuInit = false;
    closeMenu();

    wait 0.3;

    for(i=0; i < self.menu.menuopt[player.menu.currentmenu].size; i++) {
        player.menu.opt[i] destroy();
    }

    player.menu.background destroy();
    player.menu.scroller destroy();
    player.menu.line destroy();
    player.menu.title destroy();
    player notify( "destroyMenu" );
}

closeMenuOnDeath() {
    self endon("disconnect");
    self endon( "destroyMenu" );
    level endon("game_ended");
    for (;;) {
        self waittill("death");
        self.menu.closeondeath = true;
        self submenu("Main Menu", "Main Menu");
        closeMenu();
        self.menu.closeondeath = false;
    }
}

StoreShaders() {
    self.menu.background = self drawShader("white", 320, -50, 300, 500, (0, 0, 0), 0, 0);
    self.menu.scroller = self drawShader("white", 320, -500, 300, 17, (0, 0, 0), 255, 1);
    self.menu.line = self drawShader("white", 170, -550, 2, 500, (0, 0, 0), 255, 2);
}

StoreText(menu, title) {
    self.menu.currentmenu = menu;
    self.menu.title destroy();
    self.menu.title = drawText(title, "objective", 2, 280, 30, (1, 1, 1), 0, (0, 0.58, 1), 1, 3);
    self.menu.title FadeOverTime(0.3);
    self.menu.title.alpha = 1;

    for(i=0; i < self.menu.menuopt[menu].size; i++) {
        self.menu.opt[i] destroy();
        self.menu.opt[i] = drawText(self.menu.menuopt[menu][i], "objective", 1.6, 280, 68 + (i*20), (1, 1, 1), 0, (0, 0, 0), 0, 4);
        self.menu.opt[i] FadeOverTime(0.3);
        self.menu.opt[i].alpha = 1;
    }
}

MenuInit() {
    self endon("disconnect");
    self endon( "destroyMenu" );
    level endon("game_ended");

    self.menu = spawnstruct();
    self.toggles = spawnstruct();
    self.menu.open = false;
    self StoreShaders();
    self CreateMenu();

    for(;;) {
        if(self MeleeButtonPressed() && self adsbuttonpressed() && !self.menu.open) openMenu();
        if(self.menu.open) {
            if(self usebuttonpressed()) {
                if(isDefined(self.menu.previousmenu[self.menu.currentmenu])) self submenu(self.menu.previousmenu[self.menu.currentmenu]);
                else closeMenu();
                wait 0.2;
            }

            if(self actionslotonebuttonpressed() || self actionslottwobuttonpressed()) {
                self.menu.curs[self.menu.currentmenu] += (Iif(self actionslottwobuttonpressed(), 1, -1));
                self.menu.curs[self.menu.currentmenu] = (Iif(self.menu.curs[self.menu.currentmenu] < 0, self.menu.menuopt[self.menu.currentmenu].size-1, Iif(self.menu.curs[self.menu.currentmenu] > self.menu.menuopt[self.menu.currentmenu].size-1, 0, self.menu.curs[self.menu.currentmenu])));
                self.menu.scroller MoveOverTime(0.15);
                self.menu.scroller.y = self.menu.opt[self.menu.curs[self.menu.currentmenu]].y+1;
            }

            if(self jumpbuttonpressed()) {
                self thread [[self.menu.menufunc[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]]](self.menu.menuinput[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]], self.menu.menuinput1[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]);
                wait 0.2;
            }
        }
        wait 0.05;
    }
}

submenu(input, title) {
    if (verificationToNum(self.status) >= verificationToNum(self.menu.status[input])) {
        for(i=0; i < self.menu.opt.size; i++) self.menu.opt[i] destroy();

        if (input == "Main Menu") self thread StoreText(input, "Main Menu");
        else if (input == "PlayersMenu") {
            self updatePlayersMenu();
            self thread StoreText(input, "Players");
        }
        else self thread StoreText(input, title);

        self.CurMenu = input;
        self.menu.scrollerpos[self.CurMenu] = self.menu.curs[self.CurMenu];
        self.menu.curs[input] = self.menu.scrollerpos[input];

        if (!self.menu.closeondeath) {
            self.menu.scroller MoveOverTime(0.15);
            self.menu.scroller.y = self.menu.opt[self.menu.curs[self.CurMenu]].y+1;
        }
    }
    else {
        self iPrintln("^1Error^3: ^7Only Players With " + verificationToColor(self.menu.status[input]) + " ^7Can Access This Menu!");
    }
}

//Functions

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

/* GODMODE */
godmode() {
    if( self.godv4 == 0 ) {
        self.godv4 = 1;
        self.health = 9999999;
        self.maxhealth = self.health;
        toggleMessage("Godmode", true);
        self iPrintln("^1Error^3: ^7Only Players With " + verificationToColor(self.menu.status[input]) + " ^7Can Access This Menu!");
        self thread loopgod();
    }
    else {
        self.godv4 = 0;
        self.maxhealth = 100;
        self.health = 100;
        toggleMessage("Godmode", false);
        self notify( "stoploopingod" );
    }
}

loopgod() {
    self endon( "stoploopingod" );
    while( self.godv4 == 1 ) {
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
        level.iamtext = self.name;
        level.SA=level createServerFontString("hudbig",2.1);
        level.SA setPoint( "TOPLEFT","TOPLEFT",0,30 + 100 );
        level.SA setText( "^1Teddeh ^3[^1v1.0^3]" );
        level.SA.archived=false;
        level.SA.hideWhenInMenu=true;
        for(;;) {
            level.SA ChangeFontScaleOverTime( 0.4 );
            level.SA.fontScale = 2.0;
            level.SA FadeOverTime( 0.3 );
            level.SA.glowAlpha=1;
            level.SA.glowColor =((randomint(255)/255),(randomint(255)/255),(randomint(255)/255));
            level.SA SetPulseFX(40,2000,600);
            wait 0.4;
            level.SA ChangeFontScaleOverTime( 0.4 );
            level.SA.fontScale = 2.3;
            level.SA FadeOverTime( 0.3 );
            level.SA.glowAlpha=1;
            level.SA.glowColor =((randomint(255)/255),(randomint(255)/255),(randomint(255)/255));
            level.SA SetPulseFX(40,2000,600);
            wait 0.4;
        }
    }
    if(level.doheart==0) {
        toggleMessage("Do Heart", true);
        level.doheart=1;
        level.SA.alpha=1;
    }
    else if(level.doheart==1) {
        toggleMessage("Do Heart", false);
        level.SA.alpha=0;
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
    trig notify("trigger", user);
    trig setinvisibletoall();
    master_switch rotateroll(-90,0,3);
    master_switch playsound("zmb_switch_flip");
    master_switch playsound("zmb_poweron");
    level delay_thread(11,8,::pOn);
    if(isDefined(user)) user thread maps/mp/zombies/_zm_audio::create_and_play_dialog("power","power_on");
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
