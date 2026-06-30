# SpectralBackends.jl

Zero-dependency Julia package defining dispatch types for spectral-transform algorithm selection.

## Exported Types

| Type | Grid requirement | Typical library |
|---|---|---|
| `DirectSumBackend` | Any | None (always available) |
| `FFTBackend` | Uniform Cartesian | FFTW.jl |
| `NUFFTBackend` | Scattered Cartesian | FINUFFT.jl |
| `SHTBackend` | Structured spherical | FastSphericalHarmonics.jl |
| `NUFSHTBackend` | Scattered spherical | NUFSHT.jl |
| `AutoSpectral` | Any | Best available |

All types are subtypes of `AbstractSpectralBackend`.

## Usage

```julia
using SpectralBackends: SpectralBackends as SB

# Select a spectral backend for dispatch
backend = SB.FFTBackend()
backend = SB.AutoSpectral()

# Type dispatch in your own package
function compute_spectrum(::SB.FFTBackend, data, ...)
    # FFTW-based implementation
end
```