"""
    SpectralBackends

Zero-dependency Julia package providing a unified spectral-transform backend type hierarchy
for the jbphyswx ecosystem.  Every package that needs to dispatch on *which mathematical
transform* to use (FFT, NUFFT, SHT, direct summation, …) imports these types from here
instead of defining its own copy.

These types describe the **algorithm / library** axis, not the **parallelism / device** axis
(which is handled by `ComputationalBackends.jl`).

| Backend | Grid requirement | Library (loaded via extension) |
|---|---|---|
| [`DirectSumBackend`](@ref) | Any | None (always available) |
| [`FFTBackend`](@ref) | Uniform Cartesian | FFTW.jl |
| [`NUFFTBackend`](@ref) | Scattered Cartesian | FINUFFT.jl |
| [`SHTBackend`](@ref) | Structured spherical | FastSphericalHarmonics.jl |
| [`NUFSHTBackend`](@ref) | Scattered spherical | NUFSHT.jl |
| [`AutoSpectral`](@ref) | Any | Best available |

Heavy implementations live in consumer-package extensions; this package only defines the
dispatch types.
"""
module SpectralBackends

export AbstractSpectralBackend
export DirectSumBackend, FFTBackend, NUFFTBackend, SHTBackend, NUFSHTBackend
export AutoSpectral

# ──────────────────────────────────────────────────────────────────────────────
# Abstract root
# ──────────────────────────────────────────────────────────────────────────────

"""
    AbstractSpectralBackend

Abstract supertype for all spectral-transform backends.  Concrete subtypes dispatch the
general spectral-calculation interfaces to different mathematical methods and third-party
libraries.
"""
abstract type AbstractSpectralBackend end

# ──────────────────────────────────────────────────────────────────────────────
# Concrete backends
# ──────────────────────────────────────────────────────────────────────────────

"""
    DirectSumBackend <: AbstractSpectralBackend

Slow, serial fallback that computes the Discrete Fourier Transform (DFT) or Spherical
Harmonic Transform (SHT) via ``O(N \\cdot M)`` direct summation.  Fully self-contained —
requires no external packages.

# Details
- **Cartesian coordinates**: exact DFT at target frequencies.
- **Spherical coordinates**: direct projection onto the spherical harmonic basis via a
  type-stable associated-Legendre recurrence.
- **Complexity**: ``O(N \\cdot M)`` where ``N`` = spatial points, ``M`` = spectral modes.
"""
struct DirectSumBackend <: AbstractSpectralBackend end

"""
    FFTBackend <: AbstractSpectralBackend

Fast Fourier Transform backend for **uniform Cartesian** grids.  Leverages `FFTW.jl`
(via a consumer-package extension).

# Requirements
```julia
using FFTW   # loads the extension in the consumer package
```

# Details
- **Grid**: must be uniform and rectilinear.
- **Complexity**: ``O(N \\log N)``.
"""
struct FFTBackend <: AbstractSpectralBackend end

"""
    NUFFTBackend <: AbstractSpectralBackend

Non-Uniform Fast Fourier Transform backend for **scattered / non-uniform Cartesian** grids.
Leverages `FINUFFT.jl` (via a consumer-package extension).

# Requirements
```julia
using FINUFFT
```

# Details
- **Grid**: scattered / non-uniform Cartesian coordinates.
- **Complexity**: ``O(N \\log N + M \\log(1/\\epsilon))`` where ``\\epsilon`` is the target
  accuracy.
- Supports an accuracy parameter `eps` (typically defaults to `1e-8`).
"""
struct NUFFTBackend <: AbstractSpectralBackend end

"""
    SHTBackend <: AbstractSpectralBackend

Spherical Harmonic Transform backend for **structured spherical** grids (e.g. equiangular,
Clenshaw–Curtis).  Leverages `FastSphericalHarmonics.jl` (via a consumer-package extension).

# Requirements
```julia
using FastSphericalHarmonics
```

# Details
- **Grid**: latitude/longitude grids structured for quadrature (Clenshaw–Curtis nodes).
- **Complexity**: ``O(L^3)`` or ``O(L^2 \\log L)`` where ``L`` is `lmax`.
"""
struct SHTBackend <: AbstractSpectralBackend end

"""
    NUFSHTBackend <: AbstractSpectralBackend

Non-Uniform Fast Spherical Harmonic Transform backend for **unstructured / scattered
spherical** grids.  Leverages `NUFSHT.jl` (via a consumer-package extension).

# Requirements
```julia
using NUFSHT
```

# Details
- **Grid**: arbitrary scattered ``(\\theta, \\phi)`` coordinates on the sphere.
- **Complexity**: ``O(M \\log M + N \\log(1/\\epsilon))`` using Double Fourier Sphere (DFS)
  folding and NUFFT techniques.
- Supports `solve::Bool` to trigger an iterative CG solver for recovering spectral
  coefficients from scattered measurements.
"""
struct NUFSHTBackend <: AbstractSpectralBackend end

"""
    AutoSpectral <: AbstractSpectralBackend

Automatic spectral-backend selection.  Consumer packages resolve this to the best available
concrete backend (typically `FFTBackend` if FFTW is loaded, else `DirectSumBackend`).
"""
struct AutoSpectral <: AbstractSpectralBackend end

end # module SpectralBackends
