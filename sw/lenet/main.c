// ================================================================================ //
// The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32              //
// Copyright (c) NEORV32 contributors.                                              //
// Copyright (c) 2020 - 2024 Stephan Nolting. All rights reserved.                  //
// Licensed under the BSD-3-Clause license, see LICENSE for details.                //
// SPDX-License-Identifier: BSD-3-Clause                                            //
// ================================================================================ //

/**********************************************************************//**
 * @file demo_blink_led/main.c
 * @author Sameed_Sohail
 * @brief LeNet5 Implementation
 **************************************************************************/
#include <neorv32.h>
#include <stdint.h>
#include <stdbool.h>
#include <float.h>
#include <math.h>

/**********************************************************************//**
 * Address Regions in Memory *
 **************************************************************************/
#define PARAM_DMEM_ADDR     0x80000400
#define DELTAPRM_DMEM_ADDR  0x80040400
#define VELPRM_DMEM_ADDR    0x80080400
#define ACT_DMEM_ADDR       0x800C0400
#define DELTAACT_DMEM_ADDR  0x800D0400
#define IMG_DMEM_ADDR       0x800E0400
#define DMEM_END_ADDR       0x80100000

/**********************************************************************//**
 * Constants*
 **************************************************************************/
//Define parameters [Sizes of layers etc.]
const uint32_t row_col_in = 28;
//layer1
const uint32_t f1_size = 5; //5x5
const uint32_t f1_in_channel = 1;
const uint32_t f1_pad = 2;
const uint32_t f1_stride = 1;
const uint32_t f1_out_channel = 6; //same as f2_in_channel
const uint32_t row_col_out_f1 = (((row_col_in + 2*f1_pad - f1_size)) / f1_stride) + 1;
//
const uint32_t max_pool2_f1 = (row_col_out_f1)/2;
//layer2
const uint32_t f2_size = 5; //5x5
const uint32_t f2_in_channel = 6;
const uint32_t f2_pad = 0;
const uint32_t f2_stride = 1;
const uint32_t f2_out_channel = 16;
const uint32_t row_col_out_f2 = (((max_pool2_f1 + 2*f2_pad - f2_size)) / f2_stride) + 1;
//
const uint32_t max_pool2_f2 = (row_col_out_f2)/2;
//
const uint32_t n3 = 120; //layer3
const uint32_t n4 = 84; //layer4
const uint32_t n5 = 10; //layer5

//Offsets (Word Boundary Aligned)[starting]
//parameters (same for all training param structures)
const uint32_t w1_offs          = 0; //Layer1
const uint32_t b1_offs          = f1_out_channel*f1_in_channel*f1_size*f1_size + w1_offs; 
const uint32_t w2_offs          = f1_out_channel + b1_offs; //Layer2
const uint32_t b2_offs          = f2_out_channel*f2_in_channel*f2_size*f2_size + w2_offs;
const uint32_t w3_offs          = f2_out_channel + b2_offs; //Layer3
const uint32_t b3_offs          = n3*f2_out_channel*max_pool2_f2*max_pool2_f2 + w3_offs;
const uint32_t w4_offs          = n3 + b3_offs; //Layer4
const uint32_t b4_offs          = n4*n3 + w4_offs;
const uint32_t w5_offs          = n4 + b4_offs; //Layer5
const uint32_t b5_offs          = n5*n4 + w5_offs;
//Activations_Offsets
const uint32_t a1_offs          = 0; //Layer1
const uint32_t m1_offs          = f1_out_channel*row_col_out_f1*row_col_out_f1 + a1_offs;
const uint32_t m1_index_offs    = f1_out_channel*max_pool2_f1*max_pool2_f1 + m1_offs; 
const uint32_t a2_offs          = f1_out_channel*max_pool2_f1*max_pool2_f1 + m1_index_offs; //Layer2
const uint32_t m2_offs          = f2_out_channel*row_col_out_f2*row_col_out_f2 + a2_offs;
const uint32_t m2_index_offs    = f2_out_channel*max_pool2_f2*max_pool2_f2 + m2_offs;
const uint32_t a3_offs          = f2_out_channel*max_pool2_f2*max_pool2_f2 + m2_index_offs; //Layer3
const uint32_t a4_offs          = n3 + a3_offs; //Layer4
const uint32_t a5_offs          = n4 + a4_offs; //Layer5
//Delta_Activation_Offsets
const uint32_t dz5_offs         = 0; //Layer5
const uint32_t dz4_offs         = n5 + dz5_offs; //Layer4
const uint32_t dz3_offs         = n4 + dz4_offs; //Layer3
const uint32_t dz2_offs         = n3 + dz3_offs; //Layer2
const uint32_t dm1_offs         = f2_out_channel*row_col_out_f2*row_col_out_f2 + dz2_offs; //Layer1
const uint32_t dz1_offs         = f1_out_channel*max_pool2_f1*max_pool2_f1 + dm1_offs;

/**********************************************************************//**
 * Pointers*
 **************************************************************************/
//Pointer Loc Storage
volatile float* const param_ptr = (float*) (PARAM_DMEM_ADDR); //Pointer to all parameters
//Delta Parameters Loc Storage
volatile float* const deltaparam_ptr = (float*) (DELTAPRM_DMEM_ADDR);
//
volatile float* const velparam_ptr = (float*) (VELPRM_DMEM_ADDR);
//
volatile float* const activ_ptr = (float*) (ACT_DMEM_ADDR);
//
volatile float* const deltaactiv_ptr = (float*) (DELTAACT_DMEM_ADDR);
//
volatile float* const imginp_ptr = (float*) (IMG_DMEM_ADDR);
//XBUS [UINT32]
volatile uint32_t* const xbus_out =   (uint32_t*) (DMEM_END_ADDR);


/**********************************************************************//**
 * SUPPORT FUNCTIONS*
 **************************************************************************/
//2D Convolution Function (for same dimension height/width) with per-output channel bias + RELU addition
void conv2D(volatile float* output, volatile float* bias_scalar, bool bias_relu_en, volatile float* input, int32_t inp_h_w, volatile float* kernel, int32_t kernel_size, int32_t stride, int32_t padding)
{
    //INPUT [inp_h_w,inp_h_w], bias_scalar (per o/p channel), KERNEL[kernel_size,kernel_size]
    int32_t out_h_w = 0;
    int32_t r = 0;
    int32_t c = 0;
    int32_t fr = 0;
    int32_t fc = 0;
    int32_t r_temp = 0;
    int32_t c_temp = 0;
    int32_t fr_temp = 0;
    int32_t fc_temp = 0;
    float temp = 0.0f;

    //size calc of output
    out_h_w = ((inp_h_w + 2 * padding - kernel_size) / stride) + 1;

    for (r = 0; r < out_h_w; r++) {
        //
        for(c = 0; c < out_h_w; c++) {
            //
            r_temp = r*stride - padding;
            c_temp = c*stride - padding;
            //
            temp = 0.0f;
            //
            for(fr=0; fr<kernel_size ; fr++){
            //
                for(fc=0; fc<kernel_size ; fc++){
                    //
                    fr_temp = r_temp + fr;
                    fc_temp = c_temp + fc;
                    //
                    if (fr_temp >= 0 && fr_temp < inp_h_w && fc_temp >= 0 && fc_temp < inp_h_w) {
                        float val = input[fr_temp * inp_h_w + fc_temp];
                        float k_val = kernel[fr * kernel_size + fc];
                        //
                        temp += val * k_val;
                    }
                }
            }
            //
            
            //Perform bias addition if required
            if( bias_relu_en == 1 ){
                //bias addition
                temp += *(bias_scalar);
                //ReLU Activation
                if( temp < 0.0f ){
                    temp = 0.0f;
                }
            }
            
            output[r*out_h_w + c] = temp;

        }
    }       
}

//3D Convolution Function (for same dimension height/width) with per-output channel bias + RELU addition
void conv3D(volatile float* output, volatile float* bias_scalar, bool bias_relu_en, volatile float* input, int32_t inp_channel, int32_t inp_h_w, volatile float* kernel, int32_t kernel_size, int32_t stride, int32_t padding)
{
    //INPUT [inp_channel,inp_h_w,inp_h_w], bias_scalar (per o/p channel), KERNEL[1,inp_channel,kernel_size,kernel_size] //only for one o/p channel
    int32_t out_h_w = 0;
    int32_t r = 0;
    int32_t c = 0;
    int32_t ch_in = 0;
    int32_t fr = 0;
    int32_t fc = 0;
    int32_t r_temp = 0;
    int32_t c_temp = 0;
    int32_t fr_temp = 0;
    int32_t fc_temp = 0;
    float temp = 0.0f;

    //size calc of output
    out_h_w = ((inp_h_w + 2 * padding - kernel_size) / stride) + 1;

    for (r = 0; r < out_h_w; r++) {
        //
        for(c = 0; c < out_h_w; c++) {
            //
            r_temp = r*stride - padding;
            c_temp = c*stride - padding;
            //
            temp = 0.0f;
            //
            for(ch_in=0; ch_in<inp_channel ; ch_in++) {
                //
                for(fr=0; fr<kernel_size ; fr++){
                //
                    for(fc=0; fc<kernel_size ; fc++){
                        //
                        fr_temp = r_temp + fr;
                        fc_temp = c_temp + fc;
                        //
                        if (fr_temp >= 0 && fr_temp < inp_h_w && fc_temp >= 0 && fc_temp < inp_h_w) {
                            float val = input[ch_in*(inp_h_w*inp_h_w) + fr_temp*inp_h_w + fc_temp];
                            float k_val = kernel[ch_in*(kernel_size*kernel_size) + fr*kernel_size + fc];
                            //
                            temp += val * k_val;
                        }
                    }
                }
            }
            //
            
            //Perform bias addition if required
            if( bias_relu_en == 1 ){
                //bias addition
                temp += *(bias_scalar);
                //ReLU Activation
                if( temp < 0.0f ){
                    temp = 0.0f;
                }
            }
            
            output[r*out_h_w + c] = temp;

        }
    }       
}

//MaxPool2D [Per Channel Basis] // Only valid if input size is even and at least 2
void max_pool2D_w_index(volatile float* output, volatile float* output_index, volatile float* input, int32_t inp_h_w)
{
    //INPUT [inp_h_w,inp_h_w], output_index (convert to float before writing)
    int32_t out_h_w = 0;
    int32_t r = 0;
    int32_t c = 0;
    int32_t fr = 0;
    int32_t fc = 0;
    int32_t r_temp = 0;
    int32_t c_temp = 0;
    int32_t fr_temp = 0;
    int32_t fc_temp = 0;
    //
    float temp[4]; //stroing max_pool index
    //
    int32_t max_index = 0;
    float max_value = 0.0f; 

    //size calc of output
    out_h_w = ((inp_h_w - 2) / 2) + 1;

    for (r = 0; r < out_h_w; r++) {
        //
        for(c = 0; c < out_h_w; c++) {
            //
            r_temp = r*2;
            c_temp = c*2;
            //2x2 maxpool
            for(fr=0; fr<2 ; fr++){
            //
                for(fc=0; fc<2 ; fc++){
                    //
                    fr_temp = r_temp + fr;
                    fc_temp = c_temp + fc;
                    //
                    temp[fr*2+fc] = input[fr_temp*inp_h_w + fc_temp];
                }
            }
            //maxIndex & value
            max_value = temp[0];
            max_index = 0;

            for(int32_t i = 1; i < 4; i++) {
                if (temp[i] > max_value) {
                    max_value = temp[i];
                    max_index = i;
                }
            }
            
            output[r*out_h_w + c] = max_value;
            output_index[r*out_h_w + c] = (float) max_index;    
        }
    }       
}

//Softmax
void softmax(volatile float* input, int32_t length) {
    float max_val = input[0];
    
    // find max value
    for (int32_t i = 1; i < length; i++) {
        if(input[i] > max_val) {
            max_val = input[i];
        }
    }
    //Compute exponentials & sum
    float sum_exp = 0.0f;
    //
    for (int32_t i = 0; i < length; i++) {
        input[i] = expf(input[i] - max_val);  // shifted for stability
        sum_exp += input[i];
    }
    //Normalize to get probabilities
    for (int32_t i = 0; i < length; i++) {
        input[i] /= sum_exp;
    }
}

//LeNet5 Inference: ForwardPass
void leNet5_inference(volatile float* image){

    //Perform inference on an image LeNet5

    //A1 = ReLU(Z1), Z1 = W1(CONV)INP + b1 
    for(uint32_t i=0; i<f1_out_channel; i++){
        //
        //conv2D(activ_ptr+a1_offs+i*(row_col_out_f1*row_col_out_f1), param_ptr+b1_offs+i,(bool) 1, image, row_col_in, param_ptr+w1_offs+i*(f1_size*f1_size), f1_size, f1_stride, f1_pad);
        conv3D(activ_ptr+a1_offs+i*(row_col_out_f1*row_col_out_f1), param_ptr+b1_offs+i, (bool) 1, image, f1_in_channel, row_col_in, param_ptr+w1_offs+i*(f1_in_channel*f1_size*f1_size), f1_size, f1_stride, f1_pad);
    }
    //M1, M1_INDEX = MAXPOOL2D(A1)
    for(uint32_t i=0; i<f1_out_channel; i++){
        max_pool2D_w_index(activ_ptr+m1_offs+i*(max_pool2_f1*max_pool2_f1), activ_ptr+m1_index_offs+i*(max_pool2_f1*max_pool2_f1), activ_ptr+a1_offs+i*(row_col_out_f1*row_col_out_f1), row_col_out_f1);
    }
    //A2 = ReLU(Z2), Z2 = W2(CONV)M1 + b2 
    for(uint32_t i=0; i<f2_out_channel; i++){
        //
        conv3D(activ_ptr+a2_offs+i*(row_col_out_f2*row_col_out_f2), param_ptr+b2_offs+i, (bool) 1, activ_ptr+m1_offs, f2_in_channel, max_pool2_f1, param_ptr+w2_offs+i*(f2_in_channel*f2_size*f2_size), f2_size, f2_stride, f2_pad);
    }
    //M2, M2_INDEX = MAXPOOL2D(A2)
    for(uint32_t i=0; i<f2_out_channel; i++){
        max_pool2D_w_index(activ_ptr+m2_offs+i*(max_pool2_f2*max_pool2_f2), activ_ptr+m2_index_offs+i*(max_pool2_f2*max_pool2_f2), activ_ptr+a2_offs+i*(row_col_out_f2*row_col_out_f2), row_col_out_f2);
    }
    //A3 = ReLU(Z3) Z3 = W3*flatten(M2)+b3
    for(uint32_t i=0; i<n3; i++){
        //clear
        activ_ptr[a3_offs+i] = 0.0f;
        //
        for(uint32_t j=0; j<f2_out_channel*max_pool2_f2*max_pool2_f2; j++){
            activ_ptr[a3_offs+i] += param_ptr[w3_offs+i*f2_out_channel*max_pool2_f2*max_pool2_f2+j] * activ_ptr[m2_offs+j];
        }
        //Bias
        activ_ptr[a3_offs+i] += param_ptr[b3_offs+i];
        //RELU
        if( activ_ptr[a3_offs+i] < 0.0f )
        {
            activ_ptr[a3_offs+i] = 0.0f;
        }
    }
    //A4 = ReLU(Z4) Z4 = W4*A3+b4
    for(uint32_t i=0; i<n4; i++){
        //clear
        activ_ptr[a4_offs+i] = 0.0f;
        //
        for(uint32_t j=0; j<n3; j++){
            activ_ptr[a4_offs+i] += param_ptr[w4_offs+i*n3+j] * activ_ptr[a3_offs+j];
        }
        //Bias
        activ_ptr[a4_offs+i] += param_ptr[b4_offs+i];
        //RELU
        if( activ_ptr[a4_offs+i] < 0.0f )
        {
            activ_ptr[a4_offs+i] = 0.0f;
        }
    }
    //Z5 = W5*A4+b5
    for(uint32_t i=0; i<n5; i++){
        //clear
        activ_ptr[a5_offs+i] = 0.0f;
        //
        for(uint32_t j=0; j<n4; j++){
            activ_ptr[a5_offs+i] += param_ptr[w5_offs+i*n4+j] * activ_ptr[a4_offs+j];
        }
        //Bias
        activ_ptr[a5_offs+i] += param_ptr[b5_offs+i];
        //
    }
    //A5 = Softmax(Z5)
    softmax(activ_ptr+a5_offs, n5);

}
/**********************************************************************//**
 * MAIN Function*
 **************************************************************************/
//MAIN
int main(int argc, char *argv[]) {
    
    // enable machine external interrupt
    neorv32_cpu_csr_set(CSR_MIE, (1 << CSR_MIE_MEIE));

    // enable sleep cntr in tb
    neorv32_gpio_pin_set(1, 1);
    neorv32_cpu_sleep();
    neorv32_gpio_pin_set(1, 0);

    neorv32_gpio_pin_set(3, 1);
    *(uint32_t *0xffffb800) = 0;
    //Forward Pass: LeNet5
    leNet5_inference(imginp_ptr + 0*(row_col_in*row_col_in));
    neorv32_gpio_pin_set(3, 0);

    //Send all memory on XBUS
    int32_t j=0;
    
    neorv32_gpio_pin_set(2, 1);
    //Check all memory
    // for(int32_t i=0; i < (DMEM_END_ADDR-0x80000000)/4 ; i++){
    //     if( i < 256 ){
    //         xbus_out[i] = 0x00000000;
    //     }
    //     else{
    //         xbus_out[i] = *(((uint32_t*) param_ptr)+j);
    //         j+=1;
    //     }
    // }

    //activations sent
    for (uint32_t i = 0; i < n5; i++) {
        xbus_out[i] = *(((uint32_t*) activ_ptr)+a5_offs+i);
    }
    neorv32_gpio_pin_set(2, 0);

    // enable sleep cntr in tb
    neorv32_gpio_pin_set(1, 1);
    neorv32_cpu_sleep();
    neorv32_gpio_pin_set(1, 0);

    // signal end of simulation
    neorv32_gpio_pin_set(0, 1);
}

