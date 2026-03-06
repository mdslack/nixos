# Dendritic Migration Plan

This document tracks the implementation path from the current transitional
layout to the final dendritic architecture.

## Scope

- Migrate to a concern-first, dendritic module graph with `flake-parts`.
- Keep a working/evaluable flake at all times during migration.
- Do not preserve deprecated structure compatibility while migrating.
- Eliminate duplicate source-of-truth between legacy and target paths.
- Integrate Home Manager from the beginning of the new spine.

## Target Architecture (Canonical)

- `modules/flake/*` is the composition spine.
- `modules/features/*` contains reusable concerns.
  - A single feature file may define multiple classes (`nixos`, `homeManager`,
    later optional `darwin`).
- `modules/bundles/*` contains collector/composition modules.
- `modules/users/*` is a first-class domain for identity/user-scoped
  composition.
- `modules/hosts/*` defines host leaves and mode leaves.
- `flake.nixosConfigurations` is generated from host leaves.
- Deprecated code is quarantined under top-level `deprecated/` until final
  deletion.

## Concrete Contracts

- **Leaf naming**:
  - Host leaves are keyed as `flake.modules.nixos."hosts/<host>/<mode>"`.
  - Output names are generated as `<host>-<mode>`.
  - `<host>` and `<mode>` must be kebab-case; no additional path depth.
  - `/` separators are preferred in leaf keys for readability and selector
    logic.
- **Users via bundles**:
  - Host leaves import bundles.
  - Bundles import user modules (`modules/users/*`) as needed.
  - Host leaves do not embed ad hoc user definitions.
- **Facter pattern**:
  - Follow drupol-style host-local fact reports.
  - Store host reports under `modules/hosts/<host>/facter.json`.
  - Host leaf sets `facter.reportPath = ./facter.json`.
- **Deprecated movement rule**:
  - Move a legacy file to `deprecated/` immediately after its replacement is
    implemented and used by new leaves.
  - Do not keep active logic in both legacy and target paths.
- **State version ownership**:
  - Define `system.stateVersion` and `home.stateVersion` from one canonical
    metadata location in `modules/flake/meta.nix`.
  - Features must consume those values; they must not redefine state versions ad
    hoc.

## Secrets Plan (Doppler)

- Secrets are managed as a dedicated top-level domain: `modules/secrets/*`.
- Doppler integration is implemented as a secrets provider module (for example
  `modules/secrets/doppler.nix`).
- Feature modules consume secrets via standard NixOS/HM secret paths and
  options, not provider-specific shell glue.
- Provider bootstrap concerns (CLI/auth/service) belong in `modules/secrets/*`,
  not in unrelated feature modules.

Checklist:

- [ ] Add `modules/secrets/` domain.
- [ ] Add initial `modules/secrets/doppler.nix` provider module.
- [ ] Wire one minimal consumer feature to prove end-to-end secret flow.
- [ ] Document local bootstrap steps for Doppler authentication.

## Design Invariants

- Features are organized by concern, not by module class directory.
- Host-specific logic lives in host leaves, not reusable features.
- User identity and per-user composition live in `modules/users/*`.
- Users are selected through bundle composition (host leaves select bundles;
  bundles include user modules).
- Dotfiles/HM concerns are feature-owned and co-located by concern.
- Home Manager aspects are added from the first migration phase and expanded
  incrementally.
- Package source boundaries remain explicit:
  - baseline stable nixpkgs
  - explicit opt-in unstable usage
  - dedicated DMS flake input

## Mapping Legacy -> Target

- `nix/modules/*` -> `modules/features/*`
- `nix/profiles/*` -> `modules/bundles/*`
- host mode matrix in `nix/flake-modules/nixos-configs.nix` -> `modules/hosts/*`
  leaves + builder in `modules/flake/builders/*`
- host-local reusable identity bits -> `modules/users/*`
- deprecated legacy trees -> `deprecated/*` (temporary quarantine)
- host machine data remains under `hosts/*/hardware-configuration.nix`

## Migration Checklist

Status keys: `[ ]` not started, `[-]` in progress, `[x]` complete.

### Phase 0: Bootstrap New Flake Spine

- [x] Replace existing flake wiring with a minimal dendritic `flake.nix`.
- [x] Follow drupol-style module loading with `import-tree`.
- [x] Add Home Manager input and baseline wiring from the beginning.
- [x] Add facter capability (`nixos-facter-modules`) to the spine.
- [x] Keep the new flake evaluable from day one.

Acceptance:

- [x] `nix flake show --no-write-lock-file` succeeds using the new spine.
- [x] `flake.nixosConfigurations` is produced by new modules (minimal
      placeholder allowed).
- [x] At least one feature includes both `nixos` and `homeManager` aspects.

### Phase 1: Composition Spine Expansion

- [x] Create `modules/flake/flake-parts.nix`.
- [x] Create `modules/flake/nixpkgs.nix` with stable baseline and explicit
      unstable handle.
- [x] Create `modules/flake/meta.nix` for canonical shared constants (including
      state versions).
- [x] Create `modules/flake/builders/nixos-configurations.nix`.
- [ ] (Optional) Create `modules/flake/builders/lib.nix`.
- [x] Add module import policy (`import-tree`) and naming conventions.

Acceptance:

- [x] `nix flake show --no-write-lock-file` succeeds.
- [x] Builder contract is in place for host leaves.

### Phase 2: Feature Relocation (Concern-first)

- [x] Relocate reusable concerns from legacy modules into `modules/features/*`.
- [x] Remove class-directory split assumptions (`features/nixos/*` is not target
      design).
- [x] Co-locate `nixos` and `homeManager` aspects in the same feature file where
      appropriate.
- [x] For complex HM features (for example Neovim), land minimal working HM
      baseline first.

Acceptance:

- [x] Representative host/mode dry-runs show no behavior drift.
- [x] No concern remains authoritative in both legacy and target paths.

### Phase 3: Bundle Relocation

- [x] Relocate profile/collector composition into `modules/bundles/*`.
- [x] Ensure bundles describe intent cleanly (`minimal`, `gnome`, `hyprland`,
      etc.).
- [x] Integrate users via bundles (`bundle -> user module imports`).

Acceptance:

- [x] Host leaves can consume bundles/features directly from target paths.
- [x] User selection is expressed through bundle composition.

### Phase 4: Users Domain Extraction

- [-] Introduce `modules/users/*` and move user identity/composition there.
- [x] Keep users separate from feature and bundle domains.
- [-] Define per-user HM feature selection in user modules.

Acceptance:

- [-] User concerns are no longer scattered across host files.
- [x] User policy is reusable across host leaves.

### Phase 5: Host Leaves

- [x] Define per-host leaf modules under `modules/hosts/<host>/default.nix`.
- [x] Leaves select bundles (+ optional host-only overrides); user inclusion
      comes via bundles.
- [x] Keep hardware config in `hosts/<host>/hardware-configuration.nix`.
- [x] Keep host fact report in `modules/hosts/<host>/facter.json`.

Acceptance:

- [x] All expected `<host>-<mode>` outputs evaluate from host leaves.

### Phase 6: Builder Cutover

- [x] Switch `flake.nixosConfigurations` generation to host-leaf builder.
- [x] Remove legacy matrix builder and compatibility glue.

Acceptance:

- [x] `nix flake show --no-write-lock-file` passes.
- [x] Representative `nix eval` checks pass for both hosts.

### Phase 7: Cleanup

- [x] Move replaced legacy files into `deprecated/` as each replacement lands.
- [-] Remove superseded legacy trees and stale references.
- [ ] Empty or remove `deprecated/` once confidence is reached.

Acceptance:

- [-] No stale profile-centric or host-centric legacy wiring remains.

## Home Manager and Dotfiles Plan

- HM is integrated as a class within feature files, not as a separate
  architecture.
- HM is present from the initial spine and grows feature-by-feature.
- Dotfiles move into repository-managed assets (for example
  `files/home/<user>/...`).
- Prefer declarative HM options (`programs.*`) first; use `home.file` /
  `xdg.configFile` for raw files.
- User modules own selection of HM features per user.
- User modules are included through bundle composition.
- Complex HM domains may start with a minimal baseline and evolve in later
  iterations.
- Dotfiles can be migrated case-by-case; each concern chooses declarative HM
  options first, file links second.

## Hard Constraints

- No hidden unstable package consumption in shared base features.
- No host-specific assumptions in reusable feature modules.
- No duplicate definitions for the same concern.
- No migration step that breaks evaluability.
- No new legacy-path additions while migration is active.
- Do not reintroduce compatibility glue for deprecated structure.

## Validation Commands

```bash
nix flake show --no-write-lock-file
nix eval --no-write-lock-file --json .#nixosConfigurations --apply builtins.attrNames
sudo nixos-rebuild dry-run --flake .#framework13-minimal
```

## Tiny CI Eval Gate

- Keep CI intentionally small and reproducible.
- CI should run only pure evaluation checks:
  - `nix flake show --no-write-lock-file`
  - `nix eval --no-write-lock-file --json .#nixosConfigurations --apply builtins.attrNames`
- No activation/build steps in CI gate.

Checklist:

- [x] Add `.github/workflows/eval.yml`.
- [x] Ensure the workflow runs on push and pull requests.

## Progress Tracking Notes

- Keep this file updated when a phase meaningfully advances.
- Record major structural decisions here when they affect later phases.
- Keep `README.md` final-state only; keep all transition mechanics here.
- Dev tooling is now modeled as composable flake dev shells under
  `modules/devshells/*` instead of always-on system packages.
