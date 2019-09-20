#include"fileLoad.h"
#include<fstream>
#include<iostream>
#include<vector>
#include<regex>
#define TINYOBJLOADER_IMPLEMENTATION
#include"tiny_obj_loader.h"

std::string loadShaderFromFile(const char * filename)
{
	std::string shaderText;
	std::string line;
	std::fstream shaderFile(filename);
	if (shaderFile.is_open())
	{
		while (std::getline(shaderFile, line))
		{
			shaderText += line + '\n';
		}
		shaderFile.close();
	}

	else std::cout << "\nError: \"" << filename << "\" shader file not found.";

	return shaderText;
}

geometry loadFromOBJ(const char * filename)
{
	tinyobj::attrib_t attrib;
	std::vector<tinyobj::shape_t> shapes;
	std::vector<tinyobj::material_t> materials;

	std::vector<vertex> cachedVertices;
	std::vector<unsigned int> cachedIndices;

	std::string warn, err;

	bool ret = tinyobj::LoadObj(&attrib, &shapes, &materials, &warn, &err, filename);

	if (!warn.empty())
		std::cout << warn << std::endl;

	if (!err.empty())
		std::cerr << err << std::endl;

	if (!ret)
		exit(1);

	// Loop over shapes
	for (size_t s = 0; s < shapes.size(); s++)
	{
		// Loop over faces(polygon)
		size_t index_offset = 0;

		for (size_t f = 0; f < shapes[s].mesh.num_face_vertices.size(); f++)
		{
			int fv = shapes[s].mesh.num_face_vertices[f];
			// Loop over vertices in the face.
			for (size_t v = 0; v < fv; v++)
			{
				// access to vertex
				tinyobj::index_t idx = shapes[s].mesh.indices[index_offset + v];
				tinyobj::real_t vx = attrib.vertices[3 * idx.vertex_index + 0];
				tinyobj::real_t vy = attrib.vertices[3 * idx.vertex_index + 1];
				tinyobj::real_t vz = attrib.vertices[3 * idx.vertex_index + 2];

				tinyobj::real_t nx = attrib.normals[3 * idx.normal_index + 0];
				tinyobj::real_t ny = attrib.normals[3 * idx.normal_index + 1];
				tinyobj::real_t nz = attrib.normals[3 * idx.normal_index + 2];

				tinyobj::real_t tx = attrib.texcoords[2 * idx.texcoord_index + 0];
				tinyobj::real_t ty = attrib.texcoords[2 * idx.texcoord_index + 1];

				cachedVertices.push_back({ {vx, vy, vz, 1}, {nx, ny, nz, 0}, {tx, ty} });
				cachedIndices.push_back(3 * f + v);
			}
			index_offset += fv;
		}
	}

	return makeGeometry(&cachedVertices[0], cachedVertices.size(), &cachedIndices[0], cachedIndices.size());
}