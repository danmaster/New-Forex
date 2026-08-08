## Compilation for Windows

Please note, that you don't need to compile the project to be able to run it, you can use EX binary files instead.
You may want to consider EA compilation only if you want to dive into the source code and do some modifications such as adding new indicators or strategies or simply to debug it to see how it works.

### Requirements

- Download and install MetaEditor (part of [MetaTrader](https://www.metatrader5.com/) platform).
- Download and install [Git client](https://git-scm.com/download) (alternatively [GitHub Desktop](https://desktop.github.com/) app).

### Steps

#### Method using Git GUI

To compile the project, follow these steps:

1. Open _MetaEditor_.
2. Open _Experts_ folder in _File Explorer_. You can do that from _File_ menu, then choose _Open Data Folder_ and enter _MQL?/Experts_ folder, or by selecting _Experts_ folder and choose _Open Folder_ from the contextual menu.
3. Once the folder is opened in _File Explorer_, open contextual menu and select _Git GUI Here_ (assuming you've installed Git client, as per above _Requirements_).
4. In _Git GUI_, choose _Clone Existing Repository_ and type `https://github.com/EA31337/EA31337` as a _Source Location_ and `EA31337` (you can choose a different name) as a _Target Directory_, then _Clone_ it.
5. After Cloning, to checkout the specific version, in _Git GUI_ select _Branch_ menu and _Checkout..._, then select _Tag_ and choose the version to checkout. For the latest development version, choose `master` branch.
6. Go back to _MetaEditor_ app, and open _Experts/EA31337/src/EA31337.mq4_, then _Compile_.

    <sup>Note: For older versions (<v1.076), you also need to clone `https://github.com/EA31337/EA31337-classes` repository into _MQL?/Include_ folder (similar as above). Make sure you checkout the same version for both repositories.</sup>

7. If you've got any problems, check _Troubleshooting_ section below or raise an issue.

### Method using Git Bash

1. Open MetaEditor.
2. Select _Experts_ folder and choose _Open Folder_ from the context menu.
3. In opened folder, select _Git Bash Here_ and type:

        git clone --recursive https://github.com/EA31337/EA31337

4. Now open `Experts/EA31337/src/EA31337.mq5` and hit Compile button.

    <sup>Note: For MQL4, open `EA31337.mq4` file instead.</sup>

5. If you've got any problems, check _Troubleshooting_ section below or raise an issue.

### General method

To compile the project, you need to

1. Download or clone (recursively) this repository into platform's _MQL4/Experts_ folder, for example:

        git clone --recurse-submodules https://github.com/EA31337/EA31337.git

    <sup>Note: To open that folder, run platform and select *File, Open Data Folder* from the menu.</sup>

1. Symlink or copy _src/include/EA31337_ folder into _MQL4/Include_ folder.
1. Clone [`EA31337-classes`](https://github.com/EA31337/EA31337-classes) repository into _MQL4/Include_ folder.
1. Open the main `EA31337.mq5` file in *MetaEditor* and hit Compile button.

    <sup>Note: For MQL4, open `EA31337.mq4` file instead.</sup>

1. In some cases (different branches/versions), you may also need to clone [`EA31337-strategies`](https://github.com/EA31337/EA31337-strategies) into _src/include/EA_ folder.

    <sup>Note: When downloading a ZIP file, it's missing the git submodules, so you need to clone it recursively.</sup>

### Compiling specific version

To compile the specific version of the project, use git to checkout the right version, e.g.:

1. After cloning project recursively, run `git tag` to see all the available versions.
2. Change the code to point to the specific version, for example: `git checkout v1.076`.
3. For version _v1.066_ and above, make sure your include files are compatible with the given version.

    For example, when using symbolic links, files in include's folder should be automatically updated. Otherwise you need to copy required dependencies manually.

### Troubleshooting

> '=' - object required or structure have objects and cannot be copied

This is the platform bug. Please upgrade MetaEditor 5 to at least build 1745. If you can't find it, copy it from MetaTrader 5.