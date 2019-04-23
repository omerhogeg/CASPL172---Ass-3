
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern char state[];
extern int WorldWidth;
extern int WorldLength;
 


int cell(int row, int col){
    
    int count_neighbors=0;
    int neb=0;
    
    if(state[form_two_to_one(row,col)] >= '1'){  /* if the current cell is alive  */
         count_neighbors=0;
        /* row above */
       neb=form_two_to_one((row-1+WorldLength) % WorldLength,col);
       if(state[neb] >= '1') {
            count_neighbors++; 
        }
       
       
       neb=form_two_to_one((row-1+WorldLength) % WorldLength,(col-1+WorldWidth) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++;

       }
       
       neb=form_two_to_one((row-1+WorldLength) % WorldLength,(col+1) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++; 
       } 
       
       /* same row */
       
       neb=form_two_to_one(row,(col-1+WorldWidth) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++;
       } 
       
       neb=form_two_to_one(row,(col+1) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++;
       }
       
       /* row below */
        
        neb=form_two_to_one((row+1) % WorldLength,col);
       if(state[neb] >= '1') {
            count_neighbors++; 
       }
       neb=form_two_to_one((row+1) % WorldLength,(col-1+WorldWidth) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++; 
 
       }
       neb=form_two_to_one((row+1) % WorldLength,(col+1) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++; 
       }  
       
       if(count_neighbors==2 || count_neighbors==3){
           /* printf("%d,%d\n",row,col);*/
            count_neighbors=0;
            /*return '1';*/
            char ourVal=state[form_two_to_one(row,col)];
            if(ourVal<'9'){
               ourVal++; 
            }
            return ourVal;
        }
       else{  
           /*printf("%d,%d\n",row,col);*/
           count_neighbors=0;
           /*return '0';*/
           char ourVal=state[form_two_to_one(row,col)];
           ourVal='0';
           return ourVal;
           
       }
    
    }
    
    else{  
          /* row above */
       neb=form_two_to_one((row-1+WorldLength) % WorldLength,col);
       if(state[neb] >= '1') {
            count_neighbors++; 
        }
       
       
       neb=form_two_to_one((row-1+WorldLength) % WorldLength,(col-1+WorldWidth) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++;

       }
       
       neb=form_two_to_one((row-1+WorldLength) % WorldLength,(col+1) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++; 
       } 
       
       /* same row */
       
       neb=form_two_to_one(row,(col-1+WorldWidth) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++;
       } 
       
       neb=form_two_to_one(row,(col+1) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++;
       }
       
       /* row below */
        
        neb=form_two_to_one((row+1) % WorldLength,col);
       if(state[neb] >= '1') {
            count_neighbors++; 
       }
       neb=form_two_to_one((row+1) % WorldLength,(col-1+WorldWidth) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++; 
 
       }
       neb=form_two_to_one((row+1) % WorldLength,(col+1) % WorldWidth);
       if(state[neb] >= '1') {
            count_neighbors++; 
       }  
       
        if(count_neighbors==3){
            /*printf("%d,%d\n",row,col);*/
            count_neighbors=0;
             /*return '1';*/
            char ourVal=state[form_two_to_one(row,col)];
             if(ourVal<'9'){
               ourVal++; 
            }
            return ourVal;
        }
        else{
           /* printf("%d,%d\n",row,col);*/
            count_neighbors=0;
            /*return '0';*/
             char ourVal=state[form_two_to_one(row,col)];
             ourVal='0';
            return ourVal;
        }     
    }
}

int form_two_to_one(int i, int j){
 return ((i* WorldWidth)+j);    
}
