#include "stm32f10x_it.h" 



void NMI_Handler(void)
{
}

void HardFault_Handler(void)
{
  /* Go to infinite loop when Hard Fault exception occurs */
  while (1)
  {
  }
}

void MemManage_Handler(void)
{
  /* Go to infinite loop when Memory Manage exception occurs */
  while (1)
  {
  }
}


void BusFault_Handler(void)
{
  /* Go to infinite loop when Bus Fault exception occurs */
  while (1)
  {
  }
}

void UsageFault_Handler(void)
{
  /* Go to infinite loop when Usage Fault exception occurs */
  while (1)
  {
  }
}

void SVC_Handler(void)
{
}

void DebugMon_Handler(void)
{
}

void PendSV_Handler(void)
{
}

void SysTick_Handler(void)
{
}

void EXTI4_IRQHandler(void)
{     	
  if(EXTI_GetITStatus(EXTI_Line4) != RESET)	  
	{	  
		GPIO_WriteBit(GPIOE, GPIO_Pin_5, (BitAction)(1-(GPIO_ReadOutputDataBit(GPIOE, GPIO_Pin_5))));
	}
	EXTI_ClearITPendingBit(EXTI_Line4);  
}