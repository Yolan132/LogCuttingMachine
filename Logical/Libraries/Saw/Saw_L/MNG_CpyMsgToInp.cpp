
#include "MNG_InternalTyp.hpp"

unsigned long int MNG_CpyMsgToInp(MNG_RawDatagram * pFromServer, Saw_INPUTS_32BIT_FWRD *pSimInputs) {

    MNG_DatagramType datagramType;
	unsigned long int DWordBuffer;
        unsigned long int byteCount;
	unsigned long int numSignalsInMessage;


	byteCount = N_TO_HUDINT((pFromServer->Header).ByteCount);
	datagramType = static_cast<MNG_DatagramType>(N_TO_HUDINT((pFromServer->Header).DatagramType));
	if (datagramType != MNG_Raw32BitImage) {
		return 0;
	}

    pSimInputs->NumSignals = 4;

    numSignalsInMessage = N_TO_HUDINT(pFromServer->Payload[0]);
        if ((static_cast<long int>(numSignalsInMessage) != pSimInputs->NumSignals) ||
	(byteCount != 4 + numSignalsInMessage * 4)) {
		return 0;
	}

    /* BOOL diDriveParallelAtFront */
    pSimInputs->diDriveParallelAtFront = (pFromServer->Payload[1] != 0);

    /* BOOL diDriveParallelAtBack */
    pSimInputs->diDriveParallelAtBack = (pFromServer->Payload[2] != 0);

    /* BOOL diDriveCutAtFront */
    pSimInputs->diDriveCutAtFront = (pFromServer->Payload[3] != 0);

    /* BOOL diDriveCutAtBack */
    pSimInputs->diDriveCutAtBack = (pFromServer->Payload[4] != 0);


return N_TO_HUDINT((pFromServer->Header).Counter); // return counter
}
