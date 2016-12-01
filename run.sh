#!/bin/bash -x

# Partially copied from the attachment that is part of https://issues.apache.org/jira/browse/PIG-2599

# Clone the original pig from github
[ -d OriginalPig ] || git clone https://github.com/apache/pig OriginalPig

# Wipe our mavenized copy
rm -rf pig
cp -a OriginalPig pig

#setup directories
cd pig
mkdir -p pig-bzip2/src/{main,test}
mkdir -p pig-core/src/{main/{java,antlr3,javacc,resources,shims},test/{java,javacc,resources,shims}}
mkdir -p pig-shock/src/{main/java,test}}
mkdir -p pig-piggybank/src/{main/{java,resources},test/{java,resources}}
mkdir -p pig-zebra/src/{main/{java,jjtree,resources},test/{java,resources}}
mkdir -p pig-tutorial/src/main/{java,resources}

test -f pom.xml               || cp ../files/pom/pig-pom.xml           pom.xml
test -f pig-bzip2/pom.xml     || cp ../files/pom/pig-bzip2-pom.xml     pig-bzip2/pom.xml
test -f pig-shock/pom.xml     || cp ../files/pom/pig-shock-pom.xml     pig-shock/pom.xml
test -f pig-core/pom.xml      || cp ../files/pom/pig-core-pom.xml      pig-core/pom.xml
test -f pig-piggybank/pom.xml || cp ../files/pom/pig-piggybank-pom.xml pig-piggybank/pom.xml
test -f pig-zebra/pom.xml     || cp ../files/pom/pig-zebra-pom.xml     pig-zebra/pom.xml
test -f pig-tutorial/pom.xml  || cp ../files/pom/pig-tutorial-pom.xml  pig-tutorial/pom.xml

git add pom.xml
git add pig-bzip2/pom.xml
git add pig-shock/pom.xml
git add pig-core/pom.xml
git add pig-piggybank/pom.xml
git add pig-zebra/pom.xml
git add pig-tutorial/pom.xml

mkdir -p pig-bzip2/src/main/java/org/apache/tools pig-core/src/main/java/org/apache/pig
git mv lib-src/bzip2/org/apache/tools   pig-bzip2/src/main/java/org/apache/tools
git mv lib-src/bzip2/org/apache/pig     pig-core/src/main/java/org/apache/pig

#setup pig-shock/*
#git mv lib-src/shock/ pig-shock/src/main/java/                          # --include \*.java

mkdir -p pig-core/src/main/{java,antlr3,javacc,resources}/org
#setup pig-core/src/main
git mv src/org/   pig-core/src/main/java/org/                           # --include "*/"# --include "*.java" --exclude "*"
git mv src/org/   pig-core/src/main/antlr3/org/                         # --include "*/"# --include "*.g"    --exclude "*"
git mv src/org/   pig-core/src/main/javacc/org/                         # --include "*/"# --include "*.jj"   --exclude "*"
git mv src/org/   pig-core/src/main/resources/org/                      # --include "*/"  --exclude "*.java" --exclude "*.g" --exclude "*.jj"


#setup shims
git mv shims/src/ pig-core/src/main/shims/                              # --include "*/"# --include "*.java" --exclude "*"

#setup pig-core/src/test
git mv test/org/       pig-core/src/test/java/org/                      # --include "*/"# --include "*.java"  --exclude "*"
git mv test/org/       pig-core/src/test/javacc/org/                    # --include "*/"# --include "*.jjt"  --exclude "*"
git mv shims/test/     pig-core/src/test/shims/                         # --include "*/"# --include "*.java" --exclude "*"
git mv test/org/       pig-core/src/test/resources/org/                 # --include "*/"  --exclude "*.java" --exclude "*.jjt"

#setup pig-piggybank/*
git mv contrib/piggybank/java/src/main/java/org/   pig-piggybank/src/main/java/org/      # --include "*/"# --include "*.java"  --exclude "*"
git mv contrib/piggybank/java/src/main/java/org/   pig-piggybank/src/main/resources/org/ # --include "*/"                      --exclude "*.java"
#git mv contrib/piggybank/java/src/test/java/org/  pig-piggybank/src/test/java/org/      # --include "*/"# --include "*.java"  --exclude "*"
git mv contrib/piggybank/java/src/test/java/org/   pig-piggybank/src/test/java/org/      # --include "*/"
git mv contrib/piggybank/java/src/test/java/org/   pig-piggybank/src/test/resources/org/ # --include "*/"                      --exclude "*.java"

#setup zerbra/*
git mv contrib/zebra/src/java/org/   pig-zebra/src/main/java/org/       # --include "*/"# --include "*.java"  --exclude "*"
git mv contrib/zebra/src/java/org/   pig-zebra/src/main/jjtree/org/     # --include "*/"# --include "*.jjt"   --exclude "*"
git mv contrib/zebra/src/java/org/   pig-zebra/src/main/resources/org/  # --include "*/"  --exclude "*.java"  --exclude "*.jjt"
git mv contrib/zebra/src/test/org/   pig-zebra/src/test/java/org/       # --include "*/"# --include "*.java"  --exclude "*"
git mv contrib/zebra/src/test/org/   pig-zebra/src/test/resources/org/  # --include "*/"  --exclude "*.java"

#setup tutorial
git mv tutorial/src/org/   pig-tutorial/src/main/java/org/              # --include "*/"# --include "*.java"  --exclude "*"
git mv tutorial/src/org/   pig-tutorial/src/main/resources/org/         # --include "*/"  --exclude "*.java"

