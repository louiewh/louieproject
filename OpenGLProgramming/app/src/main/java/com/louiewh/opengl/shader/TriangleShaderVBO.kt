package com.louiewh.opengl.shader

import android.opengl.GLES20
import android.opengl.GLES20.GL_NONE
import javax.microedition.khronos.opengles.GL10

class TriangleShaderVBO: TriangleShader() {

    private var VBO = 0

    override fun onInitGLES(program: Int) {
        super.onInitGLES(program)
        initVBO()
    }

    override fun onDrawFrame(gl: GL10?) {
        GLES20.glClear(GLES20.GL_DEPTH_BUFFER_BIT or GLES20.GL_COLOR_BUFFER_BIT)
        GLES20.glUseProgram(getShaderProgram())

        GLES20.glBindBuffer(GLES20.GL_ARRAY_BUFFER, VBO)
        GLES20.glVertexAttribPointer(vPosition, 2, GLES20.GL_FLOAT, false, 2*4, 0);
        GLES20.glEnableVertexAttribArray(vPosition)

        GLES20.glUniform4f(uColor, 0.0f, 1.0f, 0.0f, 1.0f)
        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_STRIP, 0, 3)

        GLES20.glBindBuffer(GLES20.GL_ARRAY_BUFFER, GLES20.GL_NONE)
    }

    override fun onDestroyGLES() {
        GLES20.glDeleteBuffers(1, IntArray(VBO), 0)
    }

    private fun initVBO() {

        val intArray = IntArray(1)
        GLES20.glGenBuffers(1, intArray, 0)
        VBO = intArray[0]

        val vertices = getVertices()
        GLES20.glBindBuffer(GLES20.GL_ARRAY_BUFFER, VBO)
        GLES20.glBufferData(GLES20.GL_ARRAY_BUFFER, vertices.capacity()*VERTICES_FLOAT_SIZE, vertices, GLES20.GL_STREAM_DRAW)
        GLES20.glBindBuffer(GLES20.GL_ARRAY_BUFFER, GL_NONE)
    }
}