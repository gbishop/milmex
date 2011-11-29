function varargsout = milmex(command)
% MILMEX(command, ...) provides a simple interface to Matrox MIL for grabbing frames
% from within Matlab via a MEX file.
%
% MILMEX('init') initializes MIL using the default DCF.
% MILMEX('init', dcfname) initializes MIL using the specified DCF
%
% MILMEX('quit') closes things down. The MEX tries to handle this on a clear as well.
%
% MILMEX('setscale', x, y) sets the digitizer scale. Legal values appear to be 1, 0.5,
% and 0.25.
%
% MILMEX('selectbands', bandnumbers) choose which bands (channels) to return
% for example MILMEX('selectbands', [0 1]) will return only the red and green channels
%
% frames = MILMEX('grabframes', width, height, N) grabs N consecutive frames of the
% specified size and returns them in a three-dimensional array of type UINT8.
%
% [frames, times] = MILMEX('grabframes', width, height, N) same as above but also
% returns a timestamp for each frame. These are useful to make sure no frames were
% missed.
%
% you can add a 5th argument to either of the 'grabframes' calls above. If it is
% non-zero then it will "continue" the previous grab. This just means it won't start
% with a call to MdigGrab but will use the one left from the previous call. This trick
% lets me grab individual frames at 30 fps.

% Gary Bishop
% 14 July 2000