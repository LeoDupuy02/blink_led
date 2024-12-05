#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

void new_term(int *a, int b);
int read_pin(void);
void init_led(void);

void app_main(void)
{
    init_led();

    /* Tab size */
    int N = 6;

    /* Fill tab with fibonacci sequence's terms */
    int tab[N];
    int *ptr = tab;

    /* initialize counter */
    int i = 0;
    int a;

    /* infinite loop */
    while ( 1 )
    {
        if(i < N){
            a = read_pin();
            if( a==0 ){
                new_term(ptr,i);
                i += 1;
            }
        }
        else{
            i = 0;
        }
    }
}
