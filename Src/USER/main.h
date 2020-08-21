#ifndef __MAIN_H
#define __MAIN_H

#include <stm32f10x.h>
#include <stm32f10x_rcc.h>
#include <stm32f10x_gpio.h>

#define LED1_OFF GPIO_SetBits(GPIOE,GPIO_Pin_5);
#define LED1_ON GPIO_ResetBits(GPIOE,GPIO_Pin_5);
#define LED2_OFF GPIO_SetBits(GPIOE,GPIO_Pin_6);
#define LED2_ON GPIO_ResetBits(GPIOE,GPIO_Pin_6);

#endif // !__MAIN_H
