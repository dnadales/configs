# Review PR

Review pull request $ARGUMENTS.

## Important: delivery style

Follow these rules throughout the review:

1. **Incremental**: Present one step at a time. After each step, **stop
   and wait for the user** before continuing. Never present more than one
   step or one checklist section in a single response.
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

Present a short summary of **what** the PR does and **why**. Then **stop
and wait**.

## Step 2: Big picture

Explain how the changes fit into the larger system. This is the
architectural view:

- Which components or modules are touched?
- How do they relate to each other?
- What is the high-level shape of the change (new feature, refactor, bug
  fix, plumbing, etc.)?

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

Go through the checklist **one section at a time**. For each section:

- Present your findings for that section only. For each finding, report
  one of:
  - **No issues** — briefly say why it looks good.
  - **Concern** — describe the issue, reference the specific file and
    line in the diff, and suggest a concrete fix or improvement.
  - **Not applicable** — the section doesn't apply to this change. Keep
    it to one line.
- Use code examples to illustrate concerns when possible.
- Then **stop and wait** before moving to the next section.

## Step 6: Summary

After all steps are done (or the user asks for a summary), provide:

- A short verdict: does this PR look good to merge, or are there things
  to address?
- Blocking concerns vs. minor suggestions, listed separately.
- Suggestions for follow-up work (out of scope for this PR but worth
  noting), if any.
