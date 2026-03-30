# Review Checklist

This checklist defines the criteria for reviewing a pull request. Each
section describes an area of concern. Evaluate every section against the
PR's changes and report your findings.

## Correctness

- Does the code do what the PR description claims?
- Are there logic errors, off-by-one mistakes, or wrong assumptions?
- Are edge cases handled?

## Design

- Is the approach a reasonable way to solve the problem?
- Does it fit the existing architecture, or does it introduce unnecessary
  divergence?
- Are there simpler alternatives that achieve the same goal?

## Testing

- Are new or changed code paths covered by tests?
- Do the tests actually assert meaningful behavior (not just that the code
  runs)?
- Are failure/error paths tested?

## Readability

- Is the code clear without excessive comments?
- Are names (functions, variables, types) descriptive and consistent with
  the codebase?
- Is the change easy to follow as a diff?

## Performance

- Are there obvious inefficiencies (unnecessary allocations, quadratic
  loops, repeated work)?
- Could the change degrade performance under realistic workloads?

## Security

- Does the change introduce any potential vulnerability (injection,
  improper input validation, credential exposure)?
- Are trust boundaries respected?

## Documentation

- If the change affects public API or user-facing behavior, is it
  documented?
- Are non-obvious decisions explained in code comments or the PR
  description?

## Backwards compatibility

- Does the change break existing interfaces, formats, or behavior?
- If it does, is the breakage intentional and communicated?
