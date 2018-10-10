#!/bin/python


# Place your shellcode into 'shellcode' variable and the output will return the XOR encoded 
# shellcode with 0xAA as encoding byte.


shellcode = ""

str1 = ""
str2 = ""


for i in bytearray(shellcode):
	#print "%x" %i	
	encoded = i ^ 0xAA
	str1 += "\\x%x" % encoded
	str2 += "0x%x, " % encoded


print str1
print str2
	

