/**********************************************************************
  Gary Bishop 14 July 2000

  A simple interface to MIL from Matlab. I think you could do just about
  anything using this model.

***********************************************************************/

/* headers */
#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include <memory.h>
#include <mil.h> 
#include <mex.h>

// MIL control variables
static MIL_ID  MilApplication;
static MIL_ID  MilSystem;
static MIL_ID  MilDigitizer;

// the number of buffers to use
const int nmilbuff = 2; 

// ID's for the buffers
static MIL_ID  MilImage[nmilbuff];
static int MilImageNdx = 0; // current image index

// last remembered size of the buffers.
static int MilImageX = 0;
static int MilImageY = 0;

// number of bands in the buffers
static int MBands = 0;
static bool band_is_selected[3];
static int bands_selected = 0;

// scale in X and Y
static double  grab_scale_x = 1;
static double  grab_scale_y = 1;

void cleanup()
{
	if(MilApplication != 0) {
		if(MilImageX != 0) {
			MdigGrabWait(MilDigitizer, M_GRAB_END);
			for(int n = 0; n < nmilbuff; n++) {
				MbufFree(MilImage[n]);
			}
			MilImageX = MilImageY = 0;
		}
		/* Release defaults. */
		MappFreeDefault(MilApplication, MilSystem, M_NULL,
			MilDigitizer, M_NULL);
		MilApplication = 0;
	}
}

void mexFunction(int nlhs, mxArray *plhs[],
				 int nrhs, const mxArray *prhs[] )
{
	// validate the command string
	if(nrhs < 1 || mxIsChar(prhs[0]) != 1 || mxGetM(prhs[0]) != 1) {
		mexErrMsgTxt("Missing command string.");
	}

	// get the command
	int cmdlen = mxGetN(prhs[0]) + 1;
	char* command = (char*)mxCalloc(cmdlen, sizeof(char));
	if(mxGetString(prhs[0], command, cmdlen) != 0) {
		mexErrMsgTxt("Get command string failed.");
	}

	// startup 
	if(strcmp(command, "init") == 0) {

		// set things up so a clear will also clean up
		mexAtExit(cleanup);

		if(nrhs > 1) {
			if(!mxIsChar(prhs[1]) || mxGetM(prhs[1]) != 1) {
				mexErrMsgTxt("init argument should be the name of a dcf file.");
			}
			int nmlen = mxGetN(prhs[1]) + 1;
			char* dcfname = (char*)mxCalloc(nmlen, sizeof(char));
			mxGetString(prhs[1], dcfname, nmlen);

			MappAllocDefault(M_SETUP, &MilApplication, &MilSystem,
				M_NULL, M_NULL, M_NULL);
			if(MdigAlloc(MilSystem, M_DEV0, dcfname, M_DEFAULT, &MilDigitizer) == M_NULL) {
				mexErrMsgTxt("init failed.");
			}
		} else {
			/* Allocate defaults. */
			MappAllocDefault(M_SETUP, &MilApplication, &MilSystem,
				M_NULL, &MilDigitizer, M_NULL);
		}
		MBands = (int)MdigInquire(MilDigitizer, M_SIZE_BAND, M_NULL);
		for(int i=0; i<MBands; i++)
			band_is_selected[i] = true;
		bands_selected = MBands;

		MappTimer(M_TIMER_RESET, M_NULL);

		grab_scale_x = grab_scale_y = 1;

		MdigControl(MilDigitizer, M_GRAB_MODE, M_ASYNCHRONOUS);
		MdigControl(MilDigitizer, M_GRAB_SCALE_X, grab_scale_x);
		MdigControl(MilDigitizer, M_GRAB_SCALE_Y, grab_scale_y);
		
	// wrapup
	} else if(strcmp(command, "quit") == 0) {
		cleanup();

	// set the x and y scaling factor
	} else if(strcmp(command, "setscale") == 0) {
		// check the parameters
		if(nrhs != 3 || !mxIsDouble(prhs[1]) || !mxIsDouble(prhs[2])) {
			mexErrMsgTxt("setscale expects 2 arguments.");
		}
		grab_scale_x = mxGetScalar(prhs[1]);
		grab_scale_y = mxGetScalar(prhs[2]);

		MdigControl(MilDigitizer, M_GRAB_SCALE_X, grab_scale_x);
		MdigControl(MilDigitizer, M_GRAB_SCALE_Y, grab_scale_y);

	// select which bands to return for multiband sources
	} else if(strcmp(command, "selectbands") == 0) {
		// check to see if it's legal
		if(MBands == 1) {
			mexErrMsgTxt("selectbands only works for multiband sources.");
		}
		// check the argument
		if(nrhs != 2 || !mxIsDouble(prhs[1]) || mxGetM(prhs[1]) != 1) {
			mexErrMsgTxt("selectbands expects a row vector of band numbers.");
		}
		int nbands = mxGetN(prhs[1]);
		if(nbands == 0 || nbands > MBands) {
			mexErrMsgTxt("selectbands allows only 1 to 3 bands.");
		}
		double* bp = mxGetPr(prhs[1]);
		for(int i=0; i<3; i++) {
			band_is_selected[i] = false;
		}
		bands_selected = 0;
		for(i=0; i<nbands; i++) {
			int bnd = int(bp[i]);
			if(bnd < 0 || bnd > 2) {
				mexErrMsgTxt("selectbands allows bands numbered 0 to 2.");
			}
			if(!band_is_selected[bnd]) {
				band_is_selected[bnd] = true;
				bands_selected++;
			}
		}
		
	// grab a sequence in one call
	} else if(strcmp(command, "grabframes") == 0) {
		// check the parameters
		if(nrhs < 4 || !mxIsDouble(prhs[1]) || !mxIsDouble(prhs[2]) || !mxIsDouble(prhs[3])) {
			mexErrMsgTxt("grabframes expects 3 or 4 arguments.");
		}
		int width = int(mxGetScalar(prhs[1]));
		int height = int(mxGetScalar(prhs[2]));
		int frames = int(mxGetScalar(prhs[3]));

		// indicates whether this is a continuation of a previous grab
		bool grab_continue = false;
		if(nrhs == 5 && mxIsDouble(prhs[4]) && mxGetScalar(prhs[4]) > 0) {
			grab_continue = true;
		}

		// space to record per frame times if requested
		mxArray *time_array = 0;
		double* time_data = 0;
		if(nlhs > 1) {
			time_array = mxCreateDoubleMatrix(frames, 1, mxREAL);
			time_data = mxGetPr(time_array);
		}

		// allocate a matlab multidimensional array to return the image
		int dims[4];
		int ndims = 3;
		dims[0] = height;
		dims[1] = width;
		if(bands_selected > 1) {
			dims[2] = bands_selected;
			dims[3] = frames;
			ndims = 4;
		} else {
			dims[2] = frames;
		}
		mxArray *res = mxCreateNumericArray(ndims, dims, mxUINT8_CLASS, mxREAL);
		int frameelements = width*height*MBands;
		unsigned char* pmat = (unsigned char*)mxGetPr(res);

		// free buffers if they are the wrong size
		if(MilImageX != 0 && (width != MilImageX || height != MilImageY)) {
			MdigGrabWait(MilDigitizer, M_GRAB_END);
			for(int n=0; n<nmilbuff; n++) {
				MbufFree(MilImage[n]);
			}
			MilImageX = MilImageY = 0;
		}
		// allocate a few MIL buffers if we don't already have them
		if(MilImageX == 0) {
			for (int n=0; n<nmilbuff; n++)
			{
				MbufAllocColor(MilSystem,  
					MBands,
					width,
					height,
					8L+M_UNSIGNED, 
					M_IMAGE+M_GRAB, &MilImage[n]);
				if (MilImage[n] == 0)                     
				{
					mexErrMsgTxt("MbufAllocColor failed.");
				}
			}
			MilImageX = width;
			MilImageY = height;
		}

		// grab the frames
		if(!grab_continue) {
			// if you're not continuing a previous grab, then you want a fresh first frame
			MdigGrab(MilDigitizer, MilImage[MilImageNdx]);
		}
		for(int i = 0; i < frames; i++)
		{
			int ndx0 = MilImageNdx;
			MilImageNdx = (MilImageNdx + 1) % nmilbuff;
			MdigGrab(MilDigitizer, MilImage[MilImageNdx]);
			if(time_array)
				MappTimer(M_TIMER_READ, &time_data[i]);
			
			// copy the completed buff to the matlab array
			if(MBands == 1) { // easy
				// get a pointer to the buffer
				unsigned char* pmil;
				MbufInquire(MilImage[ndx0], M_HOST_ADDRESS, &pmil);
				if(pmil == M_NULL) {
					mexErrMsgTxt("no access to mil buffer.");
				}

				// copy the pixels exchanging x and y coordinates to suit matlab
				for(int y=0; y<height; y++) {
					for(int x=0; x<width; x++) {
						pmat[y+x*height] = pmil[x+y*width];
					}
				}
				pmat += width*height;

			} else { // harder
				// I bet there is some smarter way to do this...
				// for each band
				for(int b=0; b<MBands; b++) {
					if(band_is_selected[b]) {
						// allocate a child buffer on the band.
						MIL_ID child = MbufChildColor(MilImage[ndx0], b, M_NULL);
						if(child == M_NULL) {
							mexErrMsgTxt("no child");
						}
						// get a pointer to the child
						unsigned char* pmil;
						MbufInquire(child, M_HOST_ADDRESS, &pmil);
						if(pmil == M_NULL) {
							MbufFree(child);
							mexErrMsgTxt("no access to mil buffer.");
						}
						// do the copy, twizzling the indicies around...
						for(int y=0; y<height; y++) {
							for(int x=0; x<width; x++) {
								pmat[(y + x*height)] = pmil[x+y*width];
							}
						}
						pmat += width*height;

						// release the child
						MbufFree(child);
					}
				}
			}
		}

		plhs[0] = res;
		if(time_array)
			plhs[1] = time_array;

	} else {
		mexErrMsgTxt("Unknown command string.");
	}

}  
