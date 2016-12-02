#!/bin/bash -x

# Partially copied from the attachment that is part of https://issues.apache.org/jira/browse/PIG-2599

# Clone the original pig from github
[ -d OriginalPig ] || git clone https://github.com/apache/pig OriginalPig

# Wipe our mavenized copy
rm -rf pig
cp -a OriginalPig pig
cd pig

function moveGitFiles {
    sourceDir="$1"
    targetDir="$2"
    filenames="$3"

    find ${sourceDir} -type d | while read name ; do mkdir -p ${targetDir}/$(echo ${name} | sed "s@^${sourceDir}@@g"); done
    if [ -z ${filenames+x} ];
    then
        echo "EMPTY ${filenames}"
        find ${sourceDir} -type f | while read name ; do git mv ${name} ${targetDir}/$(echo ${name} | sed "s@^${sourceDir}@@g"); done
    else
        echo "FILLED ${filenames}"
        find ${sourceDir} -type f -name ${filenames} | while read name ; do git mv ${name} ${targetDir}/$(echo ${name} | sed "s@^${sourceDir}@@g"); done
    fi
}


mkdir -p pig-bzip2 pig-shock pig-core pig-piggybank pig-zebra pig-tutorial

#Place pom files
test -f pom.xml               || cp ../files/pom/pig-pom.xml           pom.xml                && git add pom.xml
test -f pig-bzip2/pom.xml     || cp ../files/pom/pig-bzip2-pom.xml     pig-bzip2/pom.xml      && git add pig-bzip2/pom.xml
test -f pig-shock/pom.xml     || cp ../files/pom/pig-shock-pom.xml     pig-shock/pom.xml      && git add pig-shock/pom.xml
test -f pig-core/pom.xml      || cp ../files/pom/pig-core-pom.xml      pig-core/pom.xml       && git add pig-core/pom.xml
test -f pig-piggybank/pom.xml || cp ../files/pom/pig-piggybank-pom.xml pig-piggybank/pom.xml  && git add pig-piggybank/pom.xml
test -f pig-zebra/pom.xml     || cp ../files/pom/pig-zebra-pom.xml     pig-zebra/pom.xml      && git add pig-zebra/pom.xml
test -f pig-tutorial/pom.xml  || cp ../files/pom/pig-tutorial-pom.xml  pig-tutorial/pom.xml   && git add pig-tutorial/pom.xml

fgrep '=' ivy/libraries.properties | sed 's@\(.*\)=\(.*\)@    <\1>\2</\1>@g' > pom.xml.versions
sed -i -e '/<!-- ivy versions -->/r pom.xml.versions' pom.xml


moveGitFiles 'lib-src/bzip2/org/apache/tools'   'pig-bzip2/src/main/java/org/apache/tools' '*.java'
moveGitFiles 'lib-src/bzip2/org/apache/pig'     'pig-core/src/main/java/org/apache/pig' '*.java'

#setup pig-shock/*
#git mv lib-src/shock/ pig-shock/src/main/java/                          # --include \*.java

#setup pig-core/src/main
moveGitFiles 'src/org/'         'pig-core/src/main/java/org/'       '*.java'
moveGitFiles 'src/org/'         'pig-core/src/main/java/org/'       'package.html'
moveGitFiles 'src/org/'         'pig-core/src/main/antlr3/org/'     '*.g'
moveGitFiles 'src/org/'         'pig-core/src/main/javacc/org/'     '*.jj'
moveGitFiles 'src/org/'         'pig-core/src/main/resources/org/'  # All remaining files

#setup shims
moveGitFiles 'shims/src/'       'pig-core/src/main/shims/'          '*.java'

#setup pig-core/src/test
moveGitFiles 'test/org/'        'pig-core/src/test/java/'           '*.java'
moveGitFiles 'test/org/'        'pig-core/src/test/javacc/'         '*.jjt'
moveGitFiles 'test/org/'        'pig-core/src/test/pig/'            '*.pig'
moveGitFiles 'shims/src/'       'pig-core/src/test/shims/'          '*.java'


moveGitFiles 'test/org/'    'pig-core/src/test/resources/'

#setup pig-piggybank/*
moveGitFiles 'contrib/piggybank/java/src/main/java/org/'   'pig-piggybank/src/main/java/org/'           '*.java'
moveGitFiles 'contrib/piggybank/java/src/main/java/org/'   'pig-piggybank/src/main/resources/org/'

moveGitFiles 'contrib/piggybank/java/src/test/java/org/'   'pig-piggybank/src/test/java/org/'           '*.java'
moveGitFiles 'contrib/piggybank/java/src/test/java/org/'   'pig-piggybank/src/testresources/java/org/'

#setup zerbra/*
moveGitFiles 'contrib/zebra/src/java/org/'   'pig-zebra/src/main/java/org/'       '*.java'
moveGitFiles 'contrib/zebra/src/java/org/'   'pig-zebra/src/main/jjtree/org/'     '*.jjt'
moveGitFiles 'contrib/zebra/src/java/org/'   'pig-zebra/src/main/resources/org/'

moveGitFiles 'contrib/zebra/src/test/org/'   'pig-zebra/src/test/java/org/'       '*.java'
moveGitFiles 'contrib/zebra/src/test/org/'   'pig-zebra/src/test/resources/org/'

#setup tutorial
moveGitFiles 'tutorial/src/org/'   'pig-tutorial/src/main/java/org/'              '*.java'
moveGitFiles 'tutorial/src/org/'   'pig-tutorial/src/main/resources/org/'





# Clean empty directories
find . -type d  | xargs rmdir
find . -type d  | xargs rmdir
find . -type d  | xargs rmdir
find . -type d  | xargs rmdir
find . -type d  | xargs rmdir
find . -type d  | xargs rmdir
find . -type d  | xargs rmdir
find . -type d  | xargs rmdir
find . -type d  | xargs rmdir

exit

