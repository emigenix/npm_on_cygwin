# npm_on_cygwin
Default npm runs fine in Cygwin. Here is how you do it. 

Contrary to what the stubburn *[npm](https://github.com/npm/npm/)* maintainers say, you can easily run *npm* on the latest *Cygwin* installation. However, due to how Cygwin handles paths, you need to apply some patches and apply careful settings, when installing your *node/npm* combo. Unfortunately, eventhough a [working PR](https://github.com/npm/npm/pull/12366) for patching *npm*'s *[git.js](https://github.com/npm/npm/blob/master/lib/utils/git.js)*, it was rejected by the npm team who refuse to recognize Cygwin as a viable and popular platform. Here I will show you how to do it.


### Cygwin Requirements:

* To avoid weird problems, please make sure to start with a **fresh and updated Cygwin** installation. 
* Make sure you did **not** already install the Windows (CMD based) native *node* or *git*.
  (If you have them, please remove them now, as they will interfere.)

I will not tell you how to install Cygwin packages, but I stronly suggest to make your life a little simpler by using [`apt-cyg`](https://github.com/transcode-open/apt-cyg). Some of the required Cygwin packages are: `curl, wget, git, openssh, openssl, make, binutils` and `python*`. Install using: `apt-cyg install <pkgname>`.

Recall that you always need to restart your Cygwin shell if you change any native Windows system varibles and PATHs. 


### Installing Node.js and npm

0) Install Cygwin and required packages: wget, git, make etc. 

1) Make a new `<prefix>` directory on a root drive (eg. `C:/mybin/nodejs/` )
   ```sh
  $ mkdir /cygdrive/c/mybin/nodejs
   ```
   
2) Download the **latest 7z version** of *node* (eg. [node-v6.4.0-win-x64.7z](https://nodejs.org/dist/latest/node-v6.4.0-win-x64.7z) ) from:
   [https://nodejs.org/dist/latest/](https://nodejs.org/dist/latest/)
   
3) Extract all files into the *<prefix>* directory you made in (**1**).

4) Link the windows `node.exe` to `/bin/node`:
```sh
ln -s <prefix>/node.exe /bin/node
```

5) Add the node *<prefix>* path to your Windows *PATH* variable:
```sh
setx PATH "C:\mybin\nodejs;%PATH%"
```
6) Copy the correct [`.npmrc`]() file into your Cygwin `$HOME`:
```sh
cp npmrc_local.txt $HOME/.npmrc 
```

7) Patch the git.js for correct Cygwin behaviour.

   a) Download the patched git: [patched_git.js]()

   b) Replace `<prefix>/node_modules/npm/lib/utils/git.js` with the patched *git.js*: 

```sh
cd
cp /cygdrive/c/mybin/nodejs/node_modules/npm/lib/utils/git.js original_git.js
cp patched_git.js /cygdrive/c/mybin/nodejs/node_modules/npm/lib/utils/git.js
```
   c) Alternatively, make an alias of "git" using the [gitt.sh]() Bash script:
```sh
# mv /bin/git.exe /bin/gitbin
# cp gitt.sh /bin/git
```

8) Make npm recognize your Cygwin python installation.
```sh
npm config set python /usr/bin/python
```

9) Try to update npm to latest version:
```sh
# BROKEN -- DO NOT USE! 
# npm install npm@latest -g

curl -L https://www.npmjs.com/install.sh >install.sh
npm_config_prefix=/cygdrive/c/mybin/nodejs sh install.sh

# OR for more debug output:
# npm_debug=1 npm_config_prefix=/cygdrive/c/mybin/nodejs sh install.sh
```
10) Check your installation with: 
```sh
node -v && npm -v
```


### Install the most useful *npm* packages:

```bash
npm install -g npm-check-updates
npm install -g npm-check
npm install -g node-gyp

# PM2 uses git clone to install, make sure you've patched git.js!
npm install -g pm2
# Or install the latest (V2) release candidate (not tested!)
# npm install pm2@next -g

```

Check your installed node modules:
```bash
$ npm -g ls --depth=0

C:\mybin\nodejs
+-- node-gyp@3.4.0
+-- npm@3.10.6
+-- npm-check@5.2.3
+-- npm-check-updates@2.8.0
+-- pm2@1.1.3

$ npm-check --no-emoji --color -g
Your modules look amazing. Keep up the great work.

$ ncu -g
All global packages are up-to-date :)
```

Hope this helps!
