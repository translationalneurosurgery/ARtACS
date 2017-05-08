function Kernel = symmetric(NumberPeriods,freq,Fs,wfun,tau,dirflag,delay)
                 
    L                   = 2*ceil(NumberPeriods)*(Fs/freq);    
    NumberPeriods   	= (NumberPeriods./2);
    
    if nargin > 3
        if nargin > 4
            if nargin > 5
                if nargin > 6
                    Kernel = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun,tau,dirflag,delay);
                else
                    Kernel = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun,tau,dirflag);
                end
            else
                Kernel = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun,tau);
            end
        else
            Kernel = artacs.kernel.causal(NumberPeriods,freq,Fs,wfun);
        end
    else
        Kernel = artacs.kernel.causal(NumberPeriods,freq,Fs);   
    end
    kernel = Kernel.h;
    kernel = (kernel+fliplr(kernel))./2;
    
    while length(kernel) < L
        kernel = [0,kernel,0];
    end
    
    Kernel.h     = kernel;
end
