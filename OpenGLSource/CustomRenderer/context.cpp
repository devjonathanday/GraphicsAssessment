// the file we're implementing
#include "context.h"

// system headers
#include <iostream>

// library headers
// GLEW always comes before GLFW
#include "glew/GL/glew.h"
#include "glfw//glfw3.h"

#include"input.h"

bool context::init(int width, int height, const char * title)
{
	glfwInit();

	window = glfwCreateWindow(width, height, title, nullptr, nullptr);

	glfwMakeContextCurrent(window);

	glewInit();

	std::cout << "OpenGL Version: " << (const char *)glGetString(GL_VERSION) << "\n";
	std::cout << "Renderer: " << (const char *)glGetString(GL_RENDERER) << "\n";
	std::cout << "Vendor: " << (const char *)glGetString(GL_VENDOR) << "\n";
	std::cout << "GLSL: " << (const char *)glGetString(GL_SHADING_LANGUAGE_VERSION) << "\n";

	glClearColor(0.25f, 0.25f, 0.25f, 1.0f);

	glEnable(GL_BLEND);
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_CULL_FACE);

	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glDepthFunc(GL_LEQUAL);

	return true;
}

void context::tick(inputState * state)
{
	glfwPollEvents();

	bool primaryLeft = false;
	bool primaryRight = false;
	bool secondaryLeft = false;
	bool secondaryRight = false;

	if (glfwGetKey(window, GLFW_KEY_A))
		primaryLeft = true;
	if (glfwGetKey(window, GLFW_KEY_D))
		primaryRight = true;
	if (glfwGetKey(window, GLFW_KEY_Q))
		secondaryLeft = true;
	if (glfwGetKey(window, GLFW_KEY_E))
		secondaryRight = true;

	(*state).primaryAxis = (primaryLeft ? -1.0f : 0.0f) + (primaryRight ? 1.0f : 0.0f);
	(*state).secondaryAxis = (secondaryLeft ? -1.0f : 0.0f) + (secondaryRight ? 1.0f : 0.0f);

	glfwSwapBuffers(window);
}

void context::term()
{
	glfwDestroyWindow(window);
	glfwTerminate();

	window = nullptr;
}

bool context::shouldClose() const
{
	return glfwWindowShouldClose(window);
}

void context::clear()
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}