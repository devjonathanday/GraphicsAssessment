#pragma once
#include"input.h"

class context
{
	struct GLFWwindow * window;

public:
	bool init(int width, int height, const char * title);
	void tick(inputState * state);
	void term();
	void clear();

	bool shouldClose() const;
};