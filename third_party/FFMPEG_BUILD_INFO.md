# FFmpeg 构建来源与对应源码

Release 中的 `ffmpeg.exe` 与 BtbN FFmpeg-Builds 在 2026-07-03 发布的 Windows x64 GPL 静态构建一致：

- 版本：`N-125444-g6d72600a30-20260703`
- EXE SHA-256：`95AEE5E6CB047C87A60F01A0968207D6E2BD5819F20BC41C8261C3ACEFF941EC`
- 官方构建发布：<https://github.com/BtbN/FFmpeg-Builds/releases/tag/autobuild-2026-07-03-13-21>
- 原始构建包：`ffmpeg-N-125444-g6d72600a30-win64-gpl.zip`
- 原始构建包 SHA-256：`89bc9dfd70283c4781710ba2f5430e5afd0dc3fb4c52fba59bfb557078ed2f6a`
- FFmpeg 源码提交：<https://github.com/FFmpeg/FFmpeg/commit/6d72600a30>
- BtbN 构建脚本提交：<https://github.com/BtbN/FFmpeg-Builds/commit/92132ee5d15776864c1e701c4f65675eeb74b729>

## 获取对应源码

```bash
git clone https://github.com/FFmpeg/FFmpeg.git
git -C FFmpeg checkout 6d72600a30

git clone https://github.com/BtbN/FFmpeg-Builds.git
git -C FFmpeg-Builds checkout 92132ee5d15776864c1e701c4f65675eeb74b729
```

BtbN 构建脚本记录静态依赖的来源、版本、补丁和构建方式。再次分发二进制时，应保留本文件、GPLv3 正文，并按许可证要求确保所有适用组件的对应源码持续可获得。

## 识别到的配置

```text
--prefix=/ffbuild/prefix --pkg-config-flags=--static --pkg-config=pkg-config
--cross-prefix=x86_64-w64-mingw32- --arch=x86_64 --target-os=mingw32
--enable-gpl --enable-version3 --disable-debug --disable-w32threads
--enable-pthreads --enable-iconv --enable-zlib --enable-libxml2
--enable-libvmaf --enable-fontconfig --enable-libharfbuzz --enable-libfreetype
--enable-libfribidi --enable-vulkan --enable-libshaderc --enable-libvorbis
--enable-gmp --enable-lzma --enable-liblcevc-dec --enable-opencl --enable-amf
--enable-libaom --enable-libaribb24 --enable-avisynth --enable-chromaprint
--enable-libdav1d --enable-libdavs2 --enable-libdvdread --enable-libdvdnav
--enable-ffnvcodec --enable-cuda-llvm --enable-frei0r --enable-libgme
--enable-libkvazaar --enable-libaribcaption --enable-libass --enable-libbluray
--enable-libjxl --enable-libmp3lame --enable-libopus --enable-libplacebo
--enable-librist --enable-libssh --enable-libtheora --enable-libvpx
--enable-libwebp --enable-libzmq --enable-lv2 --enable-libvpl --enable-openal
--enable-liboapv --enable-libopencore-amrnb --enable-libopencore-amrwb
--enable-libopenh264 --enable-libopenjpeg --enable-libopenmpt --enable-librav1e
--enable-librubberband --enable-schannel --enable-sdl2 --enable-libsnappy
--enable-libsoxr --enable-libsrt --enable-libsvtav1 --enable-libtwolame
--enable-libuavs3d --enable-vaapi --enable-libvidstab --enable-libvvenc
--enable-libx264 --enable-libx265 --enable-libxavs2 --enable-libxvid
--enable-libzimg --enable-libzvbi --extra-version=20260703
```

为便于阅读，上面省略了少量禁用项、编译器路径和链接器参数；`ffmpeg.exe -version` 会输出完整配置字符串。
