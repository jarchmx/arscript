#!/bin/sh

#export PATH=$PATH:

echo ""
echo "Start ramdump parser.."

usage()
{
    cat << EOF
Usage:
$0 <options ...>

  Global:
    -p <product>
    -v <yocto version>
  Available products: ar758x/ar759x/em91
  Available yocto version: 1.7/2.2/2.7
  Notes:
    Please copy defconfig and INITRAMFS files to the folder $0 run in"
EOF
    exit 1
}

while getopts "p:v:" arg
do
    case $arg in
    p)
        PRODUCT=$OPTARG
        echo "Product: $PRODUCT"
        ;;
    v)
        VERSION=$OPTARG
        echo "VERSION: $VERSION"
        ;;
    ?)
        echo "$0: invalid option -$OPTARG" 1>&2
        usage
        ;;
    esac
done

if [ "$PRODUCT" == "ar758x" ] && [ "$VERSION" == "1.7" ];then
    gdb=/opt/swi/y17-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-gdb
    nm=/opt/swi/y17-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-nm
    objdump=/opt/swi/y17-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-objdump
    ARGS="--force-hardware 9607 "
elif [ "$PRODUCT" == "ar758x" ] && [ "$VERSION" == "2.2" ];then
    gdb=/opt/swi/y22-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-gdb
    nm=/opt/swi/y22-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-nm
    objdump=/opt/swi/y22-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-objdump
    ARGS="--force-hardware 9607 "
elif [ "$PRODUCT" == "ar759x" ] && [ "$VERSION" == "1.7" ];then
    gdb=/opt/swi/y17-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-gdb
    nm=/opt/swi/y17-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-nm
    objdump=/opt/swi/y17-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-objdump
    ARGS="--force-hardware 9640 "
elif [ "$PRODUCT" == "ar759x" ] && [ "$VERSION" == "2.2" ];then
    gdb=/opt/swi/y22-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-gdb
    nm=/opt/swi/y22-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-nm
    objdump=/opt/swi/y22-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-objdump
    ARGS="--force-hardware 9640 "
elif [ "$PRODUCT" == "em91" ] && [ "$VERSION" == "2.7" ];then
    gdb=/opt/swi/y27-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-gdb
    nm=/opt/swi/y27-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-nm
    objdump=/opt/swi/y27-ext/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi/arm-poky-linux-gnueabi-objdump
    ARGS="--force-hardware sdxprairie "
else
    echo "Wrong product or yocto version"
    usage
fi


local_path=$PWD
ramdump=$local_path/
vmlinux=$local_path/vmlinux
out=$local_path/out

# git clone git://codeaurora.org/quic/la/platform/vendor/qcom-opensource/tools
ramparse_dir=/home/jarhu/sw/qualcomm/tools/linux-ramdump-parser-v2/
########################################################################################

echo "cd $ramparse_dir"
cd $ramparse_dir
echo ""

echo "python ramparse.py -v $vmlinux -g $gdb  -n $nm  -j $objdump -a $ramdump -o $out -x $ARGS"
python ramparse.py -v $vmlinux -g $gdb  -n $nm  -j $objdump -a $ramdump -o $out -x $ARGS

cd $local_path
echo "out: $out"
echo ""
exit 0