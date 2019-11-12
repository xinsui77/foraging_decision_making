% Author: Ample Hout, ah2594@columbia.edu
% Mobbs Lab, Spring 2013
% To test the mex64 code, run this script after running mex64test_runfirst.

% Verify that the mex64 code is working by observing the pulse light cycle ON and OFF.

% loop that will turn the pulse trigger ON and OFF
while true
    byte = 255;
    mex64test_outp(mex64test_address, byte);
    pause(2);
    
    byte = 255-128;
    mex64test_outp(mex64test_address, byte);
    pause(2);
end

