my $tests := Test::NumMatrix2D::ConvertToNumberMatrix.new();
$tests.suite.run;

class Test::NumMatrix2D::ConvertToNumberMatrix is Pla::Methods::ConvertToNumberMatrix {
    INIT {
        use('UnitTest::Testcase');
        use('UnitTest::Assertions');
    }

    has $!factory;
    method factory() {
        unless pir::defined__IP($!factory) {
            $!factory := Pla::MatrixFactory::NumMatrix2D.new();
        }
        return $!factory;
    }
}
