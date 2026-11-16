# Exact One-Bit Bound for the E7 Bell Inequality

A computer-assisted proof of the exact one-bit classical bound

\[
\boxed{
L_{\mathrm{1bit}}(\mathrm{Plato}_{E_7})=563
<
567=Q(\mathrm{Plato}_{E_7}).
}
\]

The result establishes the value conjectured by Márton, Bene, Diviánszky, and Vértesi in their 2024 paper on classical communication and quantum correlations.

The bound covers arbitrary shared randomness and either direction of one total communicated bit.

## Repository contents

| File | Contents |
|---|---|
| [E7_Exact_One_Bit_Bound.pdf](E7_Exact_One_Bit_Bound.pdf) | Mathematical proof, reduction to a finite reflection orbit, computational certificate description, and an attaining strategy. |
| [E7OneBit.lean](E7OneBit.lean) | Lean proofs of certificate-coverage logic and exact arithmetic for an explicit score-563 witness. |

## Main result

The E7 Bell inequality has 63 measurement settings and two outputs per party.

| Resources | Maximum Bell score |
|---|---:|
| Classical shared randomness without communication | 399 |
| Classical shared randomness with one communicated bit | **563** |
| Quantum correlations | **567** |

Thus the exact additive quantum advantage over one-bit classical communication is four.

“One bit” means one total communicated bit, not one bit in each direction. The bound also permits shared randomness to choose the communication direction before the questions.

## Proof approach

The Bell matrix is a Gram matrix of positive E7 roots.

Every deterministic one-bit protocol reduces to an optimization over two points of a root zonotope. That zonotope is the convex hull of a reflection-group orbit. Applying the same symmetry to both points reduces the optimization to one orbit.

The remaining objective is

\[
f(\lambda)
=
\sum_{\alpha>0}
\max\left\{
\operatorname{ht}(\alpha),
|\alpha^T\lambda|
\right\}.
\]

The accompanying exact computation checked:

- **2,903,040** weights.
- **20,321,280** simple-reflection transitions.
- An upper bound of **563** throughout the certificate.
- An explicit protocol attaining **563**.
- All **3,969** entries of the authors’ Bell matrix, including its factor-two normalization.

Coverage follows from the certificate containing the initial weight and being closed under every generating reflection. Induction on reflection words then covers every required orbit point.

## What Lean proves

All declarations are in the `E7OneBit` namespace.

| Declaration | Proved statement |
|---|---|
| `closed_certificate_covers` | A set containing the initial element and closed under every transition contains every reachable element. |
| `certificate_gives_upper_bound` | A pointwise score bound on that closed set bounds every reachable element. |
| `root_count` | The explicit positive-root list contains 63 entries. |
| `height_sum` | The sum of the listed root heights is 399. |
| `maximizing_score` | The weight `(7, 5, -16, 12, -7, 8, 5)` has score 563. |
| `quantum_gap` | `567 - 563 = 4`. |

The general coverage theorem explicitly assumes seed membership, transition closure, and the pointwise bound. The separate finite computation discharges those conditions for the E7 certificate.

## Check the Lean file

Tested with **Lean 4.19.0**.

The file imports only `Std`; Mathlib is unnecessary.

With Lean 4.19.0 available, run:

```sh
lean E7OneBit.lean
```

Successful verification prints:

```text
'E7OneBit.closed_certificate_covers' does not depend on any axioms
'E7OneBit.certificate_gives_upper_bound' does not depend on any axioms
'E7OneBit.maximizing_score' does not depend on any axioms
```

No `sorry`, custom axioms, or `native_decide` are used.

## Verification scope

The PDF presents the computer-assisted mathematical proof. The Lean file formalizes the coverage implication and explicit witness arithmetic.

The convex-geometric reduction, identification with the published matrix, and complete orbit enumeration are not formalized in Lean.

This repository contains the PDF and Lean file only. The binary orbit certificate and enumeration verifiers are separate computational artifacts; reproducing the exhaustive computation requires those additional files.

## Published problem

István Márton, Erika Bene, Péter Diviánszky, and Tamás Vértesi.

**Beating one bit of communication with and without quantum pseudo-telepathy.**

*npj Quantum Information* **10**, 79 (2024).

The E7 value 563 is conjectured to be optimal in the discussion of Platonic inequalities, pages 7–8 and Figure 2.

