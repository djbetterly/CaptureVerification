<h2>Capture Verification 4.1</h2>

<p><strong>You will be asked to register once when you first open this version.</strong>
It takes a few seconds, it happens on this machine only, and it does not require a
network connection. If you are on a closed set with no internet, fill the form in and
carry on working normally &mdash; your details are sent later, automatically, the next
time you are online.</p>

<h3>Fixed: sessions reporting every single file as missing</h3>

<p>Capture One began prepending an invisible character to the filenames it creates when
processing, which nothing displays and nothing types. Verification compared filenames
exactly, so a capture never matched its own processed output. A folder with 256 RAWs and
256 matching JPEGs was reported as 256 files missing and 256 extra files &mdash; a full
failure on a session where nothing was actually wrong.</p>

<p>Filename comparison now ignores these invisible characters, along with differences in
letter case and Unicode composition. On a real 4,376-file test session the false failures
dropped to zero, and the twelve genuinely unprocessed captures that had been buried in the
noise were correctly reported.</p>

<h3>Fixed: verifications missing from History</h3>

<p>A session was only added to History as a side effect of exporting a PDF report. If you
ran a verification and did not export a report &mdash; or the export failed &mdash; the
run was discarded. Verifications are now recorded the moment they finish, and exporting a
report updates that same entry rather than creating a second one.</p>

<h3>Fixed: Capture One variants were never detected</h3>

<p>Variant detection was broken by the same invisible-character problem, so confirmed
variants were being counted as unexpected extra files instead. Variants are now matched
and reported correctly.</p>

<h3>Fixed: unreadable characters in shoot reports</h3>

<p>Filenames printed into PDF shoot reports and shown in the results list carried those
same invisible characters through to the page. Names are now cleaned for display. The real
filename on disk is untouched, so Show in Finder, Quarantine and Rename all continue to act
on the correct file.</p>

<h3>Changed: no more trial period</h3>

<p>The trial and its expiration date are gone. Previous versions would have stopped working
on 1 January 2027 regardless of how you were using them. This version does not expire.</p>

<h3>Also in this release</h3>

<ul>
<li>The bundled Capture One script now updates itself when a new version ships, instead of
    only installing once and then never changing.</li>
<li>Scheduled update checks are configured correctly.</li>
<li>Fixed a crash that could occur if the archive folder could not be located.</li>
<li>Further fixes to export verification and Capture One scripting.</li>
</ul>
