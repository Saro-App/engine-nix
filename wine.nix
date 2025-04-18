# Copyright (C) 2025 Ethan Uppal. All rights reserved.
{
  stdenv,
  fetchFromGitHub,
  pkgsArm,
  pkgsIntel,
}:
stdenv.mkDerivation rec {
  pname = "saro-wine";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "Saro-App";
    repo = "wine";
    rev = version;
    sha256 = "4JNJ1d0PasbPzBGysTzAaCUsCE04DYRW0ZgVYUxt7uY=";
  };

  enableParallelBuilding = true;

  configureFlags = [
    "--host=x86_64-darwin"
    "--build=x86_64-darwin"
    "--enable-archs=i386,x86_64"
    "--enable-win64"
    "--disable-tests"
    "--without-alsa"
    "--without-capi"
    "--with-coreaudio"
    "--with-cups"
    "--without-dbus"
    "--with-freetype"
    "--with-gettext"
    "--without-gettextpo"
    "--without-gphoto"
    "--with-gnutls"
    "--without-gssapi"
    "--without-krb5"
    "--with-mingw"
    "--without-netapi"
    "--with-opencl"
    "--with-opengl"
    "--without-oss"
    "--with-pcap"
    "--with-pcsclite"
    "--with-pthread"
    "--without-pulse"
    "--without-sane"
    "--with-sdl"
    "--with-gstreamer"
    "--without-udev"
    "--with-unwind"
    "--without-usb"
    "--without-v4l2"
    "--with-vulkan"
    "--without-wayland"
    "--without-x"
    "--with-inotify"
    "--with-ffmpeg"
  ];

  nativeBuildInputs = with pkgsArm; [bison pkgsCross.mingwW64.buildPackages.gcc pkg-config wget];
  buildInputs = with pkgsIntel; [freetype gnutls moltenvk SDL2 gst_all_1.gstreamer ffmpeg gettext];
}
