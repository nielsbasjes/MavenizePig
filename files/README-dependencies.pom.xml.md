From ivy.xml to dependencies.pom.xml
===

This is a manual operation

MANUAL ACTIONS IN INTELLIJ S(earch) and R(eplace) in ivy.xml
=

Keep only the dependencies part

S:  "\n
R:  "

S: changing="true"

S:  <dependency +org="([^"]+)" *name="([^"]+)" *rev="([^"]+)"  *conf="([^"]+)" */?>
R:  <dependency><groupId>$1</groupId><artifactId>$2</artifactId><version>$3</version></dependency>

S:  <exclude +org="([^"]+)" */?>
R:  <exclusion><groupId>$1</groupId><artifactId>*</artifactId></exclusion>

S:  <exclude>
R:  <exclusions>

S:  </exclude>
R:  </exclusions>

S:  <exclude +org="([^"]+)" *module="([^"]+)" */?>
R:  <exclusion><groupId>$1</groupId><artifactId>$2</artifactId></exclusion>




S:  <artifact name="([^"]+)" ext="([^"]+)" (m:classifier="tests")?/>


And then fix it all manually
