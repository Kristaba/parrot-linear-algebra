class Pla::Methods::IterateFunctionInplace is Pla::MatrixTestBase {

    INIT {
        use('UnitTest::Testcase');
        use('UnitTest::Assertions');
    }

    # Test that we can iterate a function in-place
    method test_iterate_function_inplace() {
        my $m := self.factory.defaultmatrix2x2();
        my $n := self.factory.matrix();
        $n{Key.new(0,0)} := self.factory.fancyvalue(0);
        $n{Key.new(0,1)} := self.factory.fancyvalue(1);
        $n{Key.new(1,0)} := self.factory.fancyvalue(2);
        $n{Key.new(1,1)} := self.factory.fancyvalue(3);
        my $count := -1;
        my $sub := pir::newclosure__PP(sub ($matrix, $value, $x, $y) {
            $count++;
            return self.factory.fancyvalue($count);
        });
        $m.iterate_function_inplace($sub);
        assert_equal($count, 3, "iteration did not happen for all elements");
        assert_equal($m, $n, "iteration did not create the correct result");
    }

    # test that iterate_function_inplace calls the callback with the proper
    # coordinates
    method test_pass_correct_coordinates() {
        my $m := self.factory.fancymatrix2x2();
        my $count := 0;
        my $x_ords := [0, 0, 1, 1];
        my $y_ords := [0, 1, 0, 1];
        my $sub := pir::newclosure__PP(sub ($matrix, $value, $x, $y) {
            assert_equal($x, $x_ords[$count], "x coordinate is correct");
            assert_equal($y, $y_ords[$count], "y coordinate is correct");
            $count++;
            return (self.factory.defaultvalue());
        });
        $m.iterate_function_inplace($sub);
        assert_equal($count, 4, "iteration did not happen for all elements");
    }

    # Test that iterate_function_inplace passes the correct args
    method test_pass_optional_arguments() {
        my $m := self.factory.fancymatrix2x2();
        my $count := 0;
        my $first := 5;
        my $second := 2;
        my $sub := pir::newclosure__PP(sub ($matrix, $value, $x, $y, $a, $b) {
            assert_equal($a, $first, "first arg is not equal: " ~ $x);
            assert_equal($b, $second, "second arg is not equal: " ~ $y);
            $count++;
            return (self.factory.defaultvalue());
        });
        $m.iterate_function_inplace($sub, $first, $second);
        assert_equal($count, 4, "iteration did not happen for all elements");
    }

    # Test that iterate_function_external respects the transpose state of the
    # matrix
    method test_handles_lazy_transpose() {
        my $m := self.factory.fancymatrix2x2();
        $m.transpose();
        my $n := self.factory.matrix2x2(self.factory.fancyvalue(0) * 2, self.factory.fancyvalue(2) * 2,
                                self.factory.fancyvalue(1) * 2, self.factory.fancyvalue(3) * 2);
        my $sub := sub ($matrix, $value, $x, $y) {
            return ($value * 2);
        };
        $m.iterate_function_inplace($sub);
        assert_equal($m, $n, "external iteration does not respect transpose");
    }

}
