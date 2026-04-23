# Review PR

Review pull request $ARGUMENTS.

## Important: delivery style

Follow these rules throughout the review:

1. **Incremental at the step level**: Present one step at a time. After
   each step, **stop and wait for the user** before continuing. Within
   Step 5, interactivity depends on the section — see Step 5.
2. **Top-down**: Start with the big picture and progressively dig into
   lower-level details. The user should be able to build a mental model
   from the top down.
3. **Visual**: Use diagrams (ASCII, Mermaid, or similar) to illustrate
   component relationships, data flow, or architecture whenever it aids
   understanding.
4. **Concrete**: Use code examples, before/after snippets, or
   hypothetical scenarios to make points tangible. Don't just say "this
   could be a problem" — show it.
5. **Steerable**: The user may ask you to skip ahead, go deeper, change
   focus, or ask questions at any point. Follow their lead.

## Step 1: Context

Fetch the PR metadata and understand the context:

- Run `gh pr view $ARGUMENTS` to get the title, description, author, and
  linked issues.
- If the description references issues, fetch them with `gh issue view`
  to understand the motivation.
- **Check for related/sibling PRs**: scan the PR body for cross-referenced
  PR numbers (e.g., "tests live in #1977", "paired with #1966"). These are
  common for "implementation + tests" or "feature + integration" splits.
  Fetch their metadata too — reviewing a PR without its sibling tends to
  surface phantom concerns that the other PR already addresses.

Present a short summary of **what** the PR does and **why**, and note any
sibling-PR relationships. Then **stop and wait**.

## Step 2: Big picture

Explain how the changes fit into the larger system. This is the
architectural view:

- Which components or modules are touched?
- How do they relate to each other?
- What is the high-level shape of the change (new feature, refactor, bug
  fix, plumbing, etc.)?
- If there's a sibling PR, note which concerns it covers.

Draw a diagram showing the affected components and their relationships.
If the change alters data flow or control flow, illustrate that too.

Then **stop and wait**.

## Step 3: File-level overview

Fetch the diff with `gh pr diff $ARGUMENTS`.

Present a list of changed files grouped by logical concern (not just
alphabetically). For each group, give a one-line summary of the role of
that group in the overall change. Do not go into code-level detail yet.

Then **stop and wait**. The user may say things like "focus on group X",
"skip the test files", or "go ahead".

## Step 4: Detailed walkthrough

Go deeper into each logical group of changes identified in step 3. For
each group:

- Read relevant parts of the surrounding codebase to understand context.
- Explain what changed and why, using before/after code snippets or
  examples where helpful.
- Highlight non-obvious design decisions or trade-offs.

Present **one group at a time**, then **stop and wait**.

## Step 5: Evaluate against the checklist

Read the review checklist. Look for a project-specific checklist first at
`.claude/review-checklist.md` in the current project. If none exists, use
the generic one at `~/.claude/review-checklist.md`.

The checklist runs in two passes:

### Step 5a: Interactive sections

Go through **Correctness**, **Design**, and **Security** one at a time,
stopping and waiting after each. These sections benefit from dialogue:
trade-offs, threat models, and architectural judgment often need context
that cannot be guessed.

For each section, report findings as:
- **No issues** — brief one-liner.
- **Concern** — describe the issue, reference file:line in the diff,
  suggest a concrete fix.
- **Not applicable** — one line.

Use code examples to illustrate concerns.

### Step 5b: Autonomous analysis bundle

Analyze **Testing**, **Readability**, **Performance**, **Documentation**,
and **Backwards compatibility** without stopping. Report findings only;
do not walk through sections with nothing to report. A section with no
findings can be omitted entirely or represented by a one-line "No
issues".

End the bundle with a single **stop and wait** prompt so the user can
steer into Step 6 or ask for deeper investigation on any finding.

## Step 6: Comment triage

Ask the user whether to triage the findings into PR comments.

If yes, group findings into severity tiers:
- **Blocking-adjacent** — should be resolved before merge or tracked as
  explicit follow-up (correctness bugs, security issues, consensus risks).
- **Substantive but non-blocking** — real issues worth fixing but don't
  block merge (dead code, API shape improvements, defer-able refactors).
- **Style / polish** — cosmetic and consistency items.
- **Observation** — worth noting but not necessarily actionable.

Walk through items **one at a time** in severity order. For each:
- Show the concern, location, relevant code snippet.
- Ask whether to draft a PR comment. The user may skip, rephrase, or
  ask for deeper analysis.
- If yes, draft the comment and post it via GraphQL (see below).

### Posting inline comments to a pending review

Check whether the user has an existing pending review:
```
gh api repos/$OWNER/$REPO/pulls/$PR/reviews --jq \
  '.[] | select(.user.login == "$USER") | {id, node_id, state}'
```

**If a pending review exists**, use the GraphQL
`addPullRequestReviewThread` mutation with the review's `node_id`. The
REST `POST /pulls/$PR/comments` endpoint fails with 422 in this case
("user_id can only have one pending review").

**If no pending review**, offer to create one with the drafted comment
as its first entry (REST `POST /pulls/$PR/reviews` with `event: null`).

Inline comments only anchor on lines that are part of the diff. For
concerns about unchanged files (class-level abstractions, etc.), post
the comment on the closest diff-line and reference the unchanged file
in the comment body.

## Step 7: Review body + verdict

Draft the text that accompanies the inline comments when the user
submits the review. This is *not* a separate artifact — it becomes the
review's summary block.

Include:
- A short verdict: does this PR look good to merge, or are there things
  to address?
- A grouped list of concerns using the severity tiers from Step 6, with
  inline-comment IDs as cross-references.
- Suggestions for follow-up work (out of scope for this PR but worth
  noting).
- Relative-to-sibling-PR context if applicable.

The user typically posts the review body themselves via the GitHub UI,
so present it as a copy-pasteable markdown block.

## Step 8 (optional): Follow-up tracking

If the review surfaced concerns that should be tracked outside the PR
(production blockers, release-gating items, cross-team work), offer to
draft a consolidated GitHub tracking issue or log to the user's notes.

Ask the user:
- File a GitHub issue now?
- Save as a draft locally (e.g., `~/psys/resources/`)?
- Skip?

If filing: use `gh issue create` with the consolidated body.
If local: write to the user's preferred notes location in the user's
preferred format (check memory for org-mode vs markdown preferences).
