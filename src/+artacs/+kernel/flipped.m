% function Kernel = flipped(NumberPeriods,freq,Fs,wfun)    

function Kernel = flipped(NumberPeriods,freq,Fs,wfun,tau)    
      
    
    % prepare variables    
    NumberPeriods   = ceil(NumberPeriods)+1;
    period          = Fs/freq;     
    
    % check whether kernel frequency is possible for the given sampling rate
    if period ~= int32(period)    
        error('KERN:FREQ','Stimulation Frequency not an integer divisor of Sampling Frequency!')
    end    
           
    % generate weighting function
    if nargin < 4
        warning('KERN:WFUN','No weighting function defined. Using average');
        wfun = 'ave';
    end
    
    if strcmpi(wfun,'linear')
        tau                     = NaN;
        k                       = @(N)(N*(N+1))/2;        
        w                       = @(n,N)(N-n+1)./k(N);            
    elseif strcmpi(wfun,'exp')        
        if nargin < 5, tau = 4;  end
        f                       = @(n,N)exp(tau-(tau*n/N));        
        w                       = @(n,N)f(n,N)./sum(f(1:N,N));
    elseif strcmpi(wfun,'gauss')
        if nargin < 5, tau = 3;  end
        f                       = @(n,N)(sqrt(tau/(2*pi))*exp((-(tau^2)*((n./N).^2))./2));
        w                       = @(n,N)f(n,N)./sum(f(1:N,N));
    elseif strcmpi(wfun,'cauchy')        
        if nargin < 5, tau = 1;  end        
        f                       = @(n,N)(1/pi)*(tau./((tau^2)-((N-n)./N)));
        w                       = @(n,N)f(n,N)./sum(f(1:N,N));
    elseif strcmpi(wfun,'ave')        
        tau                     = NaN;
        w                       = @(n,N)repmat(1/N,1,max(n));
    else
       warning('KERN:WFUN','Weighting function unknown. Using average');
       tau                      = NaN;
       w                        = @(n,N)repmat(1/N,1,max(n));
    end    
    
    % construct kernel        
    h                      = (-w(1:NumberPeriods-1,NumberPeriods-1));                         
    z                      = zeros(1,(length(h))*period);
    
    kernel                 = [];
    for h_idx = 1 : length(h)
        kernel = [kernel,h(h_idx),zeros(1,period-1)];
    end         
        
    kernel  = [z,1,fliplr(kernel)];

    Kernel.h                = kernel;
    Kernel.Fs               = Fs;
    Kernel.NumberPeriods    = NumberPeriods;
    Kernel.Frequency        = freq;
    Kernel.Weighting        = wfun;
    Kernel.tau              = tau;
end