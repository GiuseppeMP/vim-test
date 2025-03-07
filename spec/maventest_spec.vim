source spec/support/helpers.vim

" add the integrationtest command for java files
command! -nargs=* -bar IntegrationTest call test#run('integration', split(<q-args>))

" add the DebugTestNearest command for java files
command! -nargs=* -bar DebugTestNearest call test#run('debug_nearest', split(<q-args>))

" add the DebugTestFile command for java files
command! -nargs=* -bar DebugTestFile call test#run('debug_file', split(<q-args>))



describe "Maven Junit3 tests"

  before
    cd spec/fixtures/maven/sample_maven_junit3_project
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches Test*.java)"
    view src/test/java/org/vimtest/math/TestMath.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.TestMath\*'
  end

  it "runs file tests (filename matches *Test.java)"
    view src/test/java/org/vimtest/math/MathTest.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTest\*'
  end

  it "runs file tests (filename matches *Tests.java)"
    view src/test/java/org/vimtest/math/MathTests.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTests\*'
  end

  it "runs file tests (filename matches *TestCase.java)"
    view src/test/java/org/vimtest/math/MathTestCase.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTestCase\*'
  end

  it "runs file tests with user provided options"
    view src/test/java/org/vimtest/math/MathTest.java
    TestFile -f pom.xml

    Expect g:test#last_command == 'mvn -f pom.xml test -Dtest=org.vimtest.math.MathTest\*'
  end

  it "runs nearest tests"
    view +37 src/test/java/org/vimtest/math/MathTest.java
    TestNearest

    Expect g:test#last_command == "mvn test -Dtest=org.vimtest.math.MathTest\\#testFailedAdd"
  end

  it "runs a suite"
    view src/test/java/org/vimtest/math/MathTest.java
    TestSuite

    Expect g:test#last_command == 'mvn test'
  end

  it "runs a test suite with user provided options"
    view src/test/java/org/vimtest/math/MathTest.java
    TestSuite -X -f pom.xml -DcustomProperty=5

    Expect g:test#last_command == 'mvn -X -f pom.xml -DcustomProperty=5 test'
  end


end

describe "Maven Junit3 multimodule tests"

  before
    cd spec/fixtures/maven/sample_maven_junit3_multimodule_project
  end

  after
    call Teardown()
    cd -
  end

  it "runs file tests (filename matches Test*.java)"
    view sample_module/src/test/java/org/vimtest/math/TestMath.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.TestMath\* -pl sample_module'
  end

  it "runs file tests (filename matches *Test.java)"
    view sample_module/src/test/java/org/vimtest/math/MathTest.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTest\* -pl sample_module'
  end

  it "runs file tests (filename matches *Tests.java)"
    view sample_module/src/test/java/org/vimtest/math/MathTests.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTests\* -pl sample_module'
  end

  it "runs file tests (filename matches *TestCase.java)"
    view sample_module/src/test/java/org/vimtest/math/MathTestCase.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.math.MathTestCase\* -pl sample_module'
  end

  it "runs file tests with user provided options"
    view sample_module/src/test/java/org/vimtest/math/MathTest.java
    TestFile -f pom.xml

    Expect g:test#last_command == 'mvn -f pom.xml test -Dtest=org.vimtest.math.MathTest\* -pl sample_module'
  end

  it "runs nearest tests"
    view +37 sample_module/src/test/java/org/vimtest/math/MathTest.java
    TestNearest

    Expect g:test#last_command == "mvn test -Dtest=org.vimtest.math.MathTest\\#testFailedAdd -pl sample_module"
  end

  it "runs a suite"
    view sample_module/src/test/java/org/vimtest/math/MathTest.java
    TestSuite

    Expect g:test#last_command == 'mvn test -pl sample_module'
  end

  it "runs a test suite with user provided options"
    view sample_module/src/test/java/org/vimtest/math/MathTest.java
    TestSuite -X -f pom.xml -DcustomProperty=5

    Expect g:test#last_command == 'mvn -X -f pom.xml -DcustomProperty=5 test -pl sample_module'
  end

  it "runs a suite from sub_multimodule/submodule2"
    view sub_multimodule/submoduleA/src/test/java/org/vimtest/math/MathTest.java
    TestSuite

    Expect g:test#last_command == 'mvn test -pl sub_multimodule/submoduleA'
  end


end

describe "Maven Junit5 tests"

  before
    cd spec/fixtures/maven/sample_maven_junit5_project
  end

  after
    call Teardown()
    cd -
  end

  it "TestFile runs with package-path, with asterisk to catch nested-test-classes"
    view +14 src/test/java/org/vimtest/TestApp.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\*'
  end

  it "TestNearest - @Test void func()"
    view +12 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_testdecorator_void'
  end

  it "TestNearest - @Test public void func()"
    view +17 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_testdecorator_public_void'
  end

  it "TestNearest - void func()"
    view +22 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_void'
  end

  it "TestNearest - public void func()"
    view +30 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_public_void'
  end

  it "TestNearest - nested test()"
    view +39 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\$Test_NestedTestClass\#test_nested_test'
  end

end


describe "Maven Junit5 tests (mvnw)"

  before
    cd spec/fixtures/maven/sample_maven_junit5_mvnw_project
  end

  after
    call Teardown()
    cd -
  end

  it "TestFile runs with package-path, with asterisk to catch nested-test-classes"
    view +14 src/test/java/org/vimtest/TestApp.java
    TestFile

    Expect g:test#last_command == './mvnw test -Dtest=org.vimtest.TestApp\*'
  end

  it "TestNearest - @Test void func()"
    view +12 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == './mvnw test -Dtest=org.vimtest.TestApp\#test_testdecorator_void'
  end

  it "TestNearest - @Test public void func()"
    view +17 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == './mvnw test -Dtest=org.vimtest.TestApp\#test_testdecorator_public_void'
  end

  it "TestNearest - void func()"
    view +22 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == './mvnw test -Dtest=org.vimtest.TestApp\#test_void'
  end

  it "TestNearest - public void func()"
    view +30 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == './mvnw test -Dtest=org.vimtest.TestApp\#test_public_void'
  end

  it "TestNearest - nested test()"
    view +39 src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == './mvnw test -Dtest=org.vimtest.TestApp\$Test_NestedTestClass\#test_nested_test'
  end

end



describe "Maven Junit5 multimodule tests"

  before
    cd spec/fixtures/maven/sample_maven_junit5_multimodule_project
  end

  after
    call Teardown()
    cd -
  end

  it "TestFile runs with package-path, with asterisk to catch nested-test-classes"
    view +14 sample_module/src/test/java/org/vimtest/TestApp.java
    TestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\* -pl sample_module'
  end

  it "DebugTestFile runs with package-path, with asterisk to catch nested-test-classes"
    view +14 sample_module/src/test/java/org/vimtest/TestApp.java
    DebugTestFile

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\* -pl sample_module -Dmaven.surefire.debug=true'
  end

  it "TestNearest - @Test void func()"
    view +12 sample_module/src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_testdecorator_void -pl sample_module'
  end

  it "TestNearest - @Test public void func()"
    view +17 sample_module/src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_testdecorator_public_void -pl sample_module'
  end

  it "TestNearest - void func()"
    view +22 sample_module/src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_void -pl sample_module'
  end

  it "TestNearest - public void func()"
    view +30 sample_module/src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\#test_public_void -pl sample_module'
  end

  it "TestNearest - nested test()"
    view +39 sample_module/src/test/java/org/vimtest/TestApp.java
    TestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\$Test_NestedTestClass\#test_nested_test -pl sample_module'
  end

  it "DebugTestNearest - nested test()"
    view +39 sample_module/src/test/java/org/vimtest/TestApp.java
    DebugTestNearest

    Expect g:test#last_command == 'mvn test -Dtest=org.vimtest.TestApp\$Test_NestedTestClass\#test_nested_test -pl sample_module -Dmaven.surefire.debug=true'
  end


end

describe "Integration tests single module"

  before
    cd spec/fixtures/maven/sample_maven_junit5_project
  end

  after
    call Teardown()
    cd -
  end

  it "IntegrationTest runs with verify without fully qualified classname"
    view +14 src/test/java/org/vimtest/TestApp.java
    IntegrationTest

    Expect g:test#last_command == 'mvn verify -Dit.test=TestApp\*'
  end


end
describe "Integration tests in multimodule"

  before
    cd spec/fixtures/maven/sample_maven_junit5_multimodule_project
  end

  after
    call Teardown()
    cd -
  end

    " When using TestNearest and TestFile on IntegrationTest, must skip the
    " verify plugins that not are failsafe.
    let t:skip_it_plugins = " -Dsonar.skip=true -Dpit.report.skip=true -Dpit.skip=true -Dpmd.skip=true -Dcheckstyle.skip=true -Ddependency-check.skip=true -Djacoco.skip=true -Dfailsafe.only=true"
    let t:expected_it_nearest_file_prefix = "mvn verify" . t:skip_it_plugins

  it "IntegrationTest runs with verify without fully qualified classname in the module"
    view +14 sample_module/src/test/java/org/vimtest/TestApp.java
    IntegrationTest

    Expect g:test#last_command == 'mvn verify -Dit.test=TestApp\* -pl sample_module'
  end

  it "TestNearest runs with verify fully qualified classname and method name, based on filename sufix *IT"

    view +13 sample_module/src/test/java/org/vimtest/AppIT.java

    TestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . " -Dit.test=org.vimtest.AppIT\\#test_integration_it -pl sample_module"

    DebugTestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . " -Dit.test=org.vimtest.AppIT\\#test_integration_it -pl sample_module"

    view +18 sample_module/src/test/java/org/vimtest/AppIT.java

    TestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppIT\#test_integration_it2 -pl sample_module'

    DebugTestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppIT\#test_integration_it2 -pl sample_module'

    view +23 sample_module/src/test/java/org/vimtest/AppIT.java

    TestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppIT\#test_integration_it3 -pl sample_module'

    DebugTestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppIT\#test_integration_it3 -pl sample_module'

  end

  it "TestNearest runs with verify fully qualified classname and method name, based on filename sufix *ITCase.java"
    view +13 sample_module/src/test/java/org/vimtest/AppITCase.java

    TestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppITCase\#test_integration_it_case -pl sample_module'

    DebugTestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppITCase\#test_integration_it_case -pl sample_module'

    view +18 sample_module/src/test/java/org/vimtest/AppITCase.java

    TestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppITCase\#test_integration_it_case2 -pl sample_module'

    DebugTestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppITCase\#test_integration_it_case2 -pl sample_module'


    view +23 sample_module/src/test/java/org/vimtest/AppITCase.java

    TestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppITCase\#test_integration_it_case3 -pl sample_module'

    DebugTestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppITCase\#test_integration_it_case3 -pl sample_module'

  end

  it "TestNearest runs with verify fully qualified classname and method name, based on filename sufix *Integration.java"
    view +13 sample_module/src/test/java/org/vimtest/AppTestIntegration.java

    TestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppTestIntegration\#test_integration -pl sample_module'

    DebugTestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppTestIntegration\#test_integration -pl sample_module'


    view +18 sample_module/src/test/java/org/vimtest/AppTestIntegration.java

    TestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppTestIntegration\#test_integration2 -pl sample_module'

    DebugTestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppTestIntegration\#test_integration2 -pl sample_module'

    view +23 sample_module/src/test/java/org/vimtest/AppTestIntegration.java

    TestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppTestIntegration\#test_integration3 -pl sample_module'

    DebugTestNearest
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppTestIntegration\#test_integration3 -pl sample_module'

  end

  it "TestFile runs with verify fully qualified classname, based on filename sufix *IT|Integration|ITCase.java"
    view +13 sample_module/src/test/java/org/vimtest/AppIT.java
    TestFile
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppIT\* -pl sample_module'

    DebugTestFile
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppIT\* -pl sample_module'

    view +13 sample_module/src/test/java/org/vimtest/AppITCase.java
    TestFile
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppITCase\* -pl sample_module'

    DebugTestFile
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppITCase\* -pl sample_module'

    view +13 sample_module/src/test/java/org/vimtest/AppTestIntegration.java
    TestFile
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppTestIntegration\* -pl sample_module'

    DebugTestFile
    Expect g:test#last_command == t:expected_it_nearest_file_prefix . ' -Dit.test=org.vimtest.AppTestIntegration\* -pl sample_module'

  end
end
