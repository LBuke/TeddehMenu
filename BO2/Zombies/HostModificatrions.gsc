/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Name : HostModificatrions
*	 Description : 
*	 Date : 2017/06/26 - 10:51:26	
*
*/	

initHostModifications() {
	self.fhost = false;
}

/* FORCE HOST */
forceHost() {
    if(!self.fhost) {
        setDvar("party_connectToOthers" , "0");
        setDvar("partyMigrate_disabled" , "1");
        setDvar("party_mergingEnabled" , "0");
    }
    else {
        setDvar("party_connectToOthers" , "1");
        setDvar("partyMigrate_disabled" , "0");
        setDvar("party_mergingEnabled" , "1");
    }
    
    toggleMessage("Force Host", self.fhost = !self.fhost);
}
