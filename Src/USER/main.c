#include "stdio.h"

//使用keil_v5，必须在mian.c加入这个函数
void assert_failed(uint8_t* file, uint32_t line)
{
	printf("Wrong parameters value: file %s on line %d\r\n", file, line);
	while(1);
}

int main(void)
{
	while(1)
	{
	}
	return 0;
}


