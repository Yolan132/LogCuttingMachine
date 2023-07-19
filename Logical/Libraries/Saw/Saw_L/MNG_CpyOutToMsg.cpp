
#include "MNG_InternalTyp.hpp"

unsigned long int MNG_CpyOutToMsg(MNG_RawDatagram * pToServer, unsigned long int counter, Saw_OUTPUTS_32BIT_FWRD *pSimOutputs ) {

    
        unsigned long int DWordBuffer;
	
        pSimOutputs->NumSignals = 4;
        (pToServer->Header).ByteCount    = H_TO_NUDINT(20);
        (pToServer->Header).DatagramType = H_TO_NUDINT(MNG_Raw32BitImage);
        (pToServer->Header).SentTime = H_TO_NUDINT(0);  // Todo
        (pToServer->Header).Counter = H_TO_NUDINT(counter);
        pToServer->Payload[0] = H_TO_NUDINT(pSimOutputs->NumSignals);

    
    /* doSawOn : BOOL */
    if(pSimOutputs->doSawOn == 1) {
        pToServer->Payload[1] = 0xFFFFFFFF;   /*BOOL */
    } else { 
        pToServer->Payload[1] = 0;
    }


    /* aoTreeVelocity : FLOAT64 */
    brsmemcpy((unsigned long int)&(DWordBuffer), (unsigned long int)&(pSimOutputs->aoTreeVelocity), 4);
    pToServer->Payload[2] = H_TO_NUDINT(DWordBuffer);


    /* aoDriveParallelPosition : FLOAT64 */
    brsmemcpy((unsigned long int)&(DWordBuffer), (unsigned long int)&(pSimOutputs->aoDriveParallelPosition), 4);
    pToServer->Payload[3] = H_TO_NUDINT(DWordBuffer);


    /* aoDriveCutPosition : FLOAT64 */
    brsmemcpy((unsigned long int)&(DWordBuffer), (unsigned long int)&(pSimOutputs->aoDriveCutPosition), 4);
    pToServer->Payload[4] = H_TO_NUDINT(DWordBuffer);


	return 0;
}
