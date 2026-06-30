using SpectralBackends: SpectralBackends
using Test: Test

const SB = SpectralBackends

Test.@testset "SpectralBackends.jl" begin

    # ── Construction ─────────────────────────────────────────────────────
    Test.@testset "Construction" begin
        Test.@test SB.DirectSumBackend() isa SB.AbstractSpectralBackend
        Test.@test SB.FFTBackend() isa SB.AbstractSpectralBackend
        Test.@test SB.NUFFTBackend() isa SB.AbstractSpectralBackend
        Test.@test SB.SHTBackend() isa SB.AbstractSpectralBackend
        Test.@test SB.NUFSHTBackend() isa SB.AbstractSpectralBackend
        Test.@test SB.AutoSpectral() isa SB.AbstractSpectralBackend
    end

    # ── Subtyping ────────────────────────────────────────────────────────
    Test.@testset "Subtyping" begin
        Test.@test SB.DirectSumBackend <: SB.AbstractSpectralBackend
        Test.@test SB.FFTBackend <: SB.AbstractSpectralBackend
        Test.@test SB.NUFFTBackend <: SB.AbstractSpectralBackend
        Test.@test SB.SHTBackend <: SB.AbstractSpectralBackend
        Test.@test SB.NUFSHTBackend <: SB.AbstractSpectralBackend
        Test.@test SB.AutoSpectral <: SB.AbstractSpectralBackend
    end

    # ── Singletons (no fields) ──────────────────────────────────────────
    Test.@testset "Singletons" begin
        Test.@test fieldcount(SB.DirectSumBackend) == 0
        Test.@test fieldcount(SB.FFTBackend) == 0
        Test.@test fieldcount(SB.NUFFTBackend) == 0
        Test.@test fieldcount(SB.SHTBackend) == 0
        Test.@test fieldcount(SB.NUFSHTBackend) == 0
        Test.@test fieldcount(SB.AutoSpectral) == 0
    end

    # ── Equality (singleton identity) ────────────────────────────────────
    Test.@testset "Equality" begin
        Test.@test SB.DirectSumBackend() === SB.DirectSumBackend()
        Test.@test SB.FFTBackend() === SB.FFTBackend()
        Test.@test SB.AutoSpectral() === SB.AutoSpectral()
    end

    # ── Distinctness ─────────────────────────────────────────────────────
    Test.@testset "Distinctness" begin
        backends = [
            SB.DirectSumBackend(),
            SB.FFTBackend(),
            SB.NUFFTBackend(),
            SB.SHTBackend(),
            SB.NUFSHTBackend(),
            SB.AutoSpectral(),
        ]
        for i in eachindex(backends), j in eachindex(backends)
            if i != j
                Test.@test typeof(backends[i]) !== typeof(backends[j])
            end
        end
    end

end
