#include <stdio.h>
#include <string.h>

int vulnerable (char *source, int source_length) 
{
	int x = 0, y = 1;
	char buffer[64];

	x = strncpy(buffer, source, source_length);

	return x;
} 

int main (int argc, char **argv)
{
	vulnerable (argv[1], strlen(argv[1])); 
}
