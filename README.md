# FPGA-based Accelerator Design — Public Course Site

Static GitHub Pages site for the FPGA / HLS course (Monsoon 2026). Plain
hand-written `index.html` + `style.css`, styled to match
[sureshpurini.github.io](https://sureshpurini.github.io/).

**This repo is deliberately public and separate from the private course repo
(`fpga-monsoon26`).** Keep it that way:

> ⚠️ **Never** put the HLS Blue Book PDF, copyrighted readings, cluster internals
> (hostnames, PCIe BDFs, internal paths), solutions, or student data in this repo.
> Those live in the **private** repo and on **Moodle**. This site holds only the
> public brochure: overview, schedule, links, logistics.

## Edit

- Content: `index.html` · Styling: `style.css`
- Search for `TODO` / `todo` to find the placeholders to fill in (Moodle URL,
  meeting time/venue, office hours, TAs, credits, grading weights).
- Preview locally: `python3 -m http.server 8000` then open
  `http://localhost:8000/`.

## Deploy (first time)

```bash
# from this folder, after filling in the TODOs:
gh repo create fpga-monsoon26-web --public --source=. --remote=origin --push
# then enable Pages from the default branch root:
gh api -X POST repos/:owner/fpga-monsoon26-web/pages -f source[branch]=main -f source[path]=/ 2>/dev/null \
  || echo "Enable Pages in Settings → Pages → Branch: main / root"
```

Live at `https://sureshpurini.github.io/fpga-monsoon26-web/`. Add that URL to the
"FPGA-based Accelerator Design" card on your homepage's Teaching section.

## Update later

```bash
git add -A && git commit -m "Update schedule" && git push
```

Pages redeploys automatically on push (usually within a minute).
