<h2>Capture Verification 4.2.1</h2>

<h3>Fixed: sessions with non-standard folder names</h3>

<p>A session whose captures and processed files live in folders not called Capture and
Output (for example <code>01_Raw_Files</code> and <code>03_Client_Previews</code>) could
stop with &ldquo;Could not find both 'Capture' and 'Output' folders&rdquo;. The app now reads
the session's own folder assignments from the Capture One session database, so any layout
the session is configured with is recognised.</p>

<h3>New: choose the folders yourself</h3>

<p>When the folders still cannot be worked out &mdash; no session database, unusual names
and nothing processed yet &mdash; you are asked to pick the Capture folder and the Output
folder. The choice is remembered for that session, so Re-Verify and History do not ask
again. If you cancel, the welcome screen offers &ldquo;Choose Folders&hellip;&rdquo; to come
back to it.</p>

<h3>Since 4.2</h3>

<p>Variants are detected as soon as they are created in Capture One (read from the session
database instead of waiting for the sidecar files); JPG and TIFF recipes for the same shot
pass and are both counted; files found inside the Capture folder are no longer moved without
asking; backup copies of the wrong size are reported; and the report lists every decision
you made while resolving a session.</p>

<p><strong>Updating from 3.8?</strong> You will be asked to register once on first launch.
It works offline &mdash; fill the form in and carry on; the details are sent the next time
you are online. The trial expiry that 3.8 carried is gone.</p>
