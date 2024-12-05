#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

void blink_led(int a);
int read_pin(void);
void gen_fib_seq(int *a, int b);
void init_led(void);

void app_main(void)
{
    init_led();

    /* Tab size */
    int N = 4;

    /* Fill tab with fibonacci sequence's terms */
    int tab[N];
    int *ptr = tab;
    gen_fib_seq(ptr, N);

    /* initialize counter */
    int i = 0;

    /* infinite loop */
    while ( 1 )
    {
        if(i < N){
            int a = read_pin();
            if( a==0 ){
                blink_led(tab[i]);
                i += 1;
            }
        }
        else{
            i = 0;
        }
    }
}
