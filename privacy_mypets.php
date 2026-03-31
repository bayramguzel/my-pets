<?php
$lang = isset($_GET['lang']) ? $_GET['lang'] : null;
if (!$lang) {
    $browser_lang = substr($_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? 'en', 0, 2);
    $supported_langs = ['tr', 'de', 'en'];
    $lang = in_array($browser_lang, $supported_langs) ? $browser_lang : 'en';
}
$appName = "Last Updated: January 16, 2026";
$content = [
    'tr' => [
        'title' => 'Gizlilik Politikası - ' . $appName, 'home' => 'Anasayfa', 'effective_date' => 'Yürürlük Tarihi',
        'intro_title' => 'Giriş', 'intro_text' => '41Software olarak gizliliğinize önem veriyoruz.',
        'collect_title' => 'Toplanan Veriler', 'points' => '<h3>Privacy Policy for My Pets</h3>
<li><strong>Last Updated: January 16, 2026</strong></li>
<li>Thank you for choosing <strong>My Pets</strong>. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our mobile application.</li>
<h3>1. Information Collection</h3>
<li>My Pets is designed to work primarily offline. Most of the data you enter (pet details, activities, health records, etc.) is stored locally on your device.</li>
<li><strong>Personal Data</strong>: We do not collect personal identifying information (PII) such as your name, email address, or phone number unless you explicitly provide it for feedback purposes via email.</li>
<li><strong>Microchip/ID Data</strong>: Any pet identification numbers or microchip IDs you enter are stored locally on your device and are not uploaded to our servers.</li>
<li><strong>Media</strong>: If you choose to upload a photo of your pet, it is stored locally or processed via local device storage.</li>
<h3>2. Third-Party Services</h3>
<li>We use the following third-party services which may collect data according to their own policies:</li>
<li><strong>Google AdMob</strong>: Used to display advertisements. AdMob may collect device identifiers and usage data to personalize ads.</li>
<li><strong>Microsoft Clarity</strong>: Used for usage analytics and improving user experience. It may track how you interact with the app.</li>
<h3>3. Data Storage and Security</h3>
<p>All your pet data is stored in a local database (SQLite) on your device. We do not have access to this data. If you delete the app or clear its data, this information will be permanently lost unless you have a backup.</p>
<h3>4. Permissions</h3>
<li>The app may request the following permissions:</li>
<li><strong>Internet</strong>: For ads and analytics.</li>
<li><strong>Storage/Gallery</strong>: To select and store pet photos.</li>
<li><strong>Notifications</strong>: To send health and activity reminders.</li>
<h3>5. Contact Us</h3>
<li>If you have any questions or feedback, please contact us at:</li>
<li><strong>Email</strong>: info@41software.com</li>
<li><strong>Web</strong>: www.41software.com</li>
<li>By using My Pets, you agree to the terms of this Privacy Policy.</li>',
        'security_title' => 'Güvenlik', 'security_text' => 'Verileriniz cihazınızda yerel olarak saklanır.',
        'contact_title' => 'İletişim', 'contact_text' => 'Sorularınız için bizimle iletişime geçebilirsiniz.', 'last_updated' => 'Son Güncelleme:'
    ],
    'en' => [
        'title' => 'Privacy Policy - ' . $appName, 'home' => 'Home', 'effective_date' => 'Effective Date',
        'intro_title' => 'Introduction', 'intro_text' => 'At 41Software, we value your privacy.',
        'collect_title' => 'Information Collected', 'points' => '<h3>Privacy Policy for My Pets</h3>
<li><strong>Last Updated: January 16, 2026</strong></li>
<li>Thank you for choosing <strong>My Pets</strong>. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our mobile application.</li>
<h3>1. Information Collection</h3>
<li>My Pets is designed to work primarily offline. Most of the data you enter (pet details, activities, health records, etc.) is stored locally on your device.</li>
<li><strong>Personal Data</strong>: We do not collect personal identifying information (PII) such as your name, email address, or phone number unless you explicitly provide it for feedback purposes via email.</li>
<li><strong>Microchip/ID Data</strong>: Any pet identification numbers or microchip IDs you enter are stored locally on your device and are not uploaded to our servers.</li>
<li><strong>Media</strong>: If you choose to upload a photo of your pet, it is stored locally or processed via local device storage.</li>
<h3>2. Third-Party Services</h3>
<li>We use the following third-party services which may collect data according to their own policies:</li>
<li><strong>Google AdMob</strong>: Used to display advertisements. AdMob may collect device identifiers and usage data to personalize ads.</li>
<li><strong>Microsoft Clarity</strong>: Used for usage analytics and improving user experience. It may track how you interact with the app.</li>
<h3>3. Data Storage and Security</h3>
<p>All your pet data is stored in a local database (SQLite) on your device. We do not have access to this data. If you delete the app or clear its data, this information will be permanently lost unless you have a backup.</p>
<h3>4. Permissions</h3>
<li>The app may request the following permissions:</li>
<li><strong>Internet</strong>: For ads and analytics.</li>
<li><strong>Storage/Gallery</strong>: To select and store pet photos.</li>
<li><strong>Notifications</strong>: To send health and activity reminders.</li>
<h3>5. Contact Us</h3>
<li>If you have any questions or feedback, please contact us at:</li>
<li><strong>Email</strong>: info@41software.com</li>
<li><strong>Web</strong>: www.41software.com</li>
<li>By using My Pets, you agree to the terms of this Privacy Policy.</li>',
        'security_title' => 'Security', 'security_text' => 'Your data is stored locally on your device.',
        'contact_title' => 'Contact Us', 'contact_text' => 'For questions and support regarding our privacy policy.', 'last_updated' => 'Last Updated:'
    ],
    'de' => [
        'title' => 'Datenschutzerklärung - ' . $appName, 'home' => 'Startseite', 'effective_date' => 'Gültig ab',
        'intro_title' => 'Einführung', 'intro_text' => 'Bei 41Software legen wir Wert auf Ihre Privatsphäre.',
        'collect_title' => 'Gesammelte Daten', 'points' => '<h3>Privacy Policy for My Pets</h3>
<li><strong>Last Updated: January 16, 2026</strong></li>
<li>Thank you for choosing <strong>My Pets</strong>. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our mobile application.</li>
<h3>1. Information Collection</h3>
<li>My Pets is designed to work primarily offline. Most of the data you enter (pet details, activities, health records, etc.) is stored locally on your device.</li>
<li><strong>Personal Data</strong>: We do not collect personal identifying information (PII) such as your name, email address, or phone number unless you explicitly provide it for feedback purposes via email.</li>
<li><strong>Microchip/ID Data</strong>: Any pet identification numbers or microchip IDs you enter are stored locally on your device and are not uploaded to our servers.</li>
<li><strong>Media</strong>: If you choose to upload a photo of your pet, it is stored locally or processed via local device storage.</li>
<h3>2. Third-Party Services</h3>
<li>We use the following third-party services which may collect data according to their own policies:</li>
<li><strong>Google AdMob</strong>: Used to display advertisements. AdMob may collect device identifiers and usage data to personalize ads.</li>
<li><strong>Microsoft Clarity</strong>: Used for usage analytics and improving user experience. It may track how you interact with the app.</li>
<h3>3. Data Storage and Security</h3>
<p>All your pet data is stored in a local database (SQLite) on your device. We do not have access to this data. If you delete the app or clear its data, this information will be permanently lost unless you have a backup.</p>
<h3>4. Permissions</h3>
<li>The app may request the following permissions:</li>
<li><strong>Internet</strong>: For ads and analytics.</li>
<li><strong>Storage/Gallery</strong>: To select and store pet photos.</li>
<li><strong>Notifications</strong>: To send health and activity reminders.</li>
<h3>5. Contact Us</h3>
<li>If you have any questions or feedback, please contact us at:</li>
<li><strong>Email</strong>: info@41software.com</li>
<li><strong>Web</strong>: www.41software.com</li>
<li>By using My Pets, you agree to the terms of this Privacy Policy.</li>',
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