#include <stdint.h>

extern void __attribute__((naked)) __attribute__((section(".isr_vector"))) isr_vector(void)
{
    asm volatile("j _start");
    asm volatile("j _start");
}

void __attribute__((noreturn)) main(void);

extern void __attribute__((naked)) _start(void)
{
    asm volatile("la sp, stack_top");
    main();
}

static volatile uint32_t *const REG_GPIO_OUT = (volatile uint32_t *)0xA0000000;
static volatile uint32_t *const REG_UART_TX = (volatile uint32_t *)0xB0000000;
static volatile uint32_t *const REG_UART_RX = (volatile uint32_t *)0xC0000000;

void __attribute__((noreturn)) main(void)
{
    uint8_t *str;
    while (1)
    {
        // while (*(volatile uint32_t *)0xC0000004 == 0x0)
        //     ;
        // str = (uint8_t *)0xC0000000;
        while (*(volatile uint32_t *)0xB0000004 == 0x0)
            ;
        // *(uint32_t *)0xB0000000 = (uint32_t) * (str);
        *(uint32_t *)0xB0000000 = 0x41;
    }
}