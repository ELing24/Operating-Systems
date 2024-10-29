#include "types.h"
#include "user.h"

int waitpid(int pid, int *status, int options);
void waitpidtest(void){
	int pid, status;
	int arrOfIds[10] = {0};
	for(int i =0; i < 5; ++i){
		pid = fork();
		//printf(1, "PID at arrOfIds %d: %d\n", i, pid);
		if(pid == 0){
			exit(0);
		}
		 //printf(1, "New PID at arrOfIds %d: %d\n", i, pid);
		arrOfIds[i] = pid;
	}
	int waitpidResult;
	printf(1, "Searching For Child With PID: %d\n", arrOfIds[0]);
	waitpidResult = waitpid(arrOfIds[0], &status, 0);
	printf(1, "Result From Waitpid Function: %d\n", waitpidResult);

	printf(1, "Searching For Child With PID: %d\n", arrOfIds[1]);
        waitpidResult = waitpid(arrOfIds[1], &status, 0);
        printf(1, "Result From Waitpid Function: %d\n", waitpidResult);

	printf(1, "Searching For Child With PID: %d\n", arrOfIds[2]);
        waitpidResult = waitpid(arrOfIds[2], &status, 0);
        printf(1, "Result From Waitpid Function: %d\n", waitpidResult);

	printf(1, "Searching For Child With PID: %d\n", arrOfIds[3]);
        waitpidResult = waitpid(arrOfIds[3], &status, 0);
        printf(1, "Result From Waitpid Function: %d\n", waitpidResult);

	printf(1, "Searching For Child With PID: %d\n", 100);
        waitpidResult = waitpid(100, &status, 0);
        printf(1, "Result From Waitpid Function: %d\n", waitpidResult);

	
}
int main(void){
	waitpidtest();
	exit(0);
}
