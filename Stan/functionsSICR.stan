functions {
         // time transition functions for beta and sigmac
           real transition(real base,real location,real t) {
                return base + (1-base)/(1 + exp(.2*(t - location)));
           }

         // nonlinear SICR model ODE function
           real[] SICR(
           real t,             // time
           real[] u,           // system state {infected,cases,susceptible}
           real[] theta,       // parameters
           real[] x_r,
           int[] x_i
           )
           {
             real du_dt[5];
             real f1 = theta[1];          // beta - sigmau - sigmac
             real f2 = theta[2];          // beta - sigma u
             real sigmar = theta[3];
             real sigmad =  theta[4];
             real sigmau = theta[5];
             real q = theta[6];
             real mbase = theta[7];
             real mlocation = theta[8];
             real cbase = theta[9];
             real clocation = theta[10];

             real sigma = sigmar + sigmad;
             real sigmac = f2/(1+f1);
             real beta = f2 + sigmau;

             real I = u[1];  // infected, latent
             real C = u[2];  // cases, observed
             real Z = u[3];  // total infected

             sigmac *= cbase + (1-cbase)/(1 + exp(.2*(t - clocation)));  // case detection change
             beta *= mbase + (1-mbase)/(1 + exp(.2*(t - mlocation)));  // mitigation

             du_dt[1] = beta*(I+q*C)*(1-Z) - sigmac*I - sigmau*I; //I
             du_dt[2] = sigmac*I - sigma*C;       //C
             du_dt[3] = beta*(I+q*C)*(1-Z);                       //N_I
             du_dt[4] = sigmac*I; // N_C case appearance rate
             du_dt[5] = C; // integrated C

             return du_dt;
            }
        }
