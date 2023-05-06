#include <stdio.h>

int main (int argc, char **argv)
{
	// check for cmdline args provided
	if (argc != 3){
		printf ("[-] Demystify the %s's usage: try again !\n", argv[0]);
		return 7;
	}
	
	printf ("[+] Greetings, you can move ahead now.\nBTW, you entered - %s, %s\n", argv[1], argv[2]);

	return 0;
}
