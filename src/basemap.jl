import GLMakie


export Basemap
export update!
export make


"""
    make(q, gauge, M, segments, chart)

Make a 2-surface of the horizontal section at point `q` after transformation with `f`, and with the given `segments` number and `chart`.
"""
function make(q::Quaternion, gauge::Float64, f::Matrix{Float64}, segments::Integer; chart::NTuple{4, Float64} = (-π / 4, π / 4, -π / 4, π / 4))
    lspaceθ = range(chart[1], stop = chart[2], length = segments)
    lspaceϕ = range(chart[3], stop = chart[4], length = segments)
    [project(normalize(f * (q * Quaternion(exp(θ * K(1) + -ϕ * K(2)) * exp(gauge * K(3)))))) for ϕ in lspaceϕ, θ in lspaceθ]
end


"""
    Represents a horizontal subspace.

fields: q, f, chart, segments, color and observable.
"""
mutable struct Basemap <: Sprite
    q::Quaternion
    gauge::Float64
    f::Matrix{Float64}
    chart::NTuple{4, Float64}
    segments::Integer
    color::Any
    observable::Tuple{GLMakie.Observable{Matrix{Float64}}, GLMakie.Observable{Matrix{Float64}}, GLMakie.Observable{Matrix{Float64}}}
    Basemap(scene::GLMakie.LScene, q::Quaternion, gauge::Float64, f::Matrix{Float64}, chart::NTuple{4, Float64}, segments::Integer, color::Any; transparency::Bool = false) = begin
        matrix = make(q, gauge, f, segments, chart = chart)
        observable = buildsurface(scene, matrix, color, transparency = transparency)
        new(q, gauge, f, chart, segments, color, observable)
    end
end


"""
    update!(basemap, q, gauge, M)

Switch to the right horizontal section with the given point `q`, `gauge` and transformation `f`.
"""
function update!(basemap::Basemap, q::Quaternion, gauge::Float64, f::Matrix{Float64})
    basemap.q = q
    basemap.gauge = gauge
    basemap.f = f
    matrix = make(q, gauge, f, basemap.segments, chart = basemap.chart)
    updatesurface!(matrix, basemap.observable)
end


"""
    update!(basemap, chart)

Update the bundle chart in the horizontal subspace with the given 'chart.
"""
function update!(basemap::Basemap, chart::NTuple{4, Float64})
    basemap.chart = chart
    matrix = make(basemap.q, basemap.gauge, basemap.f, basemap.segments, chart = chart)
    updatesurface!(matrix, basemap.observable)
end

