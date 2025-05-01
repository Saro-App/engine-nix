# Journal

I installed Nix through the normal installer.
I use `fish` and `tmux`, so although the Nix installer decided to remove the bash/zsh directories, I was able to preserve my entire setup.
That way I can just use `nix` for localized dev environments.

 - You need to get `libintl` for windows (this failed a long way into the first `make`).

 nevermind I'm just gonna try to disable gettext stuff

now we get 

```
checking for pthread_create... yes
checking how to run the C preprocessor... clang -target x86_64-apple-darwin -m64 -E
checking for X... disabled
checking for pcap_init in -lpcap... no
configure: error: pcap 64-bit development files not found, wpcap won't be supported.
This is an error since --with-pcap was requested.
```
even though `pkg-config` in the nix shell works for pcap

Looks like it was building for arm. Giving up on trying to do cross compilation, just gonna run Intel clang under Rosetta

```
winebuild : No such file or directory
make: *** [Makefile:45875: dlls/ddraw/x86_64-windows/libddraw.delay.a] Error 1
make: *** Waiting for unfinished jobs....
winebuild : No such file or directory
winebuild : No such file or directory
winebuild : No such file or directory
winebuild : No such file or directory
make: *** [Makefile:117296: dlls/secur32/i386-windows/libsecur32.delay.a] Error 1
make: *** [Makefile:95000: dlls/msvcr90/x86_64-windows/libmsvcr90.a] Error 1
make: *** [Makefile:94954: dlls/msvcr90/i386-windows/libmsvcr90.a] Error 1
make: *** [Makefile:93871: dlls/msvcr80/x86_64-windows/libmsvcr80.a] Error 1
winebuild : No such file or directory
winebuild : No such file or directory
make: *** [Makefile:147198: dlls/winhttp/x86_64-windows/libwinhttp.a] Error 1
make: *** [Makefile:93825: dlls/msvcr80/i386-windows/libmsvcr80.a] Error 1
```

Just reran `buildPhase` and it continued?

Now it can't find `-lintl` even though I configured it without gettext:

```
winebuild : Undefined error: 0
winegcc: ./tools/winebuild/winebuild failed
make: *** [Makefile:3166: dlls/adsldp/i386-windows/adsldp.dll] Error 2
make: *** Waiting for unfinished jobs....
/nix/store/j3zqnr428hiz7kkwzpcgiwc3446fihig-x86_64-w64-mingw32-binutils-2.43.1/bin/x86_64-w64-mingw32-ld: cannot find -lintl: No such file or directory
collect2: error: ld returned 1 exit status
winegcc: /nix/store/lbx5fq4xxnarsnx17h46rapwy9ma6i0w-x86_64-w64-mingw32-gcc-wrapper-13.3.0/bin/x86_64-w64-mingw32-gcc failed
make: *** [Makefile:3184: dlls/adsldp/x86_64-windows/adsldp.dll] Error 2
/nix/store/j3zqnr428hiz7kkwzpcgiwc3446fihig-x86_64-w64-mingw32-binutils-2.43.1/bin/x86_64-w64-mingw32-ld: cannot find -lintl: No such file or directory
/nix/store/j3zqnr428hiz7kkwzpcgiwc3446fihig-x86_64-w64-mingw32-binutils-2.43.1/bin/x86_64-w64-mingw32-ld: cannot find -lintl: No such file or directory
collect2: error: ld returned 1 exit status
/nix/store/j3zqnr428hiz7kkwzpcgiwc3446fihig-x86_64-w64-mingw32-binutils-2.43.1/bin/x86_64-w64-mingw32-ldwinegcc: /nix/store/lbx5fq4xxnarsnx17h46rapwy9ma6i0w-x86_64-w64-mingw32-gcc-wrapper-13.3.0/bin/x86_64-w64-mingw32-gcc failed
: cannot find -lintl: No such file or directory
collect2: error: ld returned 1 exit status
make: *** [Makefile:1551: dlls/acledit/x86_64-windows/acledit.dll] Error 2
winegcc: /nix/store/lbx5fq4xxnarsnx17h46rapwy9ma6i0w-x86_64-w64-mingw32-gcc-wrapper-13.3.0/bin/x86_64-w64-mingw32-gcc failed
/nix/store/j3zqnr428hiz7kkwzpcgiwc3446fihig-x86_64-w64-mingw32-binutils-2.43.1/bin/x86_64-w64-mingw32-ld: cannot find -lintl: No such file or directory
collect2: error: ld returned 1 exit status
make: *** [Makefile:1629: dlls/aclui/x86_64-windows/aclui.dll] Error 2
winegcc: /nix/store/lbx5fq4xxnarsnx17h46rapwy9ma6i0w-x86_64-w64-mingw32-gcc-wrapper-13.3.0/bin/x86_64-w64-mingw32-gcc failed
collect2: error: ld returned 1 exit status
make: *** [Makefile:1793: dlls/activeds/x86_64-windows/activeds.dll] Error 2
winegcc: /nix/store/lbx5fq4xxnarsnx17h46rapwy9ma6i0w-x86_64-w64-mingw32-gcc-wrapper-13.3.0/bin/x86_64-w64-mingw32-gcc failed
make: *** [Makefile:2955: dlls/actxprxy/x86_64-windows/actxprxy.dll] Error 2
```
 Gonna try using `gettext` normal.
In any case, it seems to just not have pkg-config files.

## 4/30

Yeah, the intl lib exists but is not being found and there's no pkg-config files

Ok what:
```
air:source ethan$ ls /nix/store/dmnqb6xi4a8axk0s3ncpkza54ldzyd17-gettext-0.21.1/lib
gettext              libgettextlib-0.21.1.dylib  libgettextpo.dylib          libgettextsrc.la  libtextstyle.0.dylib
libasprintf.0.dylib  libgettextlib.dylib         libgettextpo.la             libintl.8.dylib   libtextstyle.dylib
libasprintf.dylib    libgettextlib.la            libgettextsrc-0.21.1.dylib  libintl.dylib     libtextstyle.la
libasprintf.la       libgettextpo.0.dylib        libgettextsrc.dylib         libintl.la
air:source ethan$ x86_64-w64-mingw32-gcc -lintl -L/nix/store/dmnqb6xi4a8axk0s3ncpkza54ldzyd17-gettext-0.21.1/lib/
/nix/store/j3zqnr428hiz7kkwzpcgiwc3446fihig-x86_64-w64-mingw32-binutils-2.43.1/bin/x86_64-w64-mingw32-ld: cannot find -lintl: No such file or directory
/nix/store/j3zqnr428hiz7kkwzpcgiwc3446fihig-x86_64-w64-mingw32-binutils-2.43.1/bin/x86_64-w64-mingw32-ld: cannot find -lintl: No such file or directory
collect2: error: ld returned 1 exit status
```

Anyways learned --ignore-environment isolates the nix build further

https://www.reddit.com/r/NixOS/comments/lqda7w/mingw/

## 5/1

- https://lists.macports.org/pipermail/macports-tickets/2010-February/050312.html
- I don't even remember how I found what the derivation path is

Here's what's confusing:

```
/nix/store/5bq22dwj6bmrfp04k2avrsdwcxk6cyxk-x86_64-w64-mingw32-gcc-wrapper-14.2.1.20250322/bin/x86_64-w64-mingw32-gcc -L/nix/store/2x4b8w75sd4crsyl4x3rd6ciswflmzw0-gettext-0.22.5/lib -lintl
```

Produces

```
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: cannot find -lintl: No such file or directory
collect2: error: ld returned 1 exit status
```

but swapping that out with `/usr/local/lib` gives a success:

```
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: /nix/store/mzkmz3iiy57fcqim225cgdhf3slhm11k-mingw-w64-x86_64-w64-mingw32-12.0.0/lib/libmingw32.a(lib64_libmingw32_a-crtexewin.o):(.text.startup+0xc5): undefined reference to `WinMain'
```

But the `libintl.dylib`s in both, when inspected with `file -L`, both show:

```
Mach-O 64-bit x86_64 dynamically linked shared library, flags:<NOUNDEFS|DYLDLINK|TWOLEVEL|NO_REEXPORTED_DYLIBS>
```

Curiously, whatever you put for `-l` it complains about `libintl`:

```
$ /nix/store/5bq22dwj6bmrfp04k2avrsdwcxk6cyxk-x86_64-w64-mingw32-gcc-wrapper-14.2.1.20250322/bin/x86_64-w64-mingw32-gcc -lWHATEVER
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: cannot find -lWHATEVER: No such file or directory
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.dll.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.dll.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.dll.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.dll.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: skipping incompatible /nix/store/qbbvfndzjx58i4wjffnbkgc07dkpbymc-mcfgthread-i686-w64-mingw32-1.9.2/lib/libmcfgthread.a when searching for -lmcfgthread
/nix/store/3z2pf8l33d0aqiyl836lgmpaxy8gr97h-x86_64-w64-mingw32-binutils-2.44/bin/x86_64-w64-mingw32-ld: cannot find -lintl: No such file or directory
collect2: error: ld returned 1 exit status
```
