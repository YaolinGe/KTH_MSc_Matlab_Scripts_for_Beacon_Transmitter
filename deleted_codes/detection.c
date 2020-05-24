
void calculate_thresholds32c(int32c* vector, int32_t* thresholds, int Nthresholds, int framestart, int frameend, int vector_len ){
    // Indicate what values are valid as framestart-frameend
    // Calculate Nthresholds number of threshold values over the vector
    int ii_th; int i;
    double hold=0; int variancenum=0;
    int32_t cval;    
    int thrstart; int thrstop; double holder;
    int Nmean=vector_len/Nthresholds;
    for(ii_th=0; ii_th<Nthresholds;ii_th++){
            hold=0; variancenum=0;
            thrstart=ii_th*Nmean;
            thrstop=(ii_th+1)*Nmean;

            // Only calculate thresholds over valid correlation values
            if(thrstart<framestart){
                thrstart=framestart;
            }

            if(thrstop>=frameend){
                // Update window placement to only cover valid correlation values
                thrstop=frameend;
            }
            for (i=thrstart; i<thrstop;i++){
                cval=vector[i].re;
                hold=hold+((double)cval)*((double)cval);
                variancenum++;
            }

            // Calculate variance
            // Insert standard deviation as the base threshold value
            holder=sqrt(hold/variancenum);
            thresholds[ii_th]=(int32_t)(holder);
        }
}

void calculate_thresholds16(int16_t* vector, int16_t* thresholds, int Nthresholds, int framestart, int frameend, int vector_len ){
    // Indicate what values are valid as framestart-frameend
    // Calculate Nthresholds number of threshold values over the vector
    int ii_th; int i;
    double hold=0; int variancenum=0;
    int16_t cval;    
    int thrstart; int thrstop; double holder;
    int Nmean=vector_len/Nthresholds;
    for(ii_th=0; ii_th<Nthresholds;ii_th++)
    {
        hold=0; variancenum=0;
        thrstart=ii_th*Nmean;
        thrstop=(ii_th+1)*Nmean;

        // Only calculate thresholds over valid correlation values
        if(thrstart<framestart){
            thrstart=framestart;
        }

        if(thrstop>=frameend){
            // Update window placement to only cover valid correlation values
            thrstop=frameend;
        }
        for (i=thrstart; i<thrstop;i++){
            cval=vector[i];
            hold=hold+((double)cval)*((double)cval);
            variancenum++;
        }

        // Calculate variance
        // Insert standard deviation as the base threshold value
        holder=sqrt(hold/variancenum);
        thresholds[ii_th]=(int16_t)(holder);
    }
}

int32_t variance_subvector_c(int32c* vector, int istart, int istop, int vectorlen, int scale){
    //int Nsubvector=istop-istart;
    int32_t var=0; // Variance
    int32_t val;
    int i;
    for (i=istart; i<istop; i++){
        if(i<0||i>=vectorlen){
            return var;
        }
        val=vector[i].re;
        var=var+val*val/scale;
    }
    return var;
}

int index_locmin_subvector_c(int32c* vector, int istart, int istop, int vectorlen){

    int32_t locmin=100000000; // Just any large number close to 2^(32-1)
    int ii_locmin=0;
    int j;
    for (j=istart;j<istop;j++){
        
        if(j<0 || j>=vectorlen){
            // Put safeguard against crashes (indexing outside of range)
            return ii_locmin;
        }
        
        if( vector[j].re<locmin || -vector[j].re<locmin ){
            ii_locmin=j;
            if(vector[j].re>=0){
                locmin=vector[j].re;
            }
            else{
                locmin=-vector[j].re;
            }
        }
    }
    
    return ii_locmin;
}

int index_locmax_subvector16(int16_t* vector, int istart, int istop, int vectorlen){
    int16_t locmax=0; 
    int ii_locmax=0;
    int j;
    for (j=istart;j<istop;j++){
        
        if(j<0 || j>=vectorlen){
            // Put safeguard against crashes (indexing outside of range)
            return ii_locmax;
        }
        
        if( vector[j]>locmax || -vector[j]>locmax ){
            ii_locmax=j;
            if(vector[j]>=0){
                locmax=vector[j];
            }
            else{
                locmax=-vector[j];
            }
        }
    }
    
    return ii_locmax;
}

int index_locmax_subvector32(int32_t* vector, int istart, int istop, int vectorlen){

    int32_t locmax=0; 
    int ii_locmax=0;
    int j;
    for (j=istart;j<istop;j++){
        
        if(j<0 || j>=vectorlen){
            // Put safeguard against crashes (indexing outside of range)
            return ii_locmax;
        }
        
        if( vector[j]>locmax || -vector[j]>locmax ){
            ii_locmax=j;
            if(vector[j]>=0){
                locmax=vector[j];
            }
            else{
                locmax=-vector[j];
            }
        }
    }
    
    return ii_locmax;
}

int index_first_exceedence_subvector(int32_t* vector, int32_t threshold, int istart, int istop, int vectorlen){
    int last_trig=0; int i;
    for (i=istart; i<istop; i++){
        if(i>=vectorlen){
            // Break if out of bounds
            return last_trig;
        }
        if(vector[i]>threshold || -vector[i]>threshold){
            last_trig=i;
            return last_trig; 
        }
    }  
    return -1;   
}

int index_last_exceedence_subvector16(int16_t* vector, int16_t threshold, int istart, int istop, int vectorlen){
    int last_trig=0; int i;
    for (i=istart; i<istop; i++){
        if(i>=vectorlen){
            // Break if out of bounds
            return last_trig;
        }
        if(vector[i]>threshold || -vector[i]>threshold){
            last_trig=i;
        }
    }  
    return last_trig;
}

int index_last_exceedence_subvector32(int32_t* vector, int32_t threshold, int istart, int istop, int vectorlen){
    int last_trig=0; int i;
    for (i=istart; i<istop; i++){
        if(i>=vectorlen){
            // Break if out of bounds
            return last_trig;
        }
        if(vector[i]>threshold || -vector[i]>threshold){
            last_trig=i;
        }
    }  
    return last_trig;
}

int index_locmax_subvector_c(int32c* vector, int istart, int istop, int vectorlen){
    // Find real local maxima

    int32_t locmax=0; 
    int ii_locmax=0;
    int j;
    for (j=istart;j<istop;j++){
        
        if(j<0 || j>=vectorlen){
            // Put safeguard against crashes (indexing outside of range)
            return ii_locmax;
        }
        
        if( vector[j].re>locmax || -vector[j].re>locmax ){
            ii_locmax=j;
            if(vector[j].re>=0){
                locmax=vector[j].re;
            }
            else{
                locmax=-vector[j].re;
            }
        }
    }
    
    return ii_locmax;
}
