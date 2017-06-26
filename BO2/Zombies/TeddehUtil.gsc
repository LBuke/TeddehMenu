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
    level.PROJECT_VERSION = 0.2;
    level.MENU_NAME = level.PROJECT_NAME + " " + level.PROJECT_VERSION;
}

teddehLog(type, message) {
    str = "";
    switch(type) {
        case "ERROR":   str = "^1Error";   break;
        case "WARNING": str = "^6Warning"; break;
        case "SUCCESS": str = "^2Success"; break;
        case "INFO": str = "^2Info"; break;
    }
    self iPrintln(str + "^3: ^8" + message);
}

sendMessage(type, str, time) {
    self.teddehMsg = createfontstring( type, 1.9 );
    self.teddehMsg.x = 0;
    self.teddehMsg.y = 20.11;
    self.teddehMsg settext(str);
    self.teddehMsg.glowcolor = ( 0, 0, 1 );
    self.teddehMsg.glowalpha = 1;
    self.teddehMsg.alpha = 1;
    self.teddehMsg settypewriterfx( 30, 999999999, 999999999 );
    self.teddehMsg.archived = 0;
//    alexicon = self drawshader( "lui_loader_no_offset", 0, 80.11, 41, 41, ( 1, 1, 1 ), 0, 0 );
//    alexicon.archived = 0;
//    alexicon.alpha = 1;
    wait time;
    self.teddehMsg destroy();
//    alexicon destroy();
}

toggleMessage(str, status) {
    self iprintln( "^3" + str + " ^8[" + (status ? "^2On" : "^1Off") + "^8]" );
}

createText(font, fontscale, align, relative, x, y, sort, color, alpha, glowColor, glowAlpha, text) {
	textElem = CreateFontString( font, fontscale );
	textElem setPoint( align, relative, x, y );
	textElem.sort = sort;
	textElem.type = "text";
	textElem setText(text);
	textElem.color = color;
	textElem.alpha = alpha;
	textElem.glowColor = glowColor;
	textElem.glowAlpha = glowAlpha;
	textElem.hideWhenInMenu = true;
	return textElem;
}

createText(font, fontscale, x, y, sort, color, alpha, glowColor, glowAlpha, text) {
	textElem = self createFontString(font, fontscale);
	textElem.x = x;
	textElem.y = y;
	textElem.align = "CENTER";
	textElem.sort = sort;
	textElem.type = "text";
	textElem setText(text);
	textElem.color = color;
	textElem.alpha = alpha;
	textElem.glowColor = glowColor;
	textElem.glowAlpha = glowAlpha;
	textElem.hideWhenInMenu = true;
	return textElem;
}

drawText(text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort) {
    hud = self createFontString(font, fontScale);
    hud setText(text);
    hud setPoint("CENTER", "TOP", x, y);
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    return hud;
}

drawText(align, relative, text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort) {
    hud = self createFontString(font, fontScale);
    hud setText(text);
    hud setPoint(align, relative, x, y);
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    return hud;
}

createRectangle(align, relative, x, y, width, height, color, alpha, sorting, shadero) {
	barElemBG = newClientHudElem(self);
	barElemBG.elemType = "bar";
	if (!level.splitScreen) {
		barElemBG.x = -2;
		barElemBG.y = -2;
	}
	
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.align = align;
	barElemBG.relative = relative;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.children = [];
	barElemBG.color = color;
	if(isDefined(alpha)) barElemBG.alpha = alpha;
	else barElemBG.alpha = 1;
	barElemBG setShader( shadero, width , height );
	barElemBG.hidden = false;
	barElemBG.sort = sorting;
	barElemBG setPoint(align,relative,x,y);
	return barElemBG;
}

//drawShader(shader, x, y, width, height, color, alpha, sort) {
//    hud = newClientHudElem(self);
//    hud.elemtype = "icon";
//    hud.color = color;
//    hud.alpha = alpha;
//    hud.sort = sort;
//    hud.children = [];
//    hud setParent(level.uiParent);
//    hud setShader(shader, width, height);
//    hud setPoint("CENTER", "TOP", x, y);
//    return hud;
//}





