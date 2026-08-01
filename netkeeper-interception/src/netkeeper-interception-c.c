#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "pppd/pppd.h"
#include "pppd/chap.h"
#include "pppd/upap.h"
typedef unsigned char byte;
//TODO : change the version here
char pppd_version[] = PPPOE_VER;

static unsigned char saveuser[MAXNAMELEN] = {0};
static unsigned char savepwd[MAXSECRETLEN] = {0};

static int pap_modifyaccount(char *user, char *passwd)
{
	uint8_t len_user;
	uint8_t len_passwd;
	FILE *dF = fopen ("/var/Last_AuthReq", "r");
	if(!dF){
		return 0;
	}
	memset(saveuser, 0, sizeof(saveuser));
	memset(savepwd, 0, sizeof(savepwd));
	if(fread(&len_user,1,1,dF) != 1 ||
	   fread(&saveuser,1,len_user,dF) != len_user ||
	   fread(&len_passwd,1,1,dF) != 1 ||
	   fread(&savepwd,1,len_passwd,dF) != len_passwd){
		fclose(dF);
		return 0;
	}
	fclose(dF);
	strcpy(user, saveuser);
	strcpy(passwd, savepwd);
	return 1;
}

static int check()
{
	return 1;
}

void plugin_init(void)
{
	info("Netkeeper-interception: Account Loader Initialized");
	pap_check_hook=check;
	chap_check_hook=check;
	pap_passwd_hook=pap_modifyaccount;
	chap_passwd_hook=pap_modifyaccount;
}
