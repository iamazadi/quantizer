using Test
using Porta


logicdir = "logic_tests"
linearalgebradir = "linearalgebra_tests"
geometrydir = "geometry_tests"


start = time()


@time @testset "The Logic Tests" begin
    include(joinpath(logicdir, "propositionallogic_tests.jl"))
    include(joinpath(logicdir, "predicatelogic_tests.jl"))
end

@time @testset "The Linear Algebra Tests" begin
    include(joinpath(linearalgebradir, "determinant_tests.jl"))
    include(joinpath(linearalgebradir, "real3_tests.jl"))
    include(joinpath(linearalgebradir, "real4_tests.jl"))
end

@time @testset "The Geometry Tests" begin
    include(joinpath(geometrydir, "s2_tests.jl"))
    include(joinpath(geometrydir, "s3_tests.jl"))
    include(joinpath(geometrydir, "stereographicprojection_tests.jl"))
    include(joinpath(geometrydir, "rotations_tests.jl"))
    include(joinpath(geometrydir, "body_tests.jl"))
end


elapsed = time() - start
println("Testing took", elapsed)
