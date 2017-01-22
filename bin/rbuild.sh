#!/bin/bash
RHINO=/cygdrive/c/Users/jens/workspace/_libs/rhino/js.jar
CLOSURE=/cygdrive/c/Users/jens/workspace/_libs/closure-compiler/compiler.jar
RJS=$(cygpath -wa /cygdrive/c/Users/jens/workspace/_libs/r.js)
BUILD=$(cygpath -wa /cygdrive/c/Users/jens/workspace/Carnect\ Mobile/assets/www/build.js)
CLASSPATH=$(cygpath -wp "$RHINO:$CLOSURE")


echo "RJS       $RJS"
echo "BUILD     $BUILD"
echo "CLASSPATH $CLASSPATH"

java -classpath $CLASSPATH -Xss1024k org.mozilla.javascript.tools.shell.Main $RJS -o "$BUILD"