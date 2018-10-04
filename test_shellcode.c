// To extract shellcode use the bellow command
// $ for i in $(objdump -d helloworld |grep "^ " |cut -f2); do echo -n '\x'$i; done; echo 


#include <stdio.h>
#include <string.h>


unsigned char code[] = \
"\x48\x31\xc0\x40\x88\xc7\x04\x3c\x0f\x05";


int main()
{
	printf("Shellcode length : %d \n", (int )strlen(code));	

	int  (*ret)() = (int (*)())code; 

	ret();
}
