/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Name : TeddehMenu
*	 Description : 
*	 Date : 2017/06/22 - 12:01:26	
*
*/

initTeddehMenu() {
	self.menu = spawnstruct();
	self.hud = spawnstruct();
	self.menu.open = false;
	
	self.visibleTeddehMenu[0] = 16;
	self.visibleTeddehMenu[1] = 0;
	self.visibleTeddehMenu[2] = 1;
	
	self setTeddehMenuData();
}

openTeddehMenu() {
	self.teddehMsg destroy();
	self.menu.open = true;
	self setTeddehMenuText();
	self setTeddehMenuStructure();
}

closeTeddehMenu() {
	self.menu.open = false;
	self destroyAllTeddehMenuObjects();
}

destroyAllTeddehMenuObjects() {
	//TODO destroy shaders & text
	self.hud.background[0] destroy();
	self.hud.background[1] destroy();
	self.hud.background[2] destroy();
	
	self.hud.backgroundLines[1][0] destroy();
	self.hud.backgroundLines[1][1] destroy();
	self.hud.backgroundLines[1][2] destroy();
	self.hud.backgroundLines[1][3] destroy();

	self.hud.backgroundLines[0][0] destroy();
	self.hud.backgroundLines[0][2] destroy();
	self.hud.backgroundLines[0][3] destroy();
	
	self.hud.backgroundLines[2][0] destroy();
	self.hud.backgroundLines[2][2] destroy();
	self.hud.backgroundLines[2][3] destroy();
	
	self.hud.scroller destroy();

	for(i = 0; i < 3; i++) {
		self.menu.title[i] destroy();
		self.menu.title[i+3] destroy();
		self.hud.text[i] destroy();
	}
}

teddehControls() {
	self endon("disconnect");
	for(;;) {
		if(self.menu.open) {
            if(self MeleeButtonPressed()) {
                //back or close.
                self closeTeddehMenu();
                wait 0.2;
            }

            if(self actionslotonebuttonpressed() || self actionslottwobuttonpressed()) {
                if(self sprintbuttonpressed()) {
                	//switch category
                	for(i = 0; i < 3; i++) self.visibleTeddehMenu[i] = self getNextTeddehCategory(self.visibleTeddehMenu[i], self actionslottwobuttonpressed());
                	self.scrollCache = 0;
					self setTeddehMenuText();
                	self setTeddehMenuLines();
                	self resetTeddehMenuCursor();
                }
                else {
                	//scroll
                	if(self actionslottwobuttonpressed()) self.scrollCache += 1;
                	else self.scrollCache -= 1;
                	
                	if(self.scrollCache > self.menu.optText.size) {
                		self.scrollCache = 0;
                		self.hud.scroller MoveOverTime(0.15);
                		self.hud.scroller.y = (self.hud.text[1].y + 1.9) + (self.scrollCache * 19.1);
                	}
                	else if(self.scrollCache < 0) {
                		self.scrollCache = self.menu.optText.size;
                		self.hud.scroller MoveOverTime(0.15);
                		self.hud.scroller.y = (self.hud.text[1].y + 2) + (self.scrollCache * 19.1);
                	}
                	else {
                		self.hud.scroller MoveOverTime(0.15);
                		self.hud.scroller.y = (self.hud.text[1].y + 2) + (self.scrollCache * 19.1);
                	}
                }
                wait 0.2;
            }

            if(self usebuttonpressed()) {
                self thread [[self.menu.optFunc[self.visibleTeddehMenu[1]][self.scrollCache]]](self.menu.optInput[self.visibleTeddehMenu[1]][self.scrollCache]);
                wait 0.2;
            }
        }
        else {
            if(self MeleeButtonPressed() && self adsbuttonpressed()) {
                //open
                self openTeddehMenu();
                wait 0.2;
            }
        }
        wait 0.05;
	}
}

setTeddehMenuData() {
	self addTeddehMenuCategory(0, "Main Mods", "NONE", ((252/255), (152/255), (64/255)));//
		self addTeddehMenuOption(0, 0, "Godmode", ::godmode(), "");
		self addTeddehMenuOption(0, 1, "Unlimited Ammo", ::unlimited_ammo(), "");
		self addTeddehMenuOption(0, 2, "Adv. No Clip", ::toggleNoClip(), "");
		self addTeddehMenuOption(0, 3, "Advertisment", ::toggleTeddehMenuAdvertisment(), "");
		self addTeddehMenuOption(0, 4, "Give Score", ::givescore(), 250000);
		self addTeddehMenuOption(0, 5, "Take Score", ::takescore(), 50000);
		self addTeddehMenuOption(0, 6, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(0, 7, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(0, 8, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(0, 9, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(0, 10, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(0, 11, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(0, 12, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(0, 13, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(0, 14, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(0, 15, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(0, 16, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(0, 17, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(0, 17, "Placeholder", ::comingSoon(), "");
		
	self addTeddehMenuCategory(1, "Fun Mods", "NONE", ((252/255), (239/255), (64/255)));//
		self addTeddehMenuOption(1, 0, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(1, 1, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(1, 2, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(1, 3, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(1, 4, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(1, 5, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(1, 6, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(1, 7, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(1, 8, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(1, 9, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(1, 10, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(1, 11, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(1, 12, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(1, 13, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(1, 14, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(1, 15, "Placeholder", ::comingSoon(), "");
		self addTeddehMenuOption(1, 16, "Placeholder", ::godmode(), "");
		self addTeddehMenuOption(1, 17, "Placeholder", ::comingSoon(), "");
		
	self addTeddehMenuCategory(2, "Weapons Menu", "NONE", ((183/255), (252/255), (64/255)));//
		self addTeddehMenuOption(2, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(2, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(3, "Forge Menu", "NONE", ((104/255), (252/255), (64/255)));//
		self addTeddehMenuOption(3, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(3, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(4, "Teleport Menu", "NONE", ((64/255), (252/255), (183/255)));//
		self addTeddehMenuOption(4, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(4, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(5, "Models Menu", "NONE", ((64/255), (214/255), (252/255)));//
		self addTeddehMenuOption(5, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(5, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(6, "Aimbot Menu", "NONE", ((64/255), (114/255), (252/255)));//
		self addTeddehMenuOption(6, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(6, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(7, "Account Menu", "NONE", ((82/255), (64/255), (252/255)));//
		self addTeddehMenuOption(7, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(7, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(8, "Game Settings", "NONE", ((129/255), (64/255), (252/255)));//
		self addTeddehMenuOption(8, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(8, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(9, "Zombie Settings", "NONE", ((176/255), (64/255), (252/255)));//
		self addTeddehMenuOption(9, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(9, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(10, "Perks Menu", "NONE", ((217/255), (64/255), (252/255)));//
		self addTeddehMenuOption(10, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(10, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(11, "Power Ups Menu", "NONE", ((252/255), (64/255), (248/255)));//
		self addTeddehMenuOption(11, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(11, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(12, "Messages Menu", "NONE", ((252/255), (64/255), (167/255)));//
		self addTeddehMenuOption(12, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(12, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(13, "VIP Menu", "NONE", ((252/255), (64/255), (114/255)));
		self addTeddehMenuOption(13, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(13, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(14, "Admin Menu", "NONE", ((252/255), (65/255), (65/255)));
		self addTeddehMenuOption(14, 0, "Option 1", ::comingSoon(), "");
		self addTeddehMenuOption(14, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(15, "Host Menu", "NONE", ((252/255), (65/255), (65/255)));
		self addTeddehMenuOption(15, 0, "Force Host", ::forceHost(), "");
		self addTeddehMenuOption(15, 1, "Option 2", ::comingSoon(), "");
		
	self addTeddehMenuCategory(16, "Players", "NONE", ((252/255), (65/255), (65/255)));
		for(i = 0; i < level.players.size; i++) self addTeddehMenuOption(16, i, level.players[i].name, ::comingSoon(), "");
}

getNextTeddehCategory(current, next) {
//	return next ? (current + 1 > self.menu.text.size ? 0 : current + 1) : (current - 1 < 0 ? self.menu.text.size : current - 1);
	if(next == true) {
		if(current >= (self.menu.text.size - 1)) return 0;
		return current + 1;
	} else {
		if(current <= 0) return (self.menu.text.size - 1);
		return current - 1;
	}
}

addTeddehMenuCategory(uniqueId, text, parent, color) {
	self.menu.text[uniqueId] = text;
	self.menu.parent[uniqueId] = parent;
	self.menu.color[uniqueId] = color;
}

addTeddehMenuOption(menuId, uniqueId, text, function, input) {
	self.menu.optText[menuId][uniqueId] = text;
	self.menu.optFunc[menuId][uniqueId] = function;
	self.menu.optInput[menuId][uniqueId] = input;
}

comingSoon() {//TODO Remove eventually.
	self teddehLog("INFO", "This feature is coming soon.");
}

setTeddehMenuStructure() {
	if(!isDefined(self.scrollCache)) self.scrollCache = 0;

	self.hud.background[0] = self createRectangle("CENTER", "CENTER", /*X*/-150, /*Y*/0, 150, 336, (0.05, 0.05, 0.05), 0.45, 1, "white");
	self.hud.background[1] = self createRectangle("CENTER", "CENTER", /*X*/0, /*Y*/0, 150, 440, (0.05, 0.05, 0.05), 0.8, 1, "white");
	self.hud.background[2] = self createRectangle("CENTER", "CENTER", /*X*/150, /*Y*/0, 150, 336, (0.05, 0.05, 0.05), 0.45, 1, "white");
	
	self setTeddehMenuLines();
	self resetTeddehMenuCursor();
}

resetTeddehMenuCursor() {
	self.hud.scroller destroy();
	self.hud.scroller = self createRectangle("CENTER", "TOP", /*X*/0, /*Y*/(self.hud.text[1].y + 1.9) + (self.scrollCache * 18.9), 150, 20, self.menu.color[self.visibleTeddehMenu[1]], 0.8, 2, "white");
}

setTeddehMenuLines() {
	for(i = 0; i < 3; i++) {
		for(x = 0; x < 4; x++) {
			self.hud.backgroundLines[i][x] destroy();
		}
	}
	
	self.hud.backgroundLines[1][0] = self createRectangle("CENTER", "CENTER", /*X*/-75, /*Y*/0, 2, 441, self.menu.color[self.visibleTeddehMenu[1]], 1, 2, "white");
	self.hud.backgroundLines[1][1] = self createRectangle("CENTER", "CENTER", /*X*/75, /*Y*/0, 2, 441, self.menu.color[self.visibleTeddehMenu[1]], 1, 2, "white");
	self.hud.backgroundLines[1][2] = self createRectangle("CENTER", "CENTER", /*X*/0, /*Y*/-220, 151, 2, self.menu.color[self.visibleTeddehMenu[1]], 1, 2, "white");
	self.hud.backgroundLines[1][3] = self createRectangle("CENTER", "CENTER", /*X*/0, /*Y*/220, 151, 2, self.menu.color[self.visibleTeddehMenu[1]], 1, 2, "white");

	self.hud.backgroundLines[0][0] = self createRectangle("CENTER", "CENTER", /*X*/-225, /*Y*/0, 2, 337, self.menu.color[self.visibleTeddehMenu[0]], 0.6, 2, "white");
	self.hud.backgroundLines[0][2] = self createRectangle("CENTER", "CENTER", /*X*/-150, /*Y*/-168, 151, 2, self.menu.color[self.visibleTeddehMenu[0]], 0.6, 2, "white");
	self.hud.backgroundLines[0][3] = self createRectangle("CENTER", "CENTER", /*X*/-150, /*Y*/168, 151, 2, self.menu.color[self.visibleTeddehMenu[0]], 0.6, 2, "white");
	
	self.hud.backgroundLines[2][0] = self createRectangle("CENTER", "CENTER", /*X*/225, /*Y*/0, 2, 337, self.menu.color[self.visibleTeddehMenu[2]], 0.6, 2, "white");
	self.hud.backgroundLines[2][2] = self createRectangle("CENTER", "CENTER", /*X*/150, /*Y*/-168, 151, 2, self.menu.color[self.visibleTeddehMenu[2]], 0.6, 2, "white");
	self.hud.backgroundLines[2][3] = self createRectangle("CENTER", "CENTER", /*X*/150, /*Y*/168, 151, 2, self.menu.color[self.visibleTeddehMenu[2]], 0.6, 2, "white");
}

setTeddehMenuText() {
	string = "";
	for(a = 0; a < self.visibleTeddehMenu.size; a+=1) {
		self.correctVal = self.visibleTeddehMenu[a];
		self.scale = 0;
		self.posX = 0;
		self.posY = 0;
		self.textY = 0;
		if(a == 1) {
			self.scale = 1.6;
			self.posX = 0;
			self.posY = 60;
			self.textY = self.posY - 50;
		}
		if(a == 0 || a == 2) {
			if(a == 0) self.posX = -150;
			if(a == 2) self.posX = 150;
			self.scale = 1.2;
			self.posY = 90;
			self.textY = self.posY - 30;
		}
		
		self.menu.title[a] destroy();
		self.menu.title[a] = self drawText(self.menu.text[self.correctVal], "default", self.scale + 0.3, /*X:280*/self.posX, /*Y*/self.textY, self.menu.color[self.correctVal], 1, (0, 0.58, 1), 1, 3);
		self.menu.title[a] FadeOverTime(0.3);
		self.menu.title[a].alpha = 1;
		self.menu.title[a].glowAlpha = 1;
		self.menu.title[a].x = self.posX;
		self.menu.title[a].y = self.textY;
		self.hud.text[a].fontScale = self.scale;
		if(a == 1) self.hud.text[a].glowColor = ((68/255), (143/255), (255/255));
		if(a == 0 || a == 2) self.hud.text[a].glowColor = ((244/255), (110/255), (66/255));
		if(a == 1) {
			self.menu.title[a+3] destroy();
			self.menu.title[a+3] = self drawText("Created By TeddyDev", "default", 1, /*X:280*/self.posX, /*Y*/self.textY + 15, self.menu.color[self.correctVal], 1, (0, 0.58, 1), 1, 3);
			self.menu.title[a+3] FadeOverTime(0.3);
			self.menu.title[a+3].alpha = 1;
			self.menu.title[a+3].glowAlpha = 1;
			self.menu.title[a+3].x = self.posX;
			self.menu.title[a+3].y = self.textY + 15;
			self.hud.text[a+3].fontScale = self.scale;
			self.hud.text[a+3].glowColor = ((68/255), (143/255), (255/255));
		}
	
		for(b = 0; b < self.menu.optText[self.correctVal].size; b+=1) {
			string += self.menu.optText[self.correctVal][b] + "\n";
		}
		self.hud.text[a] destroy();
		self.hud.text[a] = self drawText(string, "objective", self.scale, self.posX, self.posY, (1, 1, 1), 0, self.menu.color[self.correctVal], 1, 4);
		self.hud.text[a] FadeOverTime(0.3);
		self.hud.text[a].alpha = 1;
		self.hud.text[a].x = self.posX;
		self.hud.text[a].y = self.posY;
		self.hud.text[a].fontScale = self.scale;
		
		string = "";
	}
}

toggleTeddehMenuAdvertisment() {
	if(isDefined(self.menuAd) || self.menuAd == 0) {
		self.menuAd = 1;
		self thread teddehMenuAdvertisment();
	}
	else {
		self.menuAd = 0;
		self notify("stop_menuAd");
		self removeTeddehMenuAdvertisment();
	}
}

teddehMenuAdvertisment() {
    self endon("stop_menuAd");
    self endon ("disconnect");
    
    self.hud.menuAd[0] = self createRectangle("CENTER", "TOP", /*X*/0, /*Y*/0, 800, 30, (0, 0, 0), 0.9, 0, "white");
    self.hud.menuAd[1] = self createRectangle("CENTER", "TOP", /*X*/0, /*Y*/15, 800, 2, ((255/255), (81/255), (81/255)), 1, 0, "white");
    self.hud.menuAd[2] = self createRectangle("CENTER", "TOP", /*X*/0, /*Y*/-15, 800, 2, ((255/255), (81/255), (81/255)), 1, 0, "white");
    self.menuAdText = "Welcome to " + level.PROJECT_NAME + ", Enjoy your stay! I don't know what else to put so i'm just gonna insert this useless text.. Lol.     ";
    self.hud.menuAdText = self drawText("CENTER", "TOP", self.menuAdText, "objective", 2, 0, 0, (1, 1, 1), 1, (0,0,0), 0, 3);

	i = 500;
	for(;;) {
		if(i <= -1000) i = 500;
		self.hud.menuAdText setPoint( "CENTER", "TOP", i, 0);
		self.hud.menuAdText setText(self.menuAdText);
		wait .005;
		i -= 1.5;
	}
}

removeTeddehMenuAdvertisment() {
	for(i = 0; i < 5; i++) self.hud.menuAd[i] destroy();
}


