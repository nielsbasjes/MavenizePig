#!/bin/bash

# Partially copied from the attachment that is part of https://issues.apache.org/jira/browse/PIG-2599

# Clone the original pig from github
[ -d OriginalPig ] || git clone https://github.com/apache/pig OriginalPig

if [ ! -d pig ];
then
    rm -rf pig
    cp -a OriginalPig pig
fi
cd pig

function moveGitFiles {
    sourceDir="$1"
    targetDir="$2"
    filenames="$3"

    if [ ! -d ${sourceDir} ];
    then
        echo "Source directory does not exist: ${sourceDir}"
        return
    fi

    find ${sourceDir} -type d | while read name ; do mkdir -p ${targetDir}/$(echo ${name} | sed "s@^${sourceDir}@@g"); done
    if [ "x${filenames}" == "x" ];
    then
        echo "Moving ALL files from ${sourceDir} to ${targetDir}"
        find ${sourceDir} -type f | while read name ; do git mv ${name} ${targetDir}/$(echo ${name} | sed "s@^${sourceDir}@@g"); done
    else
        echo "Moving all ${filenames} from ${sourceDir} to ${targetDir}"
        find ${sourceDir} -type f -name ${filenames} | while read name ; do git mv ${name} ${targetDir}/$(echo ${name} | sed "s@^${sourceDir}@@g"); done
    fi
}

function cleanDir {
    sourceDir="$1"
    if [ "x${sourceDir}" == "x" ];
    then
        echo "WILL NOT REMOVE WITHOUT SOURCE DIRECTORY TO CHECK"
        return
    fi
    echo "Cleaning empty directories from ${sourceDir}"
    [ -d ${sourceDir} ] && find ${sourceDir} -type d | xargs rmdir > /dev/null 2>&1
    [ -d ${sourceDir} ] && find ${sourceDir} -type d | xargs rmdir > /dev/null 2>&1
    [ -d ${sourceDir} ] && find ${sourceDir} -type d | xargs rmdir > /dev/null 2>&1
    [ -d ${sourceDir} ] && find ${sourceDir} -type d | xargs rmdir > /dev/null 2>&1
    [ -d ${sourceDir} ] && find ${sourceDir} -type d | xargs rmdir > /dev/null 2>&1
    [ -d ${sourceDir} ] && find ${sourceDir} -type d | xargs rmdir > /dev/null 2>&1
    [ -d ${sourceDir} ] && find ${sourceDir} -type d | xargs rmdir > /dev/null 2>&1
}

mkdir -p pig-bzip2 pig-shock pig-core pig-piggybank pig-zebra pig-tutorial

#Place pom files
fgrep '=' ../OriginalPig/ivy/libraries.properties | sed 's@\(.*\)=\(.*\)@    <\1>\2</\1>@g' > pom.xml.versions
sed -e '/INSERT IVY VERSIONS HERE/r pom.xml.versions' ../files/pom/pig-pom.xml | fgrep -v "INSERT IVY VERSIONS HERE" > pom.xml
rm pom.xml.versions
git add pom.xml

cp ../files/pom/pig-bzip2-pom.xml     pig-bzip2/pom.xml      && git add pig-bzip2/pom.xml
cp ../files/pom/pig-shock-pom.xml     pig-shock/pom.xml      && git add pig-shock/pom.xml
cp ../files/pom/pig-core-pom.xml      pig-core/pom.xml       && git add pig-core/pom.xml
cp ../files/pom/pig-piggybank-pom.xml pig-piggybank/pom.xml  && git add pig-piggybank/pom.xml
cp ../files/pom/pig-zebra-pom.xml     pig-zebra/pom.xml      && git add pig-zebra/pom.xml
cp ../files/pom/pig-tutorial-pom.xml  pig-tutorial/pom.xml   && git add pig-tutorial/pom.xml

moveGitFiles 'lib-src/bzip2/org/apache/tools'   'pig-bzip2/src/main/java/org/apache/tools' '*.java'
moveGitFiles 'lib-src/bzip2/org/apache/pig'     'pig-core/src/main/java/org/apache/pig' '*.java'
cleanDir     'lib-src/'

#setup pig-shock/*
#git mv lib-src/shock/ pig-shock/src/main/java/                          # --include \*.java

#setup pig-core/src/main
moveGitFiles 'src/org/'         'pig-core/src/main/java/org/'       '*.java'
moveGitFiles 'src/org/'         'pig-core/src/main/java/org/'       'package.html'
moveGitFiles 'src/org/'         'pig-core/src/main/antlr3/org/'     '*.g'
moveGitFiles 'src/org/'         'pig-core/src/main/javacc/org/'     '*.jj'
moveGitFiles 'src/org/'         'pig-core/src/main/resources/org/'  # All remaining files
cleanDir     'src/org/'

#setup shims
moveGitFiles 'shims/src/'       'pig-core/src/main/shims/'          '*.java'
moveGitFiles 'shims/src/'       'pig-core/src/test/shims/'          '*.java'
cleanDir     'shims/src/'



#setup pig-core/src/test
moveGitFiles 'test/org/'        'pig-core/src/test/java/'           '*.java'
moveGitFiles 'test/org/'        'pig-core/src/test/javacc/'         '*.jjt'
moveGitFiles 'test/org/'        'pig-core/src/test/pig/'            '*.pig'
moveGitFiles 'test/org/'        'pig-core/src/test/resources/'
cleanDir     'test/org/'

#setup pig-piggybank/*
moveGitFiles 'contrib/piggybank/java/src/main/java/org/'   'pig-piggybank/src/main/java/org/'           '*.java'
moveGitFiles 'contrib/piggybank/java/src/main/java/org/'   'pig-piggybank/src/main/resources/org/'
moveGitFiles 'contrib/piggybank/java/src/test/java/org/'   'pig-piggybank/src/test/java/org/'           '*.java'
moveGitFiles 'contrib/piggybank/java/src/test/java/org/'   'pig-piggybank/src/test/resources/org/'
git rm ./contrib/piggybank/java/build.xml
git rm ./contrib/piggybank/java/lib/.gitignore

# TODO: Check if this is Ok. This changelog has not been updated since 2013
git rm ./contrib/CHANGES.txt
cleanDir     'contrib/piggybank/'

#setup zebra/*
moveGitFiles 'contrib/zebra/src/java/org/'   'pig-zebra/src/main/java/org/'       '*.java'
moveGitFiles 'contrib/zebra/src/java/org/'   'pig-zebra/src/main/jjtree/org/'     '*.jjt'
moveGitFiles 'contrib/zebra/src/java/org/'   'pig-zebra/src/main/resources/org/'

moveGitFiles 'contrib/zebra/src/test/org/'   'pig-zebra/src/test/java/org/'       '*.java'
moveGitFiles 'contrib/zebra/src/test/org/'   'pig-zebra/src/test/resources/org/'
cleanDir     'contrib/zebra/'

#setup tutorial
moveGitFiles 'tutorial/src/org/'   'pig-tutorial/src/main/java/org/'              '*.java'
moveGitFiles 'tutorial/src/org/'   'pig-tutorial/src/main/resources/org/'
moveGitFiles 'tutorial/data'       'pig-tutorial/data'
moveGitFiles 'tutorial/scripts'    'pig-tutorial/scripts'
git rm tutorial/build.xml
cleanDir     'tutorial/'

git rm build.xml
git rm ivy/*
cleanDir     '.'
