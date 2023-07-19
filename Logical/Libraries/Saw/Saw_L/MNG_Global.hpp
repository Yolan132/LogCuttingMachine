
#ifndef  _MNGGLOBAL_HPP_
#define _MNGGLOBAL_HPP_

#include <mng_globalTYP.h>


    typedef struct {

		signed short NumSignals;

        /* BOOL diDriveParallelAtFront */
        BOOL diDriveParallelAtFront;
        /* BOOL diDriveParallelAtBack */
        BOOL diDriveParallelAtBack;
        /* BOOL diDriveCutAtFront */
        BOOL diDriveCutAtFront;
        /* BOOL diDriveCutAtBack */
        BOOL diDriveCutAtBack;

        } Saw_INPUTS_32BIT_FWRD;


    typedef struct {

		signed short NumSignals;

        /* BOOL doSawOn */
        BOOL doSawOn;
        /* LREAL aoTreeVelocity */
        REAL aoTreeVelocity;
        /* LREAL aoDriveParallelPosition */
        REAL aoDriveParallelPosition;
        /* LREAL aoDriveCutPosition */
        REAL aoDriveCutPosition;

        } Saw_OUTPUTS_32BIT_FWRD;



#endif
