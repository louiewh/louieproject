package com.louiewh.opengl.shader

import android.opengl.GLES20
import android.opengl.GLES30
import android.opengl.GLSurfaceView
import android.util.Log
import com.louiewh.opengl.ContextUtil
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer
import java.nio.IntBuffer
import javax.microedition.khronos.opengles.GL10
import kotlin.concurrent.thread

/**
 * ffmpeg 生成 YUV 数据  ffmpeg -i 1638871887691778.mp4  -s 568x320 -r 30 -pix_fmt yuv420p out.yuv
 * ffmpeg 播放 YUV 数据 ffplay -video_size 568x320  -i out.yuv
 */
open class YUVRender :BaseShader() {
    private var VBO = 0
    private var VAO = 0
    private var EBO = 0

    private var  yTextureId = 0
    private var  uTextureId = 0
    private var  vTextureId = 0

    private var yByteBuffer:ByteBuffer? = null
    private var uByteBuffer:ByteBuffer? = null
    private var vByteBuffer:ByteBuffer? = null

    private val wVideo = 288
    private val hVideo = 512
    private val YUV_FILE = "video_288_512.yuv"

    private var mStop = false
    private lateinit var ioThread:Thread
    private lateinit var glSurfaceView:GLSurfaceView

    private  val verticesSource =
        "#version 300 es\n" +
                "layout (location = 0) in vec3 aPos;\n" +
                "layout (location = 1) in vec2 aTexCoord;\n" +
                "\n" +
                "out vec2 textureCoord;\n" +
                "\n" +
                "void main()\n" +
                "{\n" +
                "    gl_Position = vec4(aPos, 1.0);\n" +
                "    textureCoord = aTexCoord;\n" +
                "}"


    private  val fragmentSource =
        """
            #version 300 es
            out vec4 FragColor;
            in vec2  textureCoord;

            uniform sampler2D textureY;
            uniform sampler2D textureU;
            uniform sampler2D textureV;

            void main(){
                float y,u,v;
                vec3 rgb;
                y = texture(textureY, textureCoord).r;
                u = texture(textureU, textureCoord).r - 0.5;
                v = texture(textureV, textureCoord).r - 0.5;
                
                vec3 rgbMat = mat3(
                1.0,    1.0,     1.0,					
                0.0,    -0.344,  1.770,					
                1.403,  -0.714,  0.0) * yuv; 

                rgb.r = y + 1.540*v;
                rgb.g = y - 0.183*u - 0.459*v;
                rgb.b = y + 1.818*u;
                FragColor = vec4(rgb, 1.0);
            }
            """

    private  val fragmentSourceMat =
        """
            #version 300 es
            out vec4 FragColor;
            in vec2  textureCoord;

            uniform sampler2D textureY;
            uniform sampler2D textureU;
            uniform sampler2D textureV;

            void main(){
                vec3 yuv;
                yuv.x = texture(textureY, textureCoord).r;
                yuv.y = texture(textureU, textureCoord).r - 0.5;
                yuv.z = texture(textureV, textureCoord).r - 0.5;
                
                vec3 rgb = mat3(
                1.0,    1.0,     1.0,					
                0.0,    -0.344,  1.770,					
                1.403,  -0.714,  0.0) * yuv; 

                FragColor = vec4(rgb, 1.0);
            }
            """

    private var vPosition = 0
    private var vTexCoord = 0

    private var ySampler2D = 0
    private var uSampler2D = 0
    private var vSampler2D = 0


    override fun onSetGLSurfaceView(glSurfaceView: GLSurfaceView) {
        super.onSetGLSurfaceView(glSurfaceView)
        glSurfaceView.renderMode = GLSurfaceView.RENDERMODE_WHEN_DIRTY
        this.glSurfaceView = glSurfaceView
    }

    override fun onInitGLES(program: Int) {
        vPosition  = GLES30.glGetAttribLocation(program, "aPos")
        vTexCoord  = GLES30.glGetAttribLocation(program, "aTexCoord")

        ySampler2D = GLES30.glGetUniformLocation(program, "textureY")
        uSampler2D = GLES30.glGetUniformLocation(program, "textureU")
        vSampler2D = GLES30.glGetUniformLocation(program, "textureV")

        initVBO()
        initEBO()
        initVAO()

        yTextureId = initTexture(ySampler2D)
        uTextureId = initTexture(uSampler2D)
        vTextureId = initTexture(vSampler2D)

        ioThread = thread(name = "IOYUV") {  readYuvData(YUV_FILE, wVideo, hVideo)}
    }

    override fun onDestroyGLES() {
        mStop = true

        GLES20.glDeleteBuffers(1, IntArray(VAO), 0)
        GLES20.glDeleteBuffers(1, IntArray(VBO), 0)
        GLES20.glDeleteBuffers(1, IntArray(EBO), 0)

        GLES20.glDeleteTextures(1, IntArray(yTextureId), 0)
        GLES20.glDeleteTextures(1, IntArray(uTextureId), 0)
        GLES20.glDeleteTextures(1, IntArray(vTextureId), 0)
    }

    override fun getVertexSource(): String {
        return verticesSource
    }

    override fun getFragmentSource(): String {
        return fragmentSourceMat
    }

    override fun onDrawFrame(gl: GL10?) {
        GLES30.glClear(GLES30.GL_DEPTH_BUFFER_BIT or GLES30.GL_COLOR_BUFFER_BIT)
        GLES30.glUseProgram(getShaderProgram())

        // Y
        GLES30.glActiveTexture(GLES30.GL_TEXTURE0)
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, yTextureId)
        GLES30.glUniform1i(ySampler2D, 0)
        GLES30.glTexImage2D(
            GLES30.GL_TEXTURE_2D,
            0,
            GLES30.GL_LUMINANCE,
            wVideo,
            hVideo,
            0,
            GLES30.GL_LUMINANCE,
            GLES30.GL_UNSIGNED_BYTE,
            yByteBuffer
        )

        // U
        GLES30.glActiveTexture(GLES30.GL_TEXTURE1)
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, uTextureId)
        GLES30.glUniform1i(uSampler2D, 1)
        GLES30.glTexImage2D(
            GLES30.GL_TEXTURE_2D,
            0,
            GLES30.GL_LUMINANCE,
            wVideo / 2,
            hVideo / 2,
            0,
            GLES30.GL_LUMINANCE,
            GLES30.GL_UNSIGNED_BYTE,
            uByteBuffer
        )

        // V
        GLES30.glActiveTexture(GLES30.GL_TEXTURE2)
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, vTextureId)
        GLES30.glUniform1i(vSampler2D, 2)
        GLES30.glTexImage2D(
            GLES30.GL_TEXTURE_2D,
            0,
            GLES30.GL_LUMINANCE,
            wVideo / 2,
            hVideo / 2,
            0,
            GLES30.GL_LUMINANCE,
            GLES30.GL_UNSIGNED_BYTE,
            vByteBuffer
        )

        yByteBuffer?.clear()
        uByteBuffer?.clear()
        vByteBuffer?.clear()

        GLES30.glBindVertexArray(VAO)
        GLES30.glDrawElements(GLES30.GL_TRIANGLE_STRIP, 6, GLES30.GL_UNSIGNED_INT, 0)

        GLES30.glBindVertexArray(GLES30.GL_NONE)
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, GLES30.GL_NONE)
    }

    private fun initVBO() {
        val vertices = getVertices()

        val intArray = IntArray(1)
        GLES30.glGenBuffers(intArray.size, intArray, 0)
        VBO = intArray[0]

        GLES30.glBindBuffer(GLES30.GL_ARRAY_BUFFER, VBO)
        GLES30.glBufferData(GLES30.GL_ARRAY_BUFFER, vertices.capacity() * VERTICES_FLOAT_SIZE, vertices, GLES30.GL_STREAM_DRAW)
        GLES30.glBindBuffer(GLES30.GL_ARRAY_BUFFER, GLES30.GL_NONE)
    }

    private fun initEBO(){
        val indices = getIndex()

        val intArray = IntArray(1)
        GLES30.glGenBuffers(intArray.size, intArray, 0)
        EBO = intArray[0]

        GLES30.glBindBuffer(GLES20.GL_ELEMENT_ARRAY_BUFFER, EBO)
        GLES30.glBufferData(
            GLES20.GL_ELEMENT_ARRAY_BUFFER, indices.capacity()* Int.SIZE_BYTES, indices,
            GLES20.GL_STATIC_DRAW
        )
        GLES30.glBindBuffer(GLES20.GL_ELEMENT_ARRAY_BUFFER, GLES30.GL_NONE)
    }

    private fun initVAO() {
        val intArray = IntArray(1)
        GLES30.glGenVertexArrays(1, intArray, 0)
        VAO = intArray[0]

        //绑定VAO对象, VBO 的操作记录在VAO中
        GLES30.glBindVertexArray(VAO)

        // VBO bind
        GLES30.glBindBuffer(GLES30.GL_ARRAY_BUFFER, VBO)
        // EBO bind
        GLES30.glBindBuffer(GLES30.GL_ELEMENT_ARRAY_BUFFER, EBO)

        GLES30.glVertexAttribPointer(vPosition, 3, GLES30.GL_FLOAT, false, 5 * VERTICES_FLOAT_SIZE, 0)
        GLES30.glVertexAttribPointer(vTexCoord, 2, GLES30.GL_FLOAT, false, 5 * VERTICES_FLOAT_SIZE, 3*VERTICES_FLOAT_SIZE)

        GLES30.glEnableVertexAttribArray(vPosition)
        GLES30.glEnableVertexAttribArray(vTexCoord)

        //解绑
        GLES30.glBindVertexArray(GLES30.GL_NONE)
        GLES30.glBindBuffer(GLES30.GL_ARRAY_BUFFER, GLES30.GL_NONE)
        GLES30.glBindBuffer(GLES30.GL_ELEMENT_ARRAY_BUFFER, GLES30.GL_NONE)
        // finish VBO bind
    }

    private fun getVertices(): FloatBuffer {
        val vertices = floatArrayOf(
            // ---- 位置 ----           - 纹理坐标 -
            1.0f,    1.0f,     0.0f,      1.0f, 0.0f,   // 右上
            1.0f,   -1.0f,     0.0f,      1.0f, 1.0f,   // 右下
            -1.0f,  -1.0f,     0.0f,      0.0f, 1.0f,   // 左下
            -1.0f,   1.0f,     0.0f,      0.0f, 0.0f    // 左上
        )

        // vertices.length*4是因为一个float占四个字节
        val vertexBuffer = ByteBuffer.allocateDirect(vertices.size * VERTICES_FLOAT_SIZE)//4个字节
            .order(ByteOrder.nativeOrder())
            .asFloatBuffer()
            .put(vertices)
            .apply {
                position(0)
            }

        return vertexBuffer
    }

    private fun getIndex(): IntBuffer {
        val indices = intArrayOf(
            // 注意索引从0开始!
            // 此例的索引(0,1,2,3)就是顶点数组vertices的下标，
            // 这样可以由下标代表顶点组合成矩形

            0, 1, 3, // 第一个三角形
            1, 2, 3  // 第二个三角形
        )

        val eboBuffer = ByteBuffer.allocateDirect(indices.size * Int.SIZE_BYTES)//4个字节
            .order(ByteOrder.nativeOrder())
            .asIntBuffer()
            .put(indices)
            .apply {
                position(0)
            }

        return eboBuffer
    }

    private fun initTexture(id:Int):Int{
        val intArray = IntArray(1)
        GLES30.glGenTextures(intArray.size, intArray, 0)
        val textureId = intArray[0]

        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, textureId)

        // 为当前绑定的纹理对象设置环绕、过滤方式
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_WRAP_S, GLES30.GL_REPEAT)
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_WRAP_T, GLES30.GL_REPEAT)

        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_MIN_FILTER, GLES30.GL_NEAREST)
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_MAG_FILTER, GLES30.GL_LINEAR)

        GLES30.glGenerateMipmap(GLES30.GL_TEXTURE_2D)
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, GLES30.GL_NONE)

        return textureId
    }



    private fun readYuvData(yuvFile:String, w: Int, h: Int) {
        val input = ContextUtil.getContext().assets.open(yuvFile)
        //视频时 yuv420p ,4 个 y 共用一个 uv，先存储y，再u，和v
        val y = ByteArray(w * h)
        val u = ByteArray(w * h / 4)
        val v = ByteArray(w * h / 4)

        while (true) {
            if (mStop) {
                Log.d("", "readYuvData,退出")
                return
            }

            val readY = input.read(y)
            val readU = input.read(u)
            val readV = input.read(v)

            if (readY > 0 && readU > 0 && readV > 0) {
                //从这里触发刷新
                yByteBuffer = ByteBuffer.wrap(y)
                uByteBuffer = ByteBuffer.wrap(u)
                vByteBuffer = ByteBuffer.wrap(v)

                //主动触发刷新
                glSurfaceView.requestRender()
                //延时30ms，控制速度
                Thread.sleep(30)
            } else {
                return
            }
        }
    }
}