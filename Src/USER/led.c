#include "led.h"

void LED_Init(void)
{
  // 使能时钟
  RCC->APB2ENR |= 1 << 6;
  // 配置与模式 通用推挽输出 50MHz
  GPIOE->CRL &= 0XF00FFFFF;
  GPIOE->CRL |= 0X00300000;
	GPIOE->CRL |= 0X03000000;

  GPIOE->ODR &= ~(1 << 5);
}