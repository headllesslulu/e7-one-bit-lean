import Std

/-! Exact arithmetic and the orbit-coverage logic used by the E7 certificate.
The 2,903,040-point certificate is checked by verify_orbit.cpp, not Lean.
The general closure theorem explicitly requires its seed, closure, and bound
hypotheses; these are the checks performed by that separate verifier.
The convex-geometric reduction is proved in Proof.tex. -/

namespace E7OneBit

inductive Reachable {α : Type} {ι : Type} (step : α → ι → α) (seed : α) : α → Prop
  | initial : Reachable step seed seed
  | next {x : α} : Reachable step seed x → (i : ι) → Reachable step seed (step x i)

theorem closed_certificate_covers
    {α ι : Type} (step : α → ι → α) (seed : α) (S : α → Prop)
    (hseed : S seed) (hclosed : ∀ x, S x → ∀ i, S (step x i)) :
    ∀ x, Reachable step seed x → S x := by
  intro x hx
  induction hx with
  | initial => exact hseed
  | next hx i ih => exact hclosed _ ih i

theorem certificate_gives_upper_bound
    {α ι : Type} (step : α → ι → α) (seed : α) (S : α → Prop)
    (score : α → Nat) (bound : Nat)
    (hseed : S seed) (hclosed : ∀ x, S x → ∀ i, S (step x i))
    (hbound : ∀ x, S x → score x ≤ bound) :
    ∀ x, Reachable step seed x → score x ≤ bound := by
  intro x hx
  exact hbound x (closed_certificate_covers step seed S hseed hclosed x hx)

def positiveRoots : List (List Int) := [
  [0, 0, 0, 0, 0, 0, 1],
  [0, 0, 0, 0, 0, 1, 0],
  [0, 0, 0, 0, 1, 0, 0],
  [0, 0, 0, 0, 1, 1, 0],
  [0, 0, 0, 1, 0, 0, 0],
  [0, 0, 0, 1, 1, 0, 0],
  [0, 0, 0, 1, 1, 1, 0],
  [0, 0, 1, 0, 0, 0, 0],
  [0, 0, 1, 0, 0, 0, 1],
  [0, 0, 1, 1, 0, 0, 0],
  [0, 0, 1, 1, 0, 0, 1],
  [0, 0, 1, 1, 1, 0, 0],
  [0, 0, 1, 1, 1, 0, 1],
  [0, 0, 1, 1, 1, 1, 0],
  [0, 0, 1, 1, 1, 1, 1],
  [0, 1, 0, 0, 0, 0, 0],
  [0, 1, 1, 0, 0, 0, 0],
  [0, 1, 1, 0, 0, 0, 1],
  [0, 1, 1, 1, 0, 0, 0],
  [0, 1, 1, 1, 0, 0, 1],
  [0, 1, 1, 1, 1, 0, 0],
  [0, 1, 1, 1, 1, 0, 1],
  [0, 1, 1, 1, 1, 1, 0],
  [0, 1, 1, 1, 1, 1, 1],
  [0, 1, 2, 1, 0, 0, 1],
  [0, 1, 2, 1, 1, 0, 1],
  [0, 1, 2, 1, 1, 1, 1],
  [0, 1, 2, 2, 1, 0, 1],
  [0, 1, 2, 2, 1, 1, 1],
  [0, 1, 2, 2, 2, 1, 1],
  [1, 0, 0, 0, 0, 0, 0],
  [1, 1, 0, 0, 0, 0, 0],
  [1, 1, 1, 0, 0, 0, 0],
  [1, 1, 1, 0, 0, 0, 1],
  [1, 1, 1, 1, 0, 0, 0],
  [1, 1, 1, 1, 0, 0, 1],
  [1, 1, 1, 1, 1, 0, 0],
  [1, 1, 1, 1, 1, 0, 1],
  [1, 1, 1, 1, 1, 1, 0],
  [1, 1, 1, 1, 1, 1, 1],
  [1, 1, 2, 1, 0, 0, 1],
  [1, 1, 2, 1, 1, 0, 1],
  [1, 1, 2, 1, 1, 1, 1],
  [1, 1, 2, 2, 1, 0, 1],
  [1, 1, 2, 2, 1, 1, 1],
  [1, 1, 2, 2, 2, 1, 1],
  [1, 2, 2, 1, 0, 0, 1],
  [1, 2, 2, 1, 1, 0, 1],
  [1, 2, 2, 1, 1, 1, 1],
  [1, 2, 2, 2, 1, 0, 1],
  [1, 2, 2, 2, 1, 1, 1],
  [1, 2, 2, 2, 2, 1, 1],
  [1, 2, 3, 2, 1, 0, 1],
  [1, 2, 3, 2, 1, 0, 2],
  [1, 2, 3, 2, 1, 1, 1],
  [1, 2, 3, 2, 1, 1, 2],
  [1, 2, 3, 2, 2, 1, 1],
  [1, 2, 3, 2, 2, 1, 2],
  [1, 2, 3, 3, 2, 1, 1],
  [1, 2, 3, 3, 2, 1, 2],
  [1, 2, 4, 3, 2, 1, 2],
  [1, 3, 4, 3, 2, 1, 2],
  [2, 3, 4, 3, 2, 1, 2]
]

def dot (a b : List Int) : Int := (List.zipWith (· * ·) a b).sum

def heights : List Nat := positiveRoots.map (fun r => r.sum.natAbs)
def maximizingWeight : List Int := [7, 5, -16, 12, -7, 8, 5]
def orbitScore (w : List Int) : Nat :=
  (positiveRoots.map (fun r => max r.sum.natAbs (dot r w).natAbs)).sum

theorem root_count : positiveRoots.length = 63 := by decide
theorem height_sum : heights.sum = 399 := by decide
theorem maximizing_score : orbitScore maximizingWeight = 563 := by decide
theorem quantum_gap : 567 - 563 = (4 : Nat) := by decide

#print axioms closed_certificate_covers
#print axioms certificate_gives_upper_bound
#print axioms maximizing_score
end E7OneBit
