#pragma once

class inputState
{
public:
	float primaryAxis;
	float secondaryAxis;

	inputState();
	inputState(float defaultAxisValue);
};