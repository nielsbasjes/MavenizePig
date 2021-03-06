#!/bin/bash
#-x

# Partially copied from the attachment that is part of https://issues.apache.org/jira/browse/PIG-2599

# Clone the original pig from github
if [ ! -d OriginalPig ];
then
    git clone https://github.com/apache/pig OriginalPig
fi

rm -rf pig
git clone OriginalPig pig
cd pig

# Ignore IntelliJ
echo ".idea" >> .gitignore
echo '!tutorial/**/*.log' >> .gitignore


pwd

function gitMoveFiles {
    sourceDir="$1"
    targetDir="$2"
    filenames="$3"

    if [ ! -d ${sourceDir} ];
    then
        echo "Source directory does not exist: ${sourceDir}"
        return
    fi

    mkdir -p "${targetDir}"

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

mkdir -p bzip2 core piggybank tutorial

#Place pom files
fgrep '=' ../OriginalPig/ivy/libraries.properties \
    | sed 's@\(.*\)=\(.*\)@    <\1>\2</\1>@g' \
    | fgrep -v hbase \
    | fgrep -v avro \
    > pom.xml.versions

cat ../files/pom/pig-pom.xml  \
    | sed -e '/INSERT IVY VERSIONS HERE/r pom.xml.versions' | fgrep -v "INSERT IVY VERSIONS HERE" \
    | sed -e '/INSERT IVY DEPENDENCIES HERE/r ../files/dependencies.pom.xml' | fgrep -v "INSERT IVY DEPENDENCIES HERE" \
    | fgrep -v 'DUMMYdependencies' \
    | sed 's@<jersey.version>1.8</jersey.version>@<jersey.version>1.9</jersey.version>@' \
    > pom.xml
rm pom.xml.versions

git add pom.xml

cp ../files/pom/bzip2-pom.xml     bzip2/pom.xml      && git add bzip2/pom.xml
cp ../files/pom/core-pom.xml      core/pom.xml       && git add core/pom.xml
cp ../files/pom/piggybank-pom.xml piggybank/pom.xml  && git add piggybank/pom.xml
cp ../files/pom/tutorial-pom.xml  tutorial/pom.xml   && git add tutorial/pom.xml

gitMoveFiles 'lib-src/bzip2/org/apache/tools'   'bzip2/src/main/java/org/apache/tools'  '*.java'
gitMoveFiles 'lib-src/bzip2/org/apache/pig'     'core/src/main/java/org/apache/pig'     '*.java'
cleanDir     'lib-src/'

#setup core/src/main
gitMoveFiles 'src/org/'         'core/src/main/java/org/'       '*.java'
gitMoveFiles 'src/org/'         'core/src/main/java/org/'       'package.html'
gitMoveFiles 'src/org/'         'core/src/main/antlr3/org/'     '*.g'
gitMoveFiles 'src/org/'         'core/src/main/javacc/org/'     '*.jj'
gitMoveFiles 'src/'             'core/src/main/resources/'       'pig-default.properties'
gitMoveFiles 'src/META-INF/'    'core/src/main/resources/META-INF/'
gitMoveFiles 'src/org/'         'core/src/main/resources/org/'  # All remaining files
cleanDir     'src/org/'

# We ONLY do the Spark 2 thing
git mv core/src/main/java/org/apache/pig/backend/hadoop/executionengine/spark/Spark1Shims.java{,__}
git mv core/src/main/java/org/apache/pig/tools/pigstats/spark/Spark1JobStats.java{,__}

#setup shims
gitMoveFiles 'shims/src/hadoop2'                   'core/src/main/java'          '*.java'
#gitMoveFiles 'shims/test/hadoop2'                  'core/src/test/java'          '*.java'
#gitMoveFiles 'shims/src/'                         'core/src/test/shims/'    '*.java'
cleanDir     'shims/src/'
git rm -rf shims


#setup core/src/test
gitMoveFiles 'test/org/'        'core/src/test/java/org/'           '*.java'
gitMoveFiles 'test/org/'        'core/src/test/javacc/org/'         '*.jjt'
gitMoveFiles 'test/org/'        'core/src/test/resources/org/'      '*.pig'
gitMoveFiles 'test/org/'        'core/src/test/resources/org/'
cleanDir     'test/org/'
# Fix the paths where the test files can be located
find core/src/test/ -type f | xargs -n1 sed -i 's@test/org/apache/pig/@src/test/resources/org/apache/pig/@g'
find core/src/test/ -type f | xargs -n1 sed -i 's@"build/@"target/@g'
find core/src/test/ -type f | xargs -n1 sed -i 's@/build/@/target/@g'

#setup piggybank/*
gitMoveFiles 'contrib/piggybank/java/src/main/java/org/'   'piggybank/src/main/java/org/'           '*.java'
gitMoveFiles 'contrib/piggybank/java/src/main/java/org/'   'piggybank/src/main/resources/org/'
gitMoveFiles 'contrib/piggybank/java/src/test/java/org/'   'piggybank/src/test/java/org/'           '*.java'
gitMoveFiles 'contrib/piggybank/java/src/test/java/org/'   'piggybank/src/test/resources/org/'
git rm ./contrib/piggybank/java/build.xml
git rm ./contrib/piggybank/java/lib/.gitignore

# Fix the paths where the test files can be located
find piggybank/src/test/ -type f | xargs -n1 sed -i 's@src/test/java/org/apache/pig/piggybank/test/@src/test/resources/org/apache/pig/piggybank/test/@g'
find piggybank/src/test/ -type f | xargs -n1 sed -i 's@"build/@"target/@g'
find piggybank/src/test/ -type f | xargs -n1 sed -i 's@/build/@/target/@g'

# TODO: Check if this is Ok. This changelog has not been updated since 2013
git mv ./contrib/CHANGES.txt 'piggybank/'
cleanDir     'contrib'

#setup tutorial
gitMoveFiles 'tutorial/src/org/'   'tutorial/src/main/java/org/'              '*.java'
gitMoveFiles 'tutorial/src/org/'   'tutorial/src/main/resources/org/'
#gitMoveFiles 'tutorial/data'       'tutorial/data'
#gitMoveFiles 'tutorial/scripts'    'tutorial/scripts'
git rm tutorial/build.xml
cleanDir     'tutorial/'

# Remove stuff no longer useful
git rm -rf .eclipse.templates

git rm build.xml
git rm ivy/*
cleanDir     '.'

# Now commit all done by the script so I can more esily trace what I changed manually
git commit -m"Script migration completed" -a


patch -p0 < ../Code-patches.diff

exit 0
