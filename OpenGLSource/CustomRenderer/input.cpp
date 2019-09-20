#include"input.h"

inputState::inputState() {}
inputState::inputState(float defaultAxisValue)
{
	primaryAxis = defaultAxisValue;
	secondaryAxis = defaultAxisValue;
}