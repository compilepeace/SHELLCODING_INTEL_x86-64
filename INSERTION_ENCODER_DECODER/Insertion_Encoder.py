#!/usr/bin/python


# Fill in the shellcode to be encoded in the 'shellcode' variable

shellcode = ("")


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
