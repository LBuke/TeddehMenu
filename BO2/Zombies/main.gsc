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
        player.status = player isHost() ? "Host" : "Unverified";
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
        self waittill("spawned_player");
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
    if(player.status != verlevel) {
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
        if(level.GAMEMODE_TYPE == "ZOMBIES") {//ZOMBIES.
            wait 3.0;
            sendMessage("default", " ^3Welcome to " + level.PROJECT_NAME + " ^7[^1v" + level.PROJECT_VERSION + "^7] \n ^3Permission Status: ^2" + verificationToColor(self.status) + " \n ^3Enjoy your stay "+ self.name + "^3!" + "^7 \n \n \n \n \n \n \n \n \n \n \n ^2Press [{+speed_throw}] & ^3KNIFE ^2to Open Menu.", 15, true);
            return;
        }
    }
}

CreateMenu() {
	base = level.MENU_NAME;
    self add_menu(base, undefined, "Unverified");
        self add_option(base, "Main Modifications", ::submenu, "Main Modifications", "Main Modifications");
        self add_option(base, "Fun Modifications", ::submenu, "Fun Modifications", "Fun Modifications");
        self add_option(base, "Weapons Menu", ::submenu, "Weapons Menu", "Weapons Menu");
        self add_option(base, "Forge Menu", ::submenu, "Forge Menu", "Forge Menu");
        self add_option(base, "Teleport Menu", ::submenu, "Teleport Menu", "Teleport Menu");
        self add_option(base, "Models Menu", ::submenu, "Models Menu", "Models Menu");
        self add_option(base, "Aimbot Menu", ::submenu, "Aimbot Menu", "Aimbot Menu");
        self add_option(base, "Account Menu", ::submenu, "Account Menu", "Account Menu");
        self add_option(base, "Game Settings", ::submenu, "Game Settings", "Game Settings");
        self add_option(base, "Zombie Settings", ::submenu, "Zombie Settings", "Zombie Settings");
        self add_option(base, "Perks Menu", ::submenu, "Perks Menu", "Perks Menu");
        self add_option(base, "Power Ups Menu", ::submenu, "Power Ups Menu", "Power Ups Menu");
        self add_option(base, "Messages Menu", ::submenu, "Messages Menu", "Messages Menu");
        self add_option(base, "VIP Menu", ::submenu, "VIP Menu", "VIP Menu");
        self add_option(base, "Admin Menu", ::submenu, "Admin Menu", "Admin Menu");
        self add_option(base, "Host Menu", ::submenu, "Host Menu", "Host Menu");
        self add_option(base, "^1Players", ::submenu, "Players", "Players");

    self add_menu("Main Modifications", base, "Admin");
        self add_option("Main Modifications", "Godmode", ::godmode());
        self add_option("Main Modifications", "Unlimited Ammo", ::unlimited_ammo);
        self add_option("Main Modifications", "No Clip", ::toggleNoClip);
        self add_option("Main Modifications", "Force Host", ::forceHost);
        self add_option("Main Modifications", "DoHeart", ::doHeart);
        self add_option("Main Modifications", "Death Barrier", ::deathBarrier);
        self add_option("Main Modifications", "Restart", ::map_restart(false));
        self add_option("Main Modifications", "Power On", ::turnPowerOn());

    self add_menu("Fun Modifications", base, "VIP");
        self add_option("Fun Modifications", "Option 1");
        self add_option("Fun Modifications", "Option 2");
        self add_option("Fun Modifications", "Option 3");

    self add_menu("Weapons Menu", base, "Verified");
        self add_option("Weapons Menu", "Option 1");
        self add_option("Weapons Menu", "Option 2");
        self add_option("Weapons Menu", "Option 3");

    self add_menu("Players", base, "CoHost");
        for (i = 0; i < 12; i++) self add_menu("pOpt " + i, "Players", "CoHost");
}

updatePlayersMenu() {
    self.menu.menucount["Players"] = 0;
    for (i = 0; i < 12; i++) {
        player = level.players[i];
        name = player.name;

        playersizefixed = level.players.size - 1;
        if(self.menu.curs["Players"] > playersizefixed) {
            self.menu.scrollerpos["Players"] = playersizefixed;
            self.menu.curs["Players"] = playersizefixed;
        }

        self add_option("Players", "[" + verificationToColor(player.status) + "^7] " + player.name, ::submenu, "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + player.name);

        self add_menu_alt("pOpt " + i, "Players");
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
    self StoreText(level.MENU_NAME, level.MENU_NAME);

    self.menu.background FadeOverTime(0.3);
    self.menu.background.alpha = 0.65;

    self.menu.line MoveOverTime(0.15);
    self.menu.line2 MoveOverTime(0.15);
    self.menu.line.y = -50;
    self.menu.line2.y = -50;

    self.menu.scroller MoveOverTime(0.15);
    self.menu.scroller.y = self.menu.opt[self.menu.curs[self.menu.currentmenu]].y+1;
    self.menu.open = true;
}

closeMenu() {
    self.menu.open = false;
    for(i = 0; i < self.menu.opt.size; i++) {
        self.menu.opt[i] FadeOverTime(0.3);
        self.menu.opt[i].alpha = 0;
    }

    self.menu.background FadeOverTime(0.3);
    self.menu.background.alpha = 0;

    self.menu.title FadeOverTime(0.3);
    self.menu.title.alpha = 0;

    self.menu.line MoveOverTime(0.15);
    self.menu.line2 MoveOverTime(0.15);
    self.menu.line.y = -550;
    self.menu.line2.y = -550;

    self.menu.scroller MoveOverTime(0.15);
    self.menu.scroller.y = -500;
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
    player.menu.line2 destroy();
    player.menu.title destroy();
    player notify("destroyMenu");
}

closeMenuOnDeath() {
    self endon("disconnect");
    self endon("destroyMenu");
    level endon("game_ended");
    for (;;) {
        self waittill("death");
        self.menu.closeondeath = true;
        self submenu(level.MENU_NAME, level.MENU_NAME);
        closeMenu();
        self.menu.closeondeath = false;
    }
}

StoreShaders() {
    self.menu.background = self drawShader("white", /*X:320*/0, -50, 200, 500, (0, 0, 0), 0, 0);
    self.menu.scroller = self drawShader("white", /*X:320*/0, -500, 200, 17, (255, 255, 255), 50, 1);
    self.menu.line = self drawShader("white", /*X:170*/100, -550, 2, 500, (255, 250, 0), 255, 2);
    self.menu.line2 = self drawShader("white", /*X:170*/-100, -550, 2, 500, (255, 250, 0), 255, 2);
}

StoreText(menu, title) {
    self.menu.currentmenu = menu;
    self.menu.title destroy();
    self.menu.title = drawText(title, "objective", 2, /*X:280*/0, /*Y*/30, (1, 1, 1), 0, (0, 0.58, 1), 1, 3);
    self.menu.title FadeOverTime(0.3);
    self.menu.title.alpha = 1;

    for(i=0; i < self.menu.menuopt[menu].size; i++) {
        self.menu.opt[i] destroy();
        self.menu.opt[i] = drawText(self.menu.menuopt[menu][i], "objective", 1.6, /*X:280*/0, 68 + (i*20), (1, 1, 1), 0, (0, 0, 0), 0, 4);
        self.menu.opt[i] FadeOverTime(0.3);
        self.menu.opt[i].alpha = 1;
    }
}

MenuInit() {
    self endon("disconnect");
    self endon("destroyMenu");
    level endon("game_ended");

    self.menu = spawnstruct();
    self.toggles = spawnstruct();
    self.menu.open = false;
    self StoreShaders();
    self CreateMenu();

    for(;;) {
        if(self.menu.open) {
            if(self MeleeButtonPressed()) {
                if(isDefined(self.menu.previousmenu[self.menu.currentmenu])) self submenu(self.menu.previousmenu[self.menu.currentmenu]);
                closeMenu();
                wait 0.2;
            }

            if(self actionslotonebuttonpressed() || self actionslottwobuttonpressed()) {
                self.menu.curs[self.menu.currentmenu] += (Iif(self actionslottwobuttonpressed(), 1, -1));
                self.menu.curs[self.menu.currentmenu] = (Iif(self.menu.curs[self.menu.currentmenu] < 0, self.menu.menuopt[self.menu.currentmenu].size-1, Iif(self.menu.curs[self.menu.currentmenu] > self.menu.menuopt[self.menu.currentmenu].size-1, 0, self.menu.curs[self.menu.currentmenu])));
                self.menu.scroller MoveOverTime(0.15);
                self.menu.scroller.y = self.menu.opt[self.menu.curs[self.menu.currentmenu]].y+1;
            }

            if(self usebuttonpressed()) {
                self thread [[self.menu.menufunc[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]]](self.menu.menuinput[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]], self.menu.menuinput1[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]);
                wait 0.2;
            }
        }
        else {
            if(self MeleeButtonPressed() && self adsbuttonpressed()) {
                openMenu();
                wait 0.2;
            }
        }
        wait 0.05;
    }
}

submenu(input, title) {
    if (verificationToNum(self.status) >= verificationToNum(self.menu.status[input])) {
        for(i=0; i < self.menu.opt.size; i++) self.menu.opt[i] destroy();

        if (input == level.MENU_NAME) self thread StoreText(input, level.MENU_NAME);
        else if (input == "Players") {
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
