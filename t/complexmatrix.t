#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    my $num_tests := 18;
    Q:PIR {
        .local pmc c
        load_language 'parrot'
        c = compreg 'parrot'
        c.'import'('Test::More')

        .local pmc pla
        pla = loadlib 'linalg_group'
        if pla goto pla_library_loaded
        say "Cannot load linalg_group"
        exit 1
      pla_library_loaded:
    };

    plan(10);

    create_complexmatrix2d();
    op_does_matrix();
}

sub create_complexmatrix2d() {
    Q:PIR {
        push_eh can_not_create
        $P0 = new ['ComplexMatrix2D']
        $I0 = isnull $P0
        $I0 = not $I0
        'ok'($I0, "Can create a new ComplexMatrix2D")
        .return()
      can_not_create:
        'ok'(0, "Could not create a ComplexMatrix2D")
        .return()
    }
}

sub op_does_matrix() {
    Q:PIR {
        $P0 = new ['ComplexMatrix2D']
        $I0 = does $P0, 'matrix'
        ok($I0, "ComplexMatrix2D does matrix")
        $I0 = does $P0, 'gobbledegak'
        $I0 = not $I0
        ok($I0, "...and only does matrix")
    }
}

