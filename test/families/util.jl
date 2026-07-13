function test_default_eps()
    @test default_eps(SpinHalfTag) == (PauliX(), PauliY(), PauliZ())
    @test default_eps(FermionTag) == (MajoranaX(), MajoranaY(), MajoranaZ())
end

function test_hermitian_phase()
    @test hermitian_phase([PauliX(), PauliY()]) == 1.0 + 0.0im

    @test hermitian_phase([MajoranaX()]) == 1.0 + 0.0im
    @test hermitian_phase([MajoranaZ()]) == 1.0 + 0.0im

    @test hermitian_phase([MajoranaX(), MajoranaY()]) == 0.0 + 1.0im
    @test hermitian_phase([MajoranaX(), MajoranaZ()]) == 1.0 + 0.0im
    @test hermitian_phase([MajoranaY(), MajoranaZ()]) == 1.0 + 0.0im

    @test hermitian_phase([MajoranaX(), MajoranaY(), MajoranaZ()]) == 0.0 + 1.0im
end

function test_local_basis_operators_1()
    space = Space(SpinHalfSpace(), Hypercubic(2, OpenBoundary))
    ids = collect(indices(space))

    ops1 = local_basis_operators(ids, 1)
    ops2 = local_basis_operators(ids, 2)

    @test length(ops1) == binomial(length(ids), 1) * 3
    @test length(ops2) == binomial(length(ids), 2) * 3^2

    @test all(op -> op isa ProductOperator{SpinHalfTag}, ops1)
    @test all(op -> op isa ProductOperator{SpinHalfTag}, ops2)

    @test all(op -> adjoint(op) == op, ops1)
    @test all(op -> adjoint(op) == op, ops2)
end

function test_local_basis_operators_2()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))
    ids = collect(indices(space))

    ops1 = local_basis_operators(ids, 1)
    ops2 = local_basis_operators(ids, 2)

    @test length(ops1) == binomial(length(ids), 1) * 3
    @test length(ops2) == binomial(length(ids), 2) * 3^2

    @test all(op -> op isa ProductOperator{FermionTag}, ops1)
    @test all(op -> op isa ProductOperator{FermionTag}, ops2)

    @test all(op -> adjoint(op) == op, ops1)
    @test all(op -> adjoint(op) == op, ops2)
end

function test_local_basis_operators_3()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))
    ids = collect(indices(space))

    ops = local_basis_operators(ids, 2; only_same_site=true)

    @test length(ops) == 2 * 1 * 3^2
    @test all(op -> adjoint(op) == op, ops)
end

function test_local_basis_operators_4()
    space = Space(SpinfulFermionSpace(), Hypercubic(2, OpenBoundary))
    ids = collect(indices(space))

    ops = local_basis_operators(ids, 0; only_same_site=false)

    @test length(ops) == 1
    @test all(op -> adjoint(op) == op, ops)
end

@testset "utility" begin
    test_default_eps()
    test_hermitian_phase()
    test_local_basis_operators_1()
    test_local_basis_operators_2()
    test_local_basis_operators_3()
    test_local_basis_operators_4()
end
