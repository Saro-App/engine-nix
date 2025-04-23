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
