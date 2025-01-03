# MuPDF

This repository is a fork of [ArtifexSoftware/mupdf](https://github.com/ArtifexSoftware/mupdf), with some modifications for use by [arklumpus/MuPDFCore](https://github.com/arklumpus/MuPDFCore) (which provides cross-platform .NET bindings for MuPDF). The changes implemented here cover two main areas:

1. Features and bugfixes not implemented in the upstream MuPDF library.
    * At this time, these mainly involve optional content group support for optional content groups (also known as layers) [more details in ArtifexSoftware/mupdf#51, [Bug 707999](https://bugs.ghostscript.com/show_bug.cgi?id=707999)].

2. Fixes to allow for easy compilation of static `libmupdf` (and `libmupdf-third`) artifacts on the platforms supported by [MuPDFCore](https://github.com/arklumpus/MuPDFCore) (i.e., Windows x86, x64 and ARM; macOS x64 and Apple Silicon/ARM; Linux x64 and ARM, both with GLIBC and musl).

## Structure

The branches in this repository are structured hierarchically as follows:

```
master
 └ build
    ├ linux_arm64
    ├ linux_x64
    ├ macOS
    ├ win_arm
    ├ win_x64
    └ win_x86
```

The `master` branch contains platform-independent bugfixes/improvements to the MuPDF library (e.g., number 1 above), while the `build` branch contains specific changes to allow for easy compilation of the artifacts needed by MuPDFCore (but still platform-independent). The OS/architecture specific branches contain platform-specific changes (the `linux_arm64` and `linux_x64` branches work for both GLIBC and musl, while the `macOS` branch works for both Intel/x64 and Apple Silicon/ARM).

## Build instructions

To compile the MuPDF artifacts needed by MuPDFCore, first clone this repository all its submodules:

```bash
git clone --recursive https://github.com/arklumpus/mupdf
```

Make sure you are on the `master` branch, then run the `create_archives.sh` script to create the buildable source archives for the various platforms:

```bash
git checkout --recurse-submodules master
./create_archives.sh
```

This will produce six archives that you should copy on machines running the corresponding OS:

* `mupdf-linux_arm64.tar.gz` on ARM Linux machines (both GLIBC- and musl-based).

* `mupdf-linux_x64.tar.gz` on x64 Linux machines (both GLIBC- and musl-based).

* `mupdf-macOS.tar.gz` on macOS machines (both Intel/x64 and Apple Silicon/ARM)

* `mupdf-win_arm.tar.gz` on an ARM Windows machine.

* `mupdf-win_x64.tar.gz` on an x64 Windows machine.

* `mupdf-win_x86.tar.gz` on an x86 Windows machine.

Then, you basically just need to extract the archive and run the build script inside.

### Windows

Make sure you have installed Visual Studio with the "Desktop development with C++" workflow. I used Visual Studio 2022 on Windows 11 x64 and ARM, and Visual Studio 2019 on Windows 10 x86.

Then, extract the appropriate archive and open the native tools developer command prompt for your platform (`x64`, `x86` or `ARM`) and run the `build.cmd` script:

```bash
tar -xzf mupdf-win_xxx.tar.gz
cd mupdf-win_xxx
build
```

Some errors may occur, but after building the library, the script will run a simple check to verify that the appropriate `libmupdf.lib` file has been produced (and tell you where to find it).

### Linux

You will need a reasonably recent version of GCC (7.3.1 should be enough), as well as `pkg-config`. Extract the archive file, then run the build script:

```bash
tar -xzf mupdf-linux_xxx.tar.gz
cd mupdf-linux_xxx
chmod +x build.sh
./build.sh
```

The library files `libmupdf.a` and `libmupdf-third.a` will be created in the `build/release` subfolder.

### macOS

You will need the Xcode command line tools to build the library. Extract the archive file, then run the build script:

```bash
tar -xzf mupdf-macOS.tar.gz
cd mupdf-macOS
chmod +x build.sh
./build.sh
```

The library files `libmupdf.a` and `libmupdf-third.a` will be created in the `build/release` subfolder.

## Syncing with the upstream library

This fork is currently based on [MuPDF 1.25.2](https://github.com/ArtifexSoftware/mupdf/releases/tag/1.25.2). I plan to update this when releasing new versions of MuPDFCore.

To update the underlying MuPDF version:

1. Add a new remote to the official Artifex repository:

    ```bash
    git remote add artifex https://github.com/ArtifexSoftware/mupdf
    git fetch artifex
    ```

2. Create a new branch tracking the appropriate remote branch:

    ```bash
    git checkout --recurse-submodules -b latest artifex/1.25.x
    ```

    Where `1.25.x` is the name of the branch in the MuPDF repository and `latest` is the name of the new local branch.

3. Merge the new branch into the `master` branch (resolve any conflicts):

    ```bash
    git checkout --recurse-submodules master
    git merge latest
    ```

4. Merge the `master` branch into the `build` branch:

    ```bash
    git checkout --recurse-submodules build
    git merge master
    ```

5. Merge the `build` branch into each of the platform-specific branches:

    ```bash
    git checkout --recurse-submodules linux_arm64
    git merge build

    git checkout --recurse-submodules linux_x64
    git merge build

    git checkout --recurse-submodules macOS
    git merge build

    git checkout --recurse-submodules win_arm
    git merge build

    git checkout --recurse-submodules win_x64
    git merge build

    git checkout --recurse-submodules win_x86
    git merge build
    ```

And this should be it. You can now checkout the `master` branch again and create the buildable source archives.

The original MuPDF readme and licence follow below; please note that I am in no way affiliated with Artifex Software.

---

ABOUT

MuPDF is a lightweight open source software framework for viewing and converting
PDF, XPS, and E-book documents.

See the documentation in:

	https://mupdf.readthedocs.io/en/latest/

Build instructions can be found in:

	https://mupdf.readthedocs.io/en/latest/quick-start-guide.html

LICENSE

MuPDF is Copyright (c) 2006-2023 Artifex Software, Inc.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU Affero General Public License along
with this program. If not, see <http://www.gnu.org/licenses/>.

For commercial licensing, including our "Indie Dev" friendly options,
please contact sales@artifex.com.

REPORTING BUGS AND PROBLEMS

The MuPDF developers hang out on Discord here:

	https://discord.gg/taPnFQp5gb

Report bugs on the ghostscript bugzilla, with MuPDF as the selected component:

	http://bugs.ghostscript.com/

If you are reporting a problem with a specific file, please include the file as
an attachment.
