% Author: Ample Hout, ah2594@columbia.edu
% Mobbs Lab, Spring 2013
% To test the mex64 code, run this script first.

clear all;
clc;

global mex64testObject;

% address of the parallel port
mex64test_address = hex2dec('E010');

%create IO64 interface object
mex64testObject.io.ioObj = io64();

%install the inpoutx64.dll driver
%status = 0 if installation successful
mex64testObject.io.status = io64(mex64testObject.io.ioObj);
if(mex64testObject.io.status ~= 0)
    disp('inp/outp installation failed!')
end

