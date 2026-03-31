<?php
$lang = isset($_GET['lang']) ? $_GET['lang'] : null;
if (!$lang) {
    $browser_lang = substr($_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? 'en', 0, 2);
    $supported_langs = ['tr', 'de', 'en'];
    $lang = in_array($browser_lang, $supported_langs) ? $browser_lang : 'en';
}
$appName = "Introduction";
$content = [
    'tr' => [
        'title' => 'Gizlilik Politikası - ' . $appName, 'home' => 'Anasayfa', 'effective_date' => 'Yürürlük Tarihi',
        'intro_title' => 'Giriş', 'intro_text' => '41Software olarak gizliliğinize önem veriyoruz.',
        'collect_title' => 'Toplanan Veriler', 'points' => '<h3>Privacy Policy - Hourglass Timer Feature</h3>
<h3>Introduction</h3>
<li>This privacy policy specifically covers the Hourglass Timer feature within the My Pets application. We are committed to protecting your privacy and being transparent about how this feature operates.</li>
<h3>Data Collection</h3>
<li>The Hourglass Timer feature:</li>
<li><strong>Does NOT collect any personal data</strong></li>
<li><strong>Does NOT send any information to external servers</strong></li>
<li><strong>Does NOT track your usage patterns</strong></li>
<li><strong>Does NOT access your device\'s microphone, camera, or location</strong></li>
<h3>Local Storage</h3>
<li>The Hourglass Timer feature may store the following information locally on your device:</li>
<li>Timer duration preferences</li>
<li>Last used timer settings</li>
<li>Sound/vibration preferences</li>
<li>This information:</li>
<li>Never leaves your device</li>
<li>Is not shared with third parties</li>
<li>Can be cleared by uninstalling the app</li>
<h3>Permissions</h3>
<li>The Hourglass Timer feature may request the following permissions:</li>
<li><strong>Vibration</strong>: To provide haptic feedback when the timer completes</li>
<li><strong>Audio</strong>: To play system sounds for timer notifications (uses built-in system sounds only)</li>
<h3>Third-Party Services</h3>
<li>The Hourglass Timer feature does not integrate with any third-party services or analytics platforms beyond those already disclosed in the main app privacy policy.</li>
<h3>Data Security</h3>
<li>Since no data is transmitted or stored externally, your timer usage remains completely private and secure on your device.</li>
<h3>Changes to This Policy</h3>
<li>Any changes to this privacy policy will be reflected in app updates and communicated through the app\'s update notes.</li>
<h3>Contact Information</h3>
<li>For questions about this privacy policy or the Hourglass Timer feature, please contact us at:</li>
<li>Email: support@mypetsapp.com</li>
<li>Website: https://mypetsapp.com/privacy</li>
<h3>Effective Date</h3>
<li>This privacy policy is effective as of September 19, 2025.</li>
<li>*This privacy policy is specific to the Hourglass Timer feature. Please refer to the main application privacy policy for information about other app features.*</li>',
        'security_title' => 'Güvenlik', 'security_text' => 'Verileriniz cihazınızda yerel olarak saklanır.',
        'contact_title' => 'İletişim', 'contact_text' => 'Sorularınız için bizimle iletişime geçebilirsiniz.', 'last_updated' => 'Son Güncelleme:'
    ],
    'en' => [
        'title' => 'Privacy Policy - ' . $appName, 'home' => 'Home', 'effective_date' => 'Effective Date',
        'intro_title' => 'Introduction', 'intro_text' => 'At 41Software, we value your privacy.',
        'collect_title' => 'Information Collected', 'points' => '<h3>Privacy Policy - Hourglass Timer Feature</h3>
<h3>Introduction</h3>
<li>This privacy policy specifically covers the Hourglass Timer feature within the My Pets application. We are committed to protecting your privacy and being transparent about how this feature operates.</li>
<h3>Data Collection</h3>
<li>The Hourglass Timer feature:</li>
<li><strong>Does NOT collect any personal data</strong></li>
<li><strong>Does NOT send any information to external servers</strong></li>
<li><strong>Does NOT track your usage patterns</strong></li>
<li><strong>Does NOT access your device\'s microphone, camera, or location</strong></li>
<h3>Local Storage</h3>
<li>The Hourglass Timer feature may store the following information locally on your device:</li>
<li>Timer duration preferences</li>
<li>Last used timer settings</li>
<li>Sound/vibration preferences</li>
<li>This information:</li>
<li>Never leaves your device</li>
<li>Is not shared with third parties</li>
<li>Can be cleared by uninstalling the app</li>
<h3>Permissions</h3>
<li>The Hourglass Timer feature may request the following permissions:</li>
<li><strong>Vibration</strong>: To provide haptic feedback when the timer completes</li>
<li><strong>Audio</strong>: To play system sounds for timer notifications (uses built-in system sounds only)</li>
<h3>Third-Party Services</h3>
<li>The Hourglass Timer feature does not integrate with any third-party services or analytics platforms beyond those already disclosed in the main app privacy policy.</li>
<h3>Data Security</h3>
<li>Since no data is transmitted or stored externally, your timer usage remains completely private and secure on your device.</li>
<h3>Changes to This Policy</h3>
<li>Any changes to this privacy policy will be reflected in app updates and communicated through the app\'s update notes.</li>
<h3>Contact Information</h3>
<li>For questions about this privacy policy or the Hourglass Timer feature, please contact us at:</li>
<li>Email: support@mypetsapp.com</li>
<li>Website: https://mypetsapp.com/privacy</li>
<h3>Effective Date</h3>
<li>This privacy policy is effective as of September 19, 2025.</li>
<li>*This privacy policy is specific to the Hourglass Timer feature. Please refer to the main application privacy policy for information about other app features.*</li>',
        'security_title' => 'Security', 'security_text' => 'Your data is stored locally on your device.',
        'contact_title' => 'Contact Us', 'contact_text' => 'For questions and support regarding our privacy policy.', 'last_updated' => 'Last Updated:'
    ],
    'de' => [
        'title' => 'Datenschutzerklärung - ' . $appName, 'home' => 'Startseite', 'effective_date' => 'Gültig ab',
        'intro_title' => 'Einführung', 'intro_text' => 'Bei 41Software legen wir Wert auf Ihre Privatsphäre.',
        'collect_title' => 'Gesammelte Daten', 'points' => '<h3>Privacy Policy - Hourglass Timer Feature</h3>
<h3>Introduction</h3>
<li>This privacy policy specifically covers the Hourglass Timer feature within the My Pets application. We are committed to protecting your privacy and being transparent about how this feature operates.</li>
<h3>Data Collection</h3>
<li>The Hourglass Timer feature:</li>
<li><strong>Does NOT collect any personal data</strong></li>
<li><strong>Does NOT send any information to external servers</strong></li>
<li><strong>Does NOT track your usage patterns</strong></li>
<li><strong>Does NOT access your device\'s microphone, camera, or location</strong></li>
<h3>Local Storage</h3>
<li>The Hourglass Timer feature may store the following information locally on your device:</li>
<li>Timer duration preferences</li>
<li>Last used timer settings</li>
<li>Sound/vibration preferences</li>
<li>This information:</li>
<li>Never leaves your device</li>
<li>Is not shared with third parties</li>
<li>Can be cleared by uninstalling the app</li>
<h3>Permissions</h3>
<li>The Hourglass Timer feature may request the following permissions:</li>
<li><strong>Vibration</strong>: To provide haptic feedback when the timer completes</li>
<li><strong>Audio</strong>: To play system sounds for timer notifications (uses built-in system sounds only)</li>
<h3>Third-Party Services</h3>
<li>The Hourglass Timer feature does not integrate with any third-party services or analytics platforms beyond those already disclosed in the main app privacy policy.</li>
<h3>Data Security</h3>
<li>Since no data is transmitted or stored externally, your timer usage remains completely private and secure on your device.</li>
<h3>Changes to This Policy</h3>
<li>Any changes to this privacy policy will be reflected in app updates and communicated through the app\'s update notes.</li>
<h3>Contact Information</h3>
<li>For questions about this privacy policy or the Hourglass Timer feature, please contact us at:</li>
<li>Email: support@mypetsapp.com</li>
<li>Website: https://mypetsapp.com/privacy</li>
<h3>Effective Date</h3>
<li>This privacy policy is effective as of September 19, 2025.</li>
<li>*This privacy policy is specific to the Hourglass Timer feature. Please refer to the main application privacy policy for information about other app features.*</li>',
        'security_title' => 'Sicherheit', 'security_text' => 'Ihre Daten werden lokal auf Ihrem Gerät gespeichert.',
        'contact_title' => 'Kontakt', 'contact_text' => 'Bei Fragen wenden Sie sich bitte an uns.', 'last_updated' => 'Aktualisiert am:'
    ]
];
$c = $content[$lang];
?>
<!DOCTYPE html>
<html lang="<?php echo $lang; ?>">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $c['title']; ?></title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; line-height: 1.6; padding: 20px; background: #f4f7f9; color: #333; }
        .container { max-width: 850px; margin: auto; background: #fff; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); }
        h1 { color: #1e3a8a; border-bottom: 3px solid #3b82f6; padding-bottom: 10px; }
        h2 { color: #1e40af; margin-top: 30px; border-left: 5px solid #3b82f6; padding-left: 15px; }
        h3 { color: #374151; background: #f3f4f6; padding: 10px; border-radius: 5px; }
        .nav-buttons { display: flex; justify-content: center; gap: 10px; margin: 20px 0; flex-wrap: wrap; }
        .btn { display: inline-block; padding: 12px 24px; text-decoration: none; background: #3b82f6; color: white; border-radius: 8px; font-weight: bold; transition: 0.3s; }
        .btn:hover { background: #1d4ed8; transform: translateY(-2px); }
        .lang-switch { text-align: right; margin-bottom: 15px; }
        .btn-lang { padding: 6px 15px; background: #fff; border: 1px solid #ddd; font-size: 0.8em; }
        .btn-lang.active { background: #3b82f6; color: #fff; }
        ul { list-style-type: none; padding: 0; }
        li { margin-bottom: 12px; padding-left: 30px; position: relative; }
        li::before { content: "🔹"; position: absolute; left: 0; }
        hr { margin: 40px 0; border: 0; border-top: 1px solid #eee; }
    </style>
</head>
<body>
<div class="lang-switch">
    <a href="?lang=tr" class="btn btn-lang <?php echo $lang=='tr'?'active':''; ?>">TR</a>
    <a href="?lang=de" class="btn btn-lang <?php echo $lang=='de'?'active':''; ?>">DE</a>
    <a href="?lang=en" class="btn btn-lang <?php echo $lang=='en'?'active':''; ?>">EN</a>
</div>
<div class="container">
    <div class="nav-buttons">
        <a href="https://www.41software.com" class="btn"><?php echo $c['home']; ?> (TR)</a>
        <a href="https://www.41software.com" class="btn"><?php echo $c['home']; ?> (DE)</a>
        <a href="https://www.41software.com" class="btn"><?php echo $c['home']; ?> (EN)</a>
    </div>
    <h1><?php echo $c['title']; ?></h1>
    <p><strong><?php echo $c['effective_date']; ?>:</strong> <?php echo date('d.m.Y'); ?></p>
    <h2><?php echo $c['intro_title']; ?></h2><p><?php echo $c['intro_text']; ?></p>
    <h2><?php echo $c['collect_title']; ?></h2><div class="policy-content"><ul><?php echo $c['points']; ?></ul></div>
    <h2><?php echo $c['security_title']; ?></h2><p><?php echo $c['security_text']; ?></p>
    <h2><?php echo $c['contact_title']; ?></h2><p><?php echo $c['contact_text']; ?></p>
    <p><strong>41Software</strong><br><a href="https://www.41software.com">www.41software.com</a><br>Email: info@41software.com</p>
    <div class="nav-buttons">
        <a href="https://www.41software.com" class="btn"><?php echo $c['home']; ?> (TR)</a>
        <a href="https://www.41software.com" class="btn"><?php echo $c['home']; ?> (DE)</a>
        <a href="https://www.41software.com" class="btn"><?php echo $c['home']; ?> (EN)</a>
    </div>
    <hr><div class="footer-info"><p>&copy; <?php echo date('Y'); ?> 41Software</p></div>
</div>
</body>
</html>