function default_eps(::Type{SpinHalfTag})
    return (PauliX(), PauliY(), PauliZ())
end

function default_eps(::Type{FermionTag})
    return (MajoranaX(), MajoranaY(), MajoranaZ())
end

function hermitian_phase(
    eps::AbstractVector{<:AbstractPrimitive{T}}
) where {T<:AbstractSystemTag}
    if T == FermionTag
        p = sum(majorana_parity, eps)
        return ifelse(
            iseven(p * (p - 1) ÷ 2),
            1.0 + 0.0im,
            0.0 + 1.0im
        )
    else
        return 1.0 + 0.0im
    end
end

function local_basis_operators(
    ids::AbstractVector{I},
    locality::Int,
    only_same_site=false,
    eps=default_eps(T),
) where {T<:AbstractSystemTag,I<:AbstractIndex{T}}
    pos = Vector{ProductOperator{T,I}}()

    for ids_comb in combinations(ids, locality)
        if only_same_site && length(unique(site.(ids_comb))) > 1
            continue
        end
        for eps_comb in Iterators.product(ntuple(_ -> eps, locality)...)
            eps_comb = collect(eps_comb)
            phase = hermitian_phase(eps_comb)
            push!(pos, ProductOperator(ids_comb, eps_comb, phase))
        end
    end

    return pos
end
