
#include <bur/plctypes.h>

#include "../Saw_L/MNG_Global.hpp"
#include "../Saw_L/MNG_InternalTyp.hpp"
#include "../Saw_L/MNG_ComHdlr.hpp"

#include <MNG_PackageTyp.h>
#include <MNG_PackageVAR.h>
#include <TypesTYP.h>
#include <VariablesVAR.h>

unsigned long bur_heap_size = 0x4FFFF;


MNG_ComHdlr *pMNG_ComHdlr;


void _INIT ProgramInit(void)
{
    pMNG_ComHdlr = new MNG_ComHdlr(Saw_SimServerAddress, Saw_SimServerPort, Saw_SimSendCycleTime);
}

void _CYCLIC ProgramCyclic(void)
{

	connectionState = pMNG_ComHdlr->RunCommunication((void*)&Saw_SimInputs,(void*)&Saw_SimOutputs, &Saw_SimActive);

}
void _EXIT ProgramExit(void)
{
    delete pMNG_ComHdlr;
}
