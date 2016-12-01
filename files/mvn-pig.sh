#!/bin/bash

usage(){
    echo "Usage: $0 <pig-ant-dir> <pig-maven-dir>"
    echo "  <pig-ant-dir> location of ant pig-code"
    echo "  default is to svn check out 'pig-ant-dir'"
    echo "  <pig-maven-dir> location of mvn pig-code"
    echo "  default is 'pig-maven-dir'"    
    exit 1
}

default_pig_ant_dir='pig-ant'
pig_ant_dir=${1:-$default_pig_ant_dir}
default_pig_mvn_dir='pig-mvn'
pig_mvn_dir=${2:-$default_pig_mvn_dir}

echo "ant pig : $pig_ant_dir"
echo "mvn pig : $pig_mvn_dir"

pig_svn_url='http://svn.apache.org/repos/asf/pig/trunk'

if [ ! -d "$pig_ant_dir" ]; then
    echo "missing ant directory : '$pig_ant_dir'"
    echo "pulling from svn $pig_svn_url"
    svn export $pig_svn_url $pig_ant_dir
fi

#setup directories
rm -rf ${pig_mvn_dir}
mkdir -p ${pig_mvn_dir}/pig-bzip2/src/{main,test}
mkdir -p ${pig_mvn_dir}/pig-core/src/{main/{java,antlr3,javacc,resources,shims},test/{java,javacc,resources,shims}}
mkdir -p ${pig_mvn_dir}/pig-shock/src/{main/java,test}}
mkdir -p ${pig_mvn_dir}/pig-piggybank/src/{main/{java,resources},test/{java,resources}}
mkdir -p ${pig_mvn_dir}/pig-zebra/src/{main/{java,jjtree,resources},test/{java,resources}}
mkdir -p ${pig_mvn_dir}/pig-tutorial/src/main/{java,resources}

test -f "${pig_mvn_dir}/pom.xml"               || cp pom/pig-pom.xml           "${pig_mvn_dir}/pom.xml"
test -f "${pig_mvn_dir}/pig-bzip2/pom.xml"     || cp pom/pig-bzip2-pom.xml     "${pig_mvn_dir}/pig-bzip2/pom.xml"
test -f "${pig_mvn_dir}/pig-shock/pom.xml"     || cp pom/pig-shock-pom.xml     "${pig_mvn_dir}/pig-shock/pom.xml"
test -f "${pig_mvn_dir}/pig-core/pom.xml"      || cp pom/pig-core-pom.xml      "${pig_mvn_dir}/pig-core/pom.xml"
test -f "${pig_mvn_dir}/pig-piggybank/pom.xml" || cp pom/pig-piggybank-pom.xml "${pig_mvn_dir}/pig-piggybank/pom.xml"
test -f "${pig_mvn_dir}/pig-zebra/pom.xml"     || cp pom/pig-zebra-pom.xml     "${pig_mvn_dir}/pig-zebra/pom.xml"
test -f "${pig_mvn_dir}/pig-tutorial/pom.xml"  || cp pom/pig-tutorial-pom.xml  "${pig_mvn_dir}/pig-tutorial/pom.xml"

#rsync_options='-n'
#rsync_options='--remove-source-files'
#setup pig-bzip2/*

rsync ${rsync_options} -avm ${pig_ant_dir}/lib-src/bzip2/ ${pig_mvn_dir}/pig-bzip2/src/main/java/      --include \*.java --exclude pig
rsync ${rsync_options} -avm ${pig_ant_dir}/lib-src/bzip2/ ${pig_mvn_dir}/pig-core/src/main/java/       --include \*.java --exclude tools

#setup pig-shock/*
rsync ${rsync_options} -avm ${pig_ant_dir}/lib-src/shock/ ${pig_mvn_dir}/pig-shock/src/main/java/      --include \*.java

#setup pig-core/src/main
rsync ${rsync_options} -avm ${pig_ant_dir}/src/org/   ${pig_mvn_dir}/pig-core/src/main/java/org/       --include "*/"  --include "*.java" --exclude "*" 
rsync ${rsync_options} -avm ${pig_ant_dir}/src/org/   ${pig_mvn_dir}/pig-core/src/main/antlr3/org/     --include "*/"  --include "*.g"    --exclude "*" 
rsync ${rsync_options} -avm ${pig_ant_dir}/src/org/   ${pig_mvn_dir}/pig-core/src/main/javacc/org/     --include "*/"  --include "*.jj"   --exclude "*" 
rsync ${rsync_options} -avm ${pig_ant_dir}/src/org/   ${pig_mvn_dir}/pig-core/src/main/resources/org/  --include "*/"  --exclude "*.java" --exclude "*.g" --exclude "*.jj"
#setup shims
rsync ${rsync_options} -avm ${pig_ant_dir}/shims/src/ ${pig_mvn_dir}/pig-core/src/main/shims/          --include "*/"  --include "*.java" --exclude "*"

#setup pig-core/src/test
rsync ${rsync_options} -avm ${pig_ant_dir}/test/org/       ${pig_mvn_dir}/pig-core/src/test/java/org/       --include "*/"  --include "*.java"  --exclude "*" 
rsync ${rsync_options} -avm ${pig_ant_dir}/test/org/       ${pig_mvn_dir}/pig-core/src/test/javacc/org/     --include "*/"  --include "*.jjt"  --exclude "*"
rsync ${rsync_options} -avm ${pig_ant_dir}/shims/test/     ${pig_mvn_dir}/pig-core/src/test/shims/          --include "*/"  --include "*.java" --exclude "*"
rsync ${rsync_options} -avm ${pig_ant_dir}/test/org/       ${pig_mvn_dir}/pig-core/src/test/resources/org/  --include "*/"  --exclude "*.java" --exclude "*.jjt"

#setup pig-piggybank/*
rsync ${rsync_options} -avm ${pig_ant_dir}/contrib/piggybank/java/src/main/java/org/   ${pig_mvn_dir}/pig-piggybank/src/main/java/org/      --include "*/"  --include "*.java"  --exclude "*" 
rsync ${rsync_options} -avm ${pig_ant_dir}/contrib/piggybank/java/src/main/java/org/   ${pig_mvn_dir}/pig-piggybank/src/main/resources/org/ --include "*/"                      --exclude "*.java"
#rsync ${rsync_options} -avm ${pig_ant_dir}/contrib/piggybank/java/src/test/java/org/  ${pig_mvn_dir}/pig-piggybank/src/test/java/org/      --include "*/"  --include "*.java"  --exclude "*" 
rsync ${rsync_options} -avm ${pig_ant_dir}/contrib/piggybank/java/src/test/java/org/   ${pig_mvn_dir}/pig-piggybank/src/test/java/org/      --include "*/" 
rsync ${rsync_options} -avm ${pig_ant_dir}/contrib/piggybank/java/src/test/java/org/   ${pig_mvn_dir}/pig-piggybank/src/test/resources/org/ --include "*/"                      --exclude "*.java"

#setup zerbra/*
rsync ${rsync_options} -avm ${pig_ant_dir}/contrib/zebra/src/java/org/   ${pig_mvn_dir}/pig-zebra/src/main/java/org/      --include "*/"  --include "*.java"  --exclude "*" 
rsync ${rsync_options} -avm ${pig_ant_dir}/contrib/zebra/src/java/org/   ${pig_mvn_dir}/pig-zebra/src/main/jjtree/org/    --include "*/"  --include "*.jjt"   --exclude "*"
rsync ${rsync_options} -avm ${pig_ant_dir}/contrib/zebra/src/java/org/   ${pig_mvn_dir}/pig-zebra/src/main/resources/org/ --include "*/"  --exclude "*.java"  --exclude "*.jjt"
rsync ${rsync_options} -avm ${pig_ant_dir}/contrib/zebra/src/test/org/   ${pig_mvn_dir}/pig-zebra/src/test/java/org/      --include "*/"  --include "*.java"  --exclude "*" 
rsync ${rsync_options} -avm ${pig_ant_dir}/contrib/zebra/src/test/org/   ${pig_mvn_dir}/pig-zebra/src/test/resources/org/ --include "*/"  --exclude "*.java"

#setup tutorial
rsync ${rsync_options} -avm ${pig_ant_dir}/tutorial/src/org/   ${pig_mvn_dir}/pig-tutorial/src/main/java/org/      --include "*/"  --include "*.java"  --exclude "*" 
rsync ${rsync_options} -avm ${pig_ant_dir}/tutorial/src/org/   ${pig_mvn_dir}/pig-tutorial/src/main/resources/org/ --include "*/"  --exclude "*.java"

#run build
mvn -v >/dev/null 2>&1 && mvn -f ${pig_mvn_dir}/pig-bzip2/pom.xml install
mvn -v >/dev/null 2>&1 && mvn -f ${pig_mvn_dir}/pig-shock/pom.xml install
mvn -v >/dev/null 2>&1 && mvn -f ${pig_mvn_dir}/pig-core/pom.xml      -Ddont-run-test=true install
mvn -v >/dev/null 2>&1 && mvn -f ${pig_mvn_dir}/pig-piggybank/pom.xml -Ddont-run-test=true install
