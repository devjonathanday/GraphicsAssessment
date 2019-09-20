#define GLM_FORCE_SWIZZLE

#include "context.h"
#include "render.h"
#include "fileLoad.h"

#include"glm/glm.hpp"
#include"glm/ext.hpp"

#include<iostream>
#include<vector>

int main()
{
	#pragma region Context Initialization

	context game;
	game.init(640, 480, "Jonathan's World Of Rendering");

	//Error checking
	#ifdef _DEBUG
		glEnable(GL_DEBUG_OUTPUT);
		glEnable(GL_DEBUG_OUTPUT_SYNCHRONOUS);
	
		glDebugMessageCallback(errorCallback, 0);
		glDebugMessageControl(GL_DONT_CARE, GL_DONT_CARE, GL_DONT_CARE, 0, 0, true);
	#endif

	#pragma endregion

	//Initialize the user's input state (class)
	inputState state;
	//Load OBJ from file
	geometry teapot = loadFromOBJ("models/teapot.obj");
	//Shader loading from file
	std::string basicVert = loadShaderFromFile("shaders/basicVert.txt");
	std::string basicFrag = loadShaderFromFile("shaders/basicFrag.txt");
	//Shader compilation
	shader basicShad = makeShader(basicVert.c_str(), basicFrag.c_str());
	//Initialize camera matrices
	glm::mat4 model = glm::identity<glm::mat4>();
	glm::mat4 camProj = glm::perspective(glm::radians(45.0f), 640.0f / 480.0f, 0.1f, 1000.0f);
	glm::mat4 camView = glm::lookAt(glm::vec3(0, 20, -70), glm::vec3(0, 0, 0), glm::vec3(0, 1, 0));
	//Load texture from file
	texture teapotTexture = loadTexture("textures/rock.png");
	//Initialize lights
	light sun;
	sun.direction = glm::vec4{ 0, -1, 1, 1 };
	sun.color = glm::vec4{1, 1, 1, 1};
	//Initialize the light's rotation matrix with identity
	glm::mat4 sunRotation = glm::identity<glm::mat4>();
	//Set uniforms
	setUniform(basicShad, 0, camProj);
	setUniform(basicShad, 1, camView);
	setUniform(basicShad, 3, teapotTexture, 0);
	setUniform(basicShad, 5, sun.color);

	while (!game.shouldClose())
	{
		game.tick(&state);
		game.clear();
		//Rotate the model
		model = glm::rotate(model, glm::radians(state.primaryAxis), glm::vec3(0.0f, 1, 0.0f));
		//Create the light's rotation matrix based on input state
		glm::mat4 sunRotation = glm::rotate(glm::identity<glm::mat4>(), glm::radians(-state.secondaryAxis), glm::vec3(0, 1, 0));
		//Apply the rotation to the light's direction
		sun.direction = glm::vec4(sun.direction, 0) * sunRotation;
		//Update uniforms to new transformation
		setUniform(basicShad, 2, model);
		setUniform(basicShad, 4, sun.direction);
		//Break if an error is found
		assert(glGetError() == GL_NO_ERROR);
		//Draw call
		draw(basicShad, teapot);
	}

	game.term();

	return 0;
}