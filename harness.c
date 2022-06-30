#include <sys/mman.h>
#include <unistd.h>

int main ()
{
    void *code = mmap((void *)0x1337000, 0x1000, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANON, 0, 0);
    read(0, code, 0x1000);
	__asm__ ( 
				"movq $0xaabbccddaabbccdd, %rax\t\n"
				"movq $0xaabbccddaabbccdd, %rdi\t\n"
				"movq $0xaabbccddaabbccdd, %rsi\t\n"
				"movq $0xaabbccddaabbccdd, %rdx\t\n"
				"movq $0xaabbccddaabbccdd, %rcx\t\n"
				"movq $0xaabbccddaabbccdd, %r8\t\n"
				"movq $0xaabbccddaabbccdd, %r9\t\n"
	);
    ((void(*)())code)();
}
