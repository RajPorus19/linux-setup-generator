"""
Formate un rapport de test JSON en sortie lisible.

Usage:
    python report.py report.json              # Résumé texte
    python report.py report.json --html        # Génère report.html
    python report.py report.json --markdown    # Format markdown (pour PR comments)
"""

import argparse
import json
import sys
from pathlib import Path


def load_report(path):
    with open(path) as f:
        return json.load(f)


def format_text(report):
    """Format texte coloré pour le terminal."""
    lines = []
    lines.append("=" * 60)
    lines.append(f"📊 Test Report — {report['distro']} ({report['distro_slug']})")
    lines.append(f"   Date:     {report['timestamp']}")
    lines.append(f"   Total:    {report['total']}")
    lines.append(f"   Passed:   {report['passed']} ✅")
    lines.append(f"   Failed:   {report['failed']} ❌")
    lines.append(f"   Skipped:  {report['skipped']}")
    lines.append(f"   Duration: {report['duration_seconds']}s")

    if report["failures"]:
        lines.append(f"\n❌ Failures ({len(report['failures'])}):")
        for f in report["failures"]:
            lines.append(f"   [{f['install_method']}] {f['name']}")
            lines.append(f"       Error: {f['error_message']}")
            if f.get("attempted_command"):
                lines.append(f"       Cmd:   {f['attempted_command']}")
    else:
        lines.append("\n✅ All programs passed!")

    return "\n".join(lines)


def format_markdown(report):
    """Format markdown pour commentaires GitHub PR."""
    lines = []
    lines.append(f"## 🧪 Test Results — {report['distro']} (`{report['distro_slug']}`)")
    lines.append("")
    lines.append(f"| Metric | Value |")
    lines.append(f"|--------|-------|")
    lines.append(f"| Total | {report['total']} |")
    lines.append(f"| Passed | {report['passed']} ✅ |")
    lines.append(f"| Failed | {report['failed']} ❌ |")
    lines.append(f"| Skipped | {report['skipped']} |")
    lines.append(f"| Duration | {report['duration_seconds']}s |")

    if report["failures"]:
        lines.append("")
        lines.append("### ❌ Failures")
        lines.append("")
        lines.append("| Program | Method | Error | Suggested Command |")
        lines.append("|---------|--------|-------|-------------------|")
        for f in report["failures"]:
            error = f["error_message"].replace("|", "\\|")[:80]
            cmd = f.get("attempted_command", "").replace("|", "\\|")[:60]
            lines.append(
                f"| {f['name']} | {f['install_method']} | {error} | `{cmd}` |"
            )
    else:
        lines.append("")
        lines.append("✅ **All programs passed!**")

    lines.append("")
    lines.append(f"_Report generated at {report['timestamp']}_")
    return "\n".join(lines)


def format_html(report):
    """Génère une page HTML autonome avec le rapport."""
    passed_pct = (
        round(report["passed"] / report["total"] * 100, 1) if report["total"] else 0
    )
    bar_color = "#22c55e" if passed_pct > 90 else "#f59e0b" if passed_pct > 70 else "#ef4444"

    failures_html = ""
    if report["failures"]:
        rows = []
        for f in report["failures"]:
            rows.append(
                f"<tr>"
                f"<td>{f['name']}</td>"
                f"<td><code>{f['install_method']}</code></td>"
                f"<td>{f['error_message'][:100]}</td>"
                f"<td><code>{f.get('attempted_command', '')[:80]}</code></td>"
                f"</tr>"
            )
        failures_html = f"""
        <h2>❌ Failures ({len(report['failures'])})</h2>
        <table>
            <thead><tr><th>Program</th><th>Method</th><th>Error</th><th>Command</th></tr></thead>
            <tbody>{"".join(rows)}</tbody>
        </table>
        """

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Test Report — {report['distro']}</title>
    <style>
        body {{ font-family: system-ui, sans-serif; max-width: 900px; margin: 2rem auto; padding: 0 1rem; color: #1a1a2e; background: #fafafa; }}
        h1 {{ margin-bottom: 0; }}
        .subtitle {{ color: #6b7280; margin-top: 0.25rem; }}
        .summary {{ display: flex; gap: 2rem; margin: 2rem 0; flex-wrap: wrap; }}
        .stat {{ background: white; border-radius: 12px; padding: 1.25rem 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,.1); min-width: 120px; }}
        .stat-value {{ font-size: 2rem; font-weight: 800; }}
        .stat-label {{ color: #6b7280; font-size: 0.85rem; }}
        .bar-container {{ margin: 1rem 0 2rem; background: #e5e7eb; border-radius: 8px; height: 12px; overflow: hidden; }}
        .bar {{ height: 100%; background: {bar_color}; border-radius: 8px; transition: width .3s; }}
        table {{ width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,.1); }}
        th {{ background: #1a1a2e; color: white; padding: 0.75rem 1rem; text-align: left; }}
        td {{ padding: 0.75rem 1rem; border-bottom: 1px solid #f3f4f6; }}
        tr:last-child td {{ border-bottom: none; }}
        code {{ background: #f3f4f6; padding: 0.15rem 0.4rem; border-radius: 4px; font-size: 0.85rem; }}
    </style>
</head>
<body>
    <h1>🧪 Test Report — {report['distro']}</h1>
    <p class="subtitle">{report['timestamp']} · {report['distro_slug']} · {report['duration_seconds']}s</p>

    <div class="summary">
        <div class="stat"><div class="stat-value">{report['total']}</div><div class="stat-label">Total</div></div>
        <div class="stat"><div class="stat-value" style="color:#22c55e">{report['passed']}</div><div class="stat-label">Passed ✅</div></div>
        <div class="stat"><div class="stat-value" style="color:#ef4444">{report['failed']}</div><div class="stat-label">Failed ❌</div></div>
        <div class="stat"><div class="stat-value">{passed_pct}%</div><div class="stat-label">Success rate</div></div>
    </div>

    <div class="bar-container"><div class="bar" style="width:{passed_pct}%"></div></div>

    {failures_html}
</body>
</html>"""


def main():
    parser = argparse.ArgumentParser(description="Formate un rapport de test")
    parser.add_argument("report", help="Fichier report.json")
    parser.add_argument("--html", action="store_true", help="Génère un fichier HTML")
    parser.add_argument("--markdown", action="store_true", help="Format markdown")
    parser.add_argument("--output", "-o", help="Fichier de sortie (défaut: stdout)")
    args = parser.parse_args()

    report = load_report(args.report)

    if args.markdown:
        output = format_markdown(report)
    elif args.html:
        output = format_html(report)
        out_path = args.output or args.report.replace(".json", ".html")
        Path(out_path).write_text(output)
        print(f"HTML report written to {out_path}")
        return
    else:
        output = format_text(report)

    if args.output:
        Path(args.output).write_text(output)
    else:
        print(output)


if __name__ == "__main__":
    main()
