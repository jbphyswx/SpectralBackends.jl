# SpectralBackends.jl

Zero-dependency Julia package providing a unified spectral-transform backend type hierarchy
for the [jbphyswx](https://github.com/jbphyswx) ecosystem.

## Motivation

Multiple packages (`FlowFieldSpectra.jl`, `ScatteringTransforms.jl`,
`FlowInvariantTransfer.jl`, …) independently defined near-identical spectral-backend type
hierarchies. `SpectralBackends.jl` is the single source of truth — downstream packages
import these types instead of maintaining local copies.

These types describe **which mathematical transform** to use, not **where/how to execute**
(which is handled by [`ComputationalBackends.jl`](../ComputationalBackends.jl)).

## Exported Types

| Type | Grid requirement | Library (consumer extension) |
|---|---|---|
| `DirectSumBackend` | Any | None (always available) |
| `FFTBackend` | Uniform Cartesian | FFTW.jl |
| `NUFFTBackend` | Scattered Cartesian | FINUFFT.jl |
| `SHTBackend` | Structured spherical | FastSphericalHarmonics.jl |
| `NUFSHTBackend` | Scattered spherical | NUFSHT.jl |
| `AutoSpectral` | Any | Best available |

## Usage

```julia
using SpectralBackends: SpectralBackends as SB

# Direct use
backend = SB.FFTBackend()

# Auto-selection (resolved by consumer package)
backend = SB.AutoSpectral()

# Type dispatch in consumer package
function compute_spectrum(::SB.FFTBackend, data, ...)
    # FFTW-based implementation
end
```