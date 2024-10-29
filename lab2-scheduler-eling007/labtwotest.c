#include "types.h"
#include "user.h"

#define SIZE 23000
#define N 10
void arr_processing(){
		int i, j, k;
                int A[SIZE][SIZE];
                int B[SIZE][SIZE];
                int C[SIZE][SIZE];

                // Initialize matrices A and B
        	for (i = 0; i < SIZE; i++) {
                	for (j = 0; j < SIZE; j++) {
                		A[i][j] = i + j;
                		B[i][j] = i - j;
                		C[i][j] = 0;
                	}
        	}

        	// Perform matrix multiplication
        	for (i = 0; i < SIZE; i++) {
                	for (j = 0; j < SIZE; j++) {
                        	for (k = 0; k < SIZE; k++) {
                                C[i][j] += A[i][k] * B[k][j];
                        	}
                	}
        	}

}
int main(void){
	int pid1 = -1;
		
 	int n = 0;
        for(n  = 1; n <= N; n++)
	{	
		if(pid1 != -1 && pid1 > 0){
	 		pid1 = fork();	
	
		}
		else if(pid1 == -1 && n == 1){
			pid1 = fork();
			if(pid1 > 0)
			{
				setpriority(3);
				arr_processing();
			}
			
		}
		if(pid1 == 0)
		{
			setpriority(n%10);
			arr_processing();
			break;
		}	
	
  
	}
	exit();	
	
	return 0;

}
