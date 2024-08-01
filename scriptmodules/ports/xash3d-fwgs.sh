#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="xash3d-fwgs"
rp_module_desc="xash3d-fwgs - Half-Life Engine Port"
rp_module_help="Please add your full version Half-Life data files (folders /valve, /bshift and /gearbox) to $romdir/ports/xash3d-fwgs/ to play."
rp_module_section="exp"
rp_module_flags="!mali !x86 !all rpi4 rpi3 rpi5"

function depends_xash3d-fwgs() {
    getDepends libsdl2-dev libfontconfig1-dev libfreetype6-dev
}

function sources_xash3d-fwgs() {
    gitPullOrClone "$md_build/$md_id" https://github.com/FWGS/xash3d-fwgs.git
    gitPullOrClone "$md_build/hlsdk" https://github.com/FWGS/hlsdk-portable.git
    gitPullOrClone "$md_build/bshiftsdk" https://github.com/FWGS/hlsdk-portable.git "bshift"
    gitPullOrClone "$md_build/opforsdk" https://github.com/FWGS/hlsdk-portable.git "opfor"
}

function build_xash3d-fwgs() {
    cd "$md_build/$md_id"
    ./waf configure -T release
    ./waf build
    cd "$md_build/hlsdk"
    ./waf configure -T release
    ./waf build
    cd "$md_build/bshiftsdk"
    ./waf configure -T release
    ./waf build
    cd "$md_build/opforsdk"
    ./waf configure -T release
    ./waf build
    md_ret_require=(
        "$md_build/$md_id/build/game_launch/xash3d"
        "$md_build/$md_id/build/engine/libxash.so"
        "$md_build/$md_id/build/3rdparty/mainui/libmenu.so"
        "$md_build/$md_id/build/ref/soft/libref_soft.so"
        "$md_build/$md_id/build/ref/gl/libref_gl.so"
		"$md_build/$md_id/build/filesystem/filesystem_stdio.so"
    )
}

function install_xash3d-fwgs() {
    md_ret_files=(
        "$md_id/build/game_launch/xash3d"
        "$md_id/build/engine/libxash.so"
        "$md_id/build/3rdparty/mainui/libmenu.so"
        "$md_id/build/ref/soft/libref_soft.so"
        "$md_id/build/ref/gl/libref_gl.so"
		"$md_id/build/filesystem/filesystem_stdio.so"
    )

}

function configure_xash3d-fwgs() {
    mkRomDir "ports/$md_id/valve"
    mkdir "$romdir/ports/$md_id/valve/cl_dlls"
    mkdir "$romdir/ports/$md_id/valve/dlls"
    mkdir -p "$romdir/ports/$md_id/bshift/cl_dlls"
    mkdir -p "$romdir/ports/$md_id/bshift/dlls"
    mkdir -p "$romdir/ports/$md_id/gearbox/cl_dlls"
    mkdir -p "$romdir/ports/$md_id/gearbox/dlls"
	moveConfigDir "$md_inst/valve" "$romdir/ports/$md_id/valve"
	moveConfigDir "$md_inst/bshift" "$romdir/ports/$md_id/bshift"
	moveConfigDir "$md_inst/gearbox" "$romdir/ports/$md_id/gearbox"
    cp "$md_build/hlsdk/build/cl_dll/client_armv8_32hf.so" "$romdir/ports/$md_id/valve/cl_dlls/client.so"
    cp "$md_build/hlsdk/build/dlls/hl_armv8_32hf.so" "$romdir/ports/$md_id/valve/dlls/hl.so"
    cp "$md_build/bshiftsdk/build/cl_dll/client_armv8_32hf.so" "$romdir/ports/$md_id/bshift/cl_dlls/client.so"
    cp "$md_build/bshiftsdk/build/dlls/bshift_armv8_32hf.so" "$romdir/ports/$md_id/bshift/dlls/hl.so"
    cp "$md_build/opforsdk/build/cl_dll/client_armv8_32hf.so" "$romdir/ports/$md_id/gearbox/cl_dlls/client.so"
    cp "$md_build/opforsdk/build/dlls/opfor_armv8_32hf.so" "$romdir/ports/$md_id/gearbox/dlls/hl.so"
	cp "$md_build/$md_id/build/3rdparty/extras/extras.pk3" "$romdir/ports/$md_id/valve/"
	cp "$md_build/$md_id/build/3rdparty/extras/extras.pk3" "$romdir/ports/$md_id/bshift/"
	cp "$md_build/$md_id/build/3rdparty/extras/extras.pk3" "$romdir/ports/$md_id/gearbox/"
	chown -R $user:$user "$romdir/ports/$md_id/"

    addPort "$md_id" "xash3d-fwgs" "Half-Life" "pushd $romdir/ports/$md_id/; LD_LIBRARY_PATH=$md_inst $md_inst/xash3d -game %ROM% -clientlib cl_dlls/client.so -dll dlls/hl.so; popd" "valve"
	addPort "$md_id" "xash3d-fwgs" "Half-Life - Blue Shift" "pushd $romdir/ports/$md_id/; LD_LIBRARY_PATH=$md_inst $md_inst/xash3d -game %ROM% -clientlib cl_dlls/client.so -dll dlls/hl.so; popd" "bshift"
	addPort "$md_id" "xash3d-fwgs" "Half-Life - Opposing Force" "pushd $romdir/ports/$md_id/; LD_LIBRARY_PATH=$md_inst $md_inst/xash3d -game %ROM% -clientlib cl_dlls/client.so -dll dlls/hl.so; popd" "gearbox"
}