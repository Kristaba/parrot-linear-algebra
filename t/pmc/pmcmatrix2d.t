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
        pla = loadlib './linalg_group'
        if pla goto pla_library_loaded
        say "Cannot load linalg_group"
        exit 1
      pla_library_loaded:
    };

    plan(3);
    create_pmcmatrix2d();
    op_does_matrix();
    vtable_get_pmc_keyed();
    vtable_get_integer_keyed();
    vtable_get_number_keyed();
    vtable_get_string_keyed();
    vtable_set_pmc_keyed();
    vtable_set_integer_keyed();
    vtable_set_number_keyed();
    vtable_set_string_keyed();
    vtable_get_string();
}

sub create_pmcmatrix2d() {
    Q:PIR {
        push_eh can_not_create
        $P0 = new ['PMCMatrix2D']
        $I0 = isnull $P0
        $I0 = not $I0
        'ok'($I0, "Can create a new PMCMatrix2D")
        .return()
      can_not_create:
        'ok'(0, "Could not create a PMCMatrix2D")
        .return()
    }
}

sub op_does_matrix() {
    Q:PIR {
        $P0 = new ['PMCMatrix2D']
        $I0 = does $P0, 'matrix'
        ok($I0, "PMCMatrix2D does matrix")
        $I0 = does $P0, 'gobbledegak'
        $I0 = not $I0
        ok($I0, "...and only does matrix")
    }
}

sub vtable_get_pmc_keyed() {}
sub vtable_get_integer_keyed() {}
sub vtable_get_number_keyed() {}
sub vtable_get_string_keyed() {}
sub vtable_set_pmc_keyed() {}
sub vtable_set_integer_keyed() {}
sub vtable_set_number_keyed() {}
sub vtable_set_string_keyed() {}
sub vtable_get_string() {}

