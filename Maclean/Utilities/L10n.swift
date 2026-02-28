import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case en = "en"
    case zhHant = "zh-Hant"
    case zhHans = "zh-Hans"
    case ja = "ja"
    case ko = "ko"
    case de = "de"
    case es = "es"
    case fr = "fr"
    case pt = "pt"
    case ru = "ru"
    case ar = "ar"
    case hi = "hi"
    case it = "it"
    case nl = "nl"
    case tr = "tr"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .en: "English"
        case .zhHant: "繁體中文"
        case .zhHans: "简体中文"
        case .ja: "日本語"
        case .ko: "한국어"
        case .de: "Deutsch"
        case .es: "Español"
        case .fr: "Français"
        case .pt: "Português"
        case .ru: "Русский"
        case .ar: "العربية"
        case .hi: "हिन्दी"
        case .it: "Italiano"
        case .nl: "Nederlands"
        case .tr: "Türkçe"
        }
    }

    var locale: Locale {
        Locale(identifier: rawValue)
    }
}

@MainActor
final class L10n: ObservableObject {
    static let shared = L10n()

    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "appLanguage")
        }
    }

    private init() {
        let stored = UserDefaults.standard.string(forKey: "appLanguage")
        self.currentLanguage = stored.flatMap(AppLanguage.init(rawValue:)) ?? .zhHant
    }

    private func t(_ translations: [AppLanguage: String]) -> String {
        translations[currentLanguage] ?? translations[.en] ?? ""
    }

    // MARK: - Dashboard
    var dashboard: String { t([
        .en: "Dashboard", .zhHant: "儀表板", .zhHans: "仪表盘", .ja: "ダッシュボード", .ko: "대시보드",
        .de: "Übersicht", .es: "Panel", .fr: "Tableau de bord", .pt: "Painel", .ru: "Панель",
        .ar: "لوحة التحكم", .hi: "डैशबोर्ड", .it: "Pannello", .nl: "Dashboard", .tr: "Kontrol Paneli",
    ]) }
    var quickActions: String { t([
        .en: "Quick Actions", .zhHant: "快捷操作", .zhHans: "快捷操作", .ja: "クイックアクション", .ko: "빠른 작업",
        .de: "Schnellaktionen", .es: "Acciones rápidas", .fr: "Actions rapides", .pt: "Ações rápidas", .ru: "Быстрые действия",
        .ar: "إجراءات سريعة", .hi: "त्वरित कार्य", .it: "Azioni rapide", .nl: "Snelle acties", .tr: "Hızlı İşlemler",
    ]) }
    var dashboardScanDesc: String { t([
        .en: "Scan system junk", .zhHant: "掃描系統垃圾", .zhHans: "扫描系统垃圾", .ja: "システムの不要ファイルをスキャン", .ko: "시스템 정크 스캔",
        .de: "Systemmüll scannen", .es: "Escanear basura del sistema", .fr: "Analyser les fichiers inutiles", .pt: "Verificar lixo do sistema", .ru: "Сканировать системный мусор",
        .ar: "فحص ملفات النظام غير الضرورية", .hi: "सिस्टम जंक स्कैन करें", .it: "Scansiona file di sistema inutili", .nl: "Scan systeemrommel", .tr: "Sistem çöplerini tara",
    ]) }
    var dashboardProjectDesc: String { t([
        .en: "Clean build artifacts", .zhHant: "清理建置產物", .zhHans: "清理构建产物", .ja: "ビルド成果物をクリーン", .ko: "빌드 산출물 정리",
        .de: "Build-Artefakte bereinigen", .es: "Limpiar artefactos de compilación", .fr: "Nettoyer les artefacts de build", .pt: "Limpar artefatos de compilação", .ru: "Очистить артефакты сборки",
        .ar: "تنظيف مخرجات البناء", .hi: "बिल्ड आर्टिफ़ैक्ट साफ़ करें", .it: "Pulisci artefatti di compilazione", .nl: "Bouw-artefacten opruimen", .tr: "Derleme çıktılarını temizle",
    ]) }
    var dashboardDiskDesc: String { t([
        .en: "Find large files", .zhHant: "找出大檔案", .zhHans: "查找大文件", .ja: "大きなファイルを検索", .ko: "대용량 파일 찾기",
        .de: "Große Dateien finden", .es: "Buscar archivos grandes", .fr: "Trouver les gros fichiers", .pt: "Encontrar ficheiros grandes", .ru: "Найти большие файлы",
        .ar: "البحث عن الملفات الكبيرة", .hi: "बड़ी फ़ाइलें खोजें", .it: "Trova file di grandi dimensioni", .nl: "Grote bestanden zoeken", .tr: "Büyük dosyaları bul",
    ]) }
    var dashboardAppDesc: String { t([
        .en: "Scan idle apps", .zhHant: "掃描閒置應用", .zhHans: "扫描闲置应用", .ja: "未使用アプリをスキャン", .ko: "유휴 앱 스캔",
        .de: "Unbenutzte Apps scannen", .es: "Escanear apps inactivas", .fr: "Analyser les apps inactives", .pt: "Verificar apps inativas", .ru: "Сканировать неиспользуемые приложения",
        .ar: "فحص التطبيقات غير المستخدمة", .hi: "निष्क्रिय ऐप्स स्कैन करें", .it: "Scansiona app inutilizzate", .nl: "Ongebruikte apps scannen", .tr: "Kullanılmayan uygulamaları tara",
    ]) }
    var dashboardLipoDesc: String { t([
        .en: "Remove unused archs", .zhHant: "移除多餘架構", .zhHans: "移除多余架构", .ja: "未使用アーキテクチャを削除", .ko: "미사용 아키텍처 제거",
        .de: "Unbenutzte Architekturen entfernen", .es: "Eliminar arquitecturas no usadas", .fr: "Supprimer les architectures inutilisées", .pt: "Remover arquiteturas não utilizadas", .ru: "Удалить неиспользуемые архитектуры",
        .ar: "إزالة البنى غير المستخدمة", .hi: "अप्रयुक्त आर्किटेक्चर हटाएं", .it: "Rimuovi architetture inutilizzate", .nl: "Ongebruikte architecturen verwijderen", .tr: "Kullanılmayan mimarileri kaldır",
    ]) }
    var dashboardHistoryDesc: String { t([
        .en: "View cleaning history", .zhHant: "查看清理紀錄", .zhHans: "查看清理记录", .ja: "クリーニング履歴を表示", .ko: "정리 기록 보기",
        .de: "Bereinigungsverlauf anzeigen", .es: "Ver historial de limpieza", .fr: "Voir l'historique de nettoyage", .pt: "Ver histórico de limpeza", .ru: "Просмотр истории очистки",
        .ar: "عرض سجل التنظيف", .hi: "सफ़ाई इतिहास देखें", .it: "Visualizza cronologia pulizia", .nl: "Opruimgeschiedenis bekijken", .tr: "Temizlik geçmişini görüntüle",
    ]) }

    // MARK: - Sidebar
    var scan: String { t([
        .en: "Clean Up", .zhHant: "清理空間", .zhHans: "清理空间", .ja: "クリーンアップ", .ko: "정리하기",
        .de: "Aufräumen", .es: "Limpiar", .fr: "Nettoyer", .pt: "Limpar", .ru: "Очистка",
        .ar: "تنظيف", .hi: "साफ़ करें", .it: "Pulisci", .nl: "Opruimen", .tr: "Temizle",
    ]) }
    var history: String { t([
        .en: "History", .zhHant: "歷史紀錄", .zhHans: "历史记录", .ja: "履歴", .ko: "기록",
        .de: "Verlauf", .es: "Historial", .fr: "Historique", .pt: "Histórico", .ru: "История",
        .ar: "السجل", .hi: "इतिहास", .it: "Cronologia", .nl: "Geschiedenis", .tr: "Geçmiş",
    ]) }
    var whitelist: String { t([
        .en: "Whitelist", .zhHant: "白名單", .zhHans: "白名单", .ja: "ホワイトリスト", .ko: "화이트리스트",
        .de: "Whitelist", .es: "Lista blanca", .fr: "Liste blanche", .pt: "Lista branca", .ru: "Белый список",
        .ar: "القائمة البيضاء", .hi: "श्वेतसूची", .it: "Lista bianca", .nl: "Witte lijst", .tr: "Beyaz Liste",
    ]) }
    var settings: String { t([
        .en: "Settings", .zhHant: "設定", .zhHans: "设置", .ja: "設定", .ko: "설정",
        .de: "Einstellungen", .es: "Ajustes", .fr: "Réglages", .pt: "Definições", .ru: "Настройки",
        .ar: "الإعدادات", .hi: "सेटिंग्स", .it: "Impostazioni", .nl: "Instellingen", .tr: "Ayarlar",
    ]) }

    var appLipo: String { t([
        .en: "App Slimming", .zhHant: "應用瘦身", .zhHans: "应用瘦身", .ja: "アプリスリム化", .ko: "앱 슬리밍",
        .de: "App-Verschlankung", .es: "Adelgazamiento de apps", .fr: "Amincissement d'apps", .pt: "Emagrecimento de apps", .ru: "Оптимизация приложений",
        .ar: "تنحيف التطبيقات", .hi: "ऐप स्लिमिंग", .it: "Snellimento app", .nl: "App-afslanking", .tr: "Uygulama İnceleme",
    ]) }

    // MARK: - Quick Clean
    var quickClean: String { t([
        .en: "Quick Clean", .zhHant: "一鍵清理", .zhHans: "一键清理", .ja: "クイッククリーン", .ko: "빠른 정리",
        .de: "Schnellreinigung", .es: "Limpieza rápida", .fr: "Nettoyage rapide", .pt: "Limpeza rápida", .ru: "Быстрая очистка",
        .ar: "تنظيف سريع", .hi: "त्वरित सफ़ाई", .it: "Pulizia rapida", .nl: "Snel opruimen", .tr: "Hızlı Temizlik",
    ]) }
    var quickCleanDesc: String { t([
        .en: "Run all cleanup tasks in sequence", .zhHant: "依序執行所有清理任務", .zhHans: "依次执行所有清理任务", .ja: "すべてのクリーンアップタスクを順番に実行", .ko: "모든 정리 작업을 순서대로 실행",
        .de: "Alle Reinigungsaufgaben nacheinander ausführen", .es: "Ejecutar todas las tareas de limpieza en secuencia", .fr: "Exécuter toutes les tâches de nettoyage en séquence", .pt: "Executar todas as tarefas de limpeza em sequência", .ru: "Выполнить все задачи очистки последовательно",
        .ar: "تشغيل جميع مهام التنظيف بالتتابع", .hi: "सभी सफ़ाई कार्य क्रम में चलाएँ", .it: "Esegui tutte le attività di pulizia in sequenza", .nl: "Alle opruimtaken achter elkaar uitvoeren", .tr: "Tüm temizlik görevlerini sırayla çalıştır",
    ]) }
    var cleanAndContinue: String { t([
        .en: "Clean & Continue", .zhHant: "清理並繼續", .zhHans: "清理并继续", .ja: "クリーンして続行", .ko: "정리 후 계속",
        .de: "Bereinigen & Weiter", .es: "Limpiar y continuar", .fr: "Nettoyer et continuer", .pt: "Limpar e continuar", .ru: "Очистить и продолжить",
        .ar: "تنظيف ومتابعة", .hi: "साफ़ करें और जारी रखें", .it: "Pulisci e continua", .nl: "Opruimen en doorgaan", .tr: "Temizle ve Devam Et",
    ]) }
    var cleanAndFinish: String { t([
        .en: "Clean & Finish", .zhHant: "清理並完成", .zhHans: "清理并完成", .ja: "クリーンして完了", .ko: "정리 후 완료",
        .de: "Bereinigen & Fertig", .es: "Limpiar y finalizar", .fr: "Nettoyer et terminer", .pt: "Limpar e finalizar", .ru: "Очистить и завершить",
        .ar: "تنظيف وإنهاء", .hi: "साफ़ करें और समाप्त करें", .it: "Pulisci e termina", .nl: "Opruimen en afronden", .tr: "Temizle ve Bitir",
    ]) }
    var skipStep: String { t([
        .en: "Skip", .zhHant: "跳過", .zhHans: "跳过", .ja: "スキップ", .ko: "건너뛰기",
        .de: "Überspringen", .es: "Omitir", .fr: "Passer", .pt: "Pular", .ru: "Пропустить",
        .ar: "تخطي", .hi: "छोड़ें", .it: "Salta", .nl: "Overslaan", .tr: "Atla",
    ]) }
    var wizardStep: String { t([
        .en: "Step", .zhHant: "步驟", .zhHans: "步骤", .ja: "ステップ", .ko: "단계",
        .de: "Schritt", .es: "Paso", .fr: "Étape", .pt: "Passo", .ru: "Шаг",
        .ar: "خطوة", .hi: "चरण", .it: "Passaggio", .nl: "Stap", .tr: "Adım",
    ]) }
    var wizardSummary: String { t([
        .en: "Summary", .zhHant: "清理總結", .zhHans: "清理总结", .ja: "まとめ", .ko: "요약",
        .de: "Zusammenfassung", .es: "Resumen", .fr: "Résumé", .pt: "Resumo", .ru: "Итог",
        .ar: "ملخص", .hi: "सारांश", .it: "Riepilogo", .nl: "Samenvatting", .tr: "Özet",
    ]) }
    var wizardSummaryDesc: String { t([
        .en: "All cleanup tasks completed", .zhHant: "所有清理任務已完成", .zhHans: "所有清理任务已完成", .ja: "すべてのクリーンアップタスクが完了しました", .ko: "모든 정리 작업이 완료되었습니다",
        .de: "Alle Reinigungsaufgaben abgeschlossen", .es: "Todas las tareas de limpieza completadas", .fr: "Toutes les tâches de nettoyage terminées", .pt: "Todas as tarefas de limpeza concluídas", .ru: "Все задачи очистки завершены",
        .ar: "اكتملت جميع مهام التنظيف", .hi: "सभी सफ़ाई कार्य पूर्ण", .it: "Tutte le attività di pulizia completate", .nl: "Alle opruimtaken voltooid", .tr: "Tüm temizlik görevleri tamamlandı",
    ]) }
    var totalSaved: String { t([
        .en: "Total Space Saved", .zhHant: "總共節省空間", .zhHans: "总共节省空间", .ja: "合計節約容量", .ko: "총 절약 공간",
        .de: "Insgesamt eingesparter Speicher", .es: "Espacio total ahorrado", .fr: "Espace total économisé", .pt: "Espaço total economizado", .ru: "Всего освобождено",
        .ar: "إجمالي المساحة المحررة", .hi: "कुल बचत स्थान", .it: "Spazio totale risparmiato", .nl: "Totaal bespaarde ruimte", .tr: "Toplam Kazanılan Alan",
    ]) }
    var backToDashboard: String { t([
        .en: "Back to Dashboard", .zhHant: "回到儀表板", .zhHans: "回到仪表盘", .ja: "ダッシュボードに戻る", .ko: "대시보드로 돌아가기",
        .de: "Zurück zur Übersicht", .es: "Volver al panel", .fr: "Retour au tableau de bord", .pt: "Voltar ao painel", .ru: "Вернуться на панель",
        .ar: "العودة إلى لوحة التحكم", .hi: "डैशबोर्ड पर वापस जाएँ", .it: "Torna al pannello", .nl: "Terug naar dashboard", .tr: "Kontrol Paneline Dön",
    ]) }

    // MARK: - Scan View
    var readyToClean: String { t([
        .en: "Ready to Clean", .zhHant: "準備清理", .zhHans: "准备清理", .ja: "クリーン準備完了", .ko: "정리 준비 완료",
        .de: "Bereit zum Aufräumen", .es: "Listo para limpiar", .fr: "Prêt à nettoyer", .pt: "Pronto para limpar", .ru: "Готово к очистке",
        .ar: "جاهز للتنظيف", .hi: "सफ़ाई के लिए तैयार", .it: "Pronto per la pulizia", .nl: "Klaar om op te ruimen", .tr: "Temizlemeye Hazır",
    ]) }
    var scanDescription: String { t([
        .en: "Scan your system for unnecessary files", .zhHant: "掃描系統中的無用檔案", .zhHans: "扫描系统中的无用文件", .ja: "不要なファイルをスキャン", .ko: "불필요한 파일 스캔",
        .de: "System nach unnötigen Dateien durchsuchen", .es: "Escanear archivos innecesarios del sistema", .fr: "Analyser le système pour les fichiers inutiles", .pt: "Verificar ficheiros desnecessários no sistema", .ru: "Сканировать систему на наличие ненужных файлов",
        .ar: "فحص النظام بحثاً عن الملفات غير الضرورية", .hi: "अनावश्यक फ़ाइलों के लिए सिस्टम स्कैन करें", .it: "Scansiona il sistema alla ricerca di file non necessari", .nl: "Scan je systeem op onnodige bestanden", .tr: "Gereksiz dosyalar için sistemi tarayın",
    ]) }
    var startScan: String { t([
        .en: "Start Scan", .zhHant: "開始掃描", .zhHans: "开始扫描", .ja: "スキャン開始", .ko: "스캔 시작",
        .de: "Scan starten", .es: "Iniciar escaneo", .fr: "Lancer l'analyse", .pt: "Iniciar verificação", .ru: "Начать сканирование",
        .ar: "بدء الفحص", .hi: "स्कैन शुरू करें", .it: "Avvia scansione", .nl: "Start scan", .tr: "Taramayı Başlat",
    ]) }
    var scanning: String { t([
        .en: "Scanning", .zhHant: "掃描中", .zhHans: "扫描中", .ja: "スキャン中", .ko: "스캔 중",
        .de: "Wird gescannt", .es: "Escaneando", .fr: "Analyse en cours", .pt: "A verificar", .ru: "Сканирование",
        .ar: "جارٍ الفحص", .hi: "स्कैन हो रहा है", .it: "Scansione in corso", .nl: "Bezig met scannen", .tr: "Taranıyor",
    ]) }
    var noJunkFound: String { t([
        .en: "Your System is Clean", .zhHant: "系統已經很乾淨", .zhHans: "系统已经很干净", .ja: "システムはクリーンです", .ko: "시스템이 깨끗합니다",
        .de: "Ihr System ist sauber", .es: "Su sistema está limpio", .fr: "Votre système est propre", .pt: "O seu sistema está limpo", .ru: "Ваша система чиста",
        .ar: "نظامك نظيف", .hi: "आपका सिस्टम साफ़ है", .it: "Il sistema è pulito", .nl: "Je systeem is schoon", .tr: "Sisteminiz Temiz",
    ]) }
    var noJunkFoundDesc: String { t([
        .en: "No unnecessary files were found on your system.", .zhHant: "系統中沒有找到無用檔案。", .zhHans: "系统中没有找到无用文件。", .ja: "不要なファイルは見つかりませんでした。", .ko: "불필요한 파일이 발견되지 않았습니다.",
        .de: "Auf Ihrem System wurden keine unnötigen Dateien gefunden.", .es: "No se encontraron archivos innecesarios en su sistema.", .fr: "Aucun fichier inutile trouvé sur votre système.", .pt: "Não foram encontrados ficheiros desnecessários no seu sistema.", .ru: "На вашей системе не найдено ненужных файлов.",
        .ar: "لم يتم العثور على ملفات غير ضرورية في نظامك.", .hi: "आपके सिस्टम में कोई अनावश्यक फ़ाइल नहीं मिली।", .it: "Non sono stati trovati file non necessari nel sistema.", .nl: "Er zijn geen onnodige bestanden gevonden op je systeem.", .tr: "Sisteminizde gereksiz dosya bulunamadı.",
    ]) }
    var reviewAndClean: String { t([
        .en: "Preview Delete", .zhHant: "預覽刪除", .zhHans: "预览删除", .ja: "削除をプレビュー", .ko: "삭제 미리보기",
        .de: "Löschvorschau", .es: "Vista previa de eliminación", .fr: "Aperçu de suppression", .pt: "Pré-visualizar eliminação", .ru: "Предварительный просмотр удаления",
        .ar: "معاينة الحذف", .hi: "हटाने का पूर्वावलोकन", .it: "Anteprima ed elimina", .nl: "Voorbeeld en verwijder", .tr: "Önizle ve Sil",
    ]) }
    var reset: String { t([
        .en: "Reset", .zhHant: "重置", .zhHans: "重置", .ja: "リセット", .ko: "초기화",
        .de: "Zurücksetzen", .es: "Restablecer", .fr: "Réinitialiser", .pt: "Repor", .ru: "Сброс",
        .ar: "إعادة تعيين", .hi: "रीसेट", .it: "Ripristina", .nl: "Opnieuw instellen", .tr: "Sıfırla",
    ]) }

    // MARK: - Categories
    var systemCache: String { t([
        .en: "System Cache", .zhHant: "系統快取", .zhHans: "系统缓存", .ja: "システムキャッシュ", .ko: "시스템 캐시",
        .de: "System-Cache", .es: "Caché del sistema", .fr: "Cache système", .pt: "Cache do sistema", .ru: "Системный кэш",
        .ar: "ذاكرة التخزين المؤقت للنظام", .hi: "सिस्टम कैश", .it: "Cache di sistema", .nl: "Systeemcache", .tr: "Sistem Önbelleği",
    ]) }
    var systemCacheDesc: String { t([
        .en: "Cached data from applications. Safe to remove; apps will rebuild caches as needed.",
        .zhHant: "應用程式的快取資料。可安全移除，應用程式會在需要時重新建立快取。",
        .zhHans: "应用程序的缓存数据。可安全移除，应用程序会在需要时重新建立缓存。",
        .ja: "アプリケーションのキャッシュデータ。安全に削除できます。必要に応じて再構築されます。",
        .ko: "앱의 캐시 데이터. 안전하게 삭제 가능하며, 필요시 앱이 캐시를 재생성합니다.",
        .de: "Zwischengespeicherte Daten von Anwendungen. Sicher zu entfernen; Apps erstellen den Cache bei Bedarf neu.",
        .es: "Datos en caché de aplicaciones. Seguro de eliminar; las apps reconstruirán la caché cuando sea necesario.",
        .fr: "Données en cache des applications. Suppression sûre ; les apps reconstruiront le cache si nécessaire.",
        .pt: "Dados em cache de aplicações. Seguro remover; as apps reconstruirão o cache quando necessário.",
        .ru: "Кэшированные данные приложений. Безопасно удалять; приложения пересоздадут кэш при необходимости.",
        .ar: "بيانات مخزنة مؤقتاً من التطبيقات. آمنة للإزالة؛ ستعيد التطبيقات بناء التخزين المؤقت عند الحاجة.",
        .hi: "ऐप्स का कैश डेटा। हटाना सुरक्षित है; ऐप्स आवश्यकतानुसार कैश पुनः बनाएंगे।",
        .it: "Dati memorizzati nella cache delle applicazioni. Sicuro da rimuovere; le app ricostruiranno la cache all'occorrenza.",
        .nl: "Gecachte gegevens van apps. Veilig te verwijderen; apps bouwen de cache opnieuw op wanneer nodig.",
        .tr: "Uygulamaların önbellek verileri. Güvenle kaldırılabilir; uygulamalar gerektiğinde önbelleği yeniden oluşturur.",
    ]) }
    var systemLogs: String { t([
        .en: "System Logs", .zhHant: "系統日誌", .zhHans: "系统日志", .ja: "システムログ", .ko: "시스템 로그",
        .de: "Systemprotokolle", .es: "Registros del sistema", .fr: "Journaux système", .pt: "Registos do sistema", .ru: "Системные журналы",
        .ar: "سجلات النظام", .hi: "सिस्टम लॉग", .it: "Registri di sistema", .nl: "Systeemlogboeken", .tr: "Sistem Günlükleri",
    ]) }
    var systemLogsDesc: String { t([
        .en: "Diagnostic reports and log files. Removing these frees space without affecting system function.",
        .zhHant: "診斷報告和日誌檔案。移除後不影響系統運作。",
        .zhHans: "诊断报告和日志文件。移除后不影响系统运作。",
        .ja: "診断レポートとログファイル。削除してもシステム機能に影響しません。",
        .ko: "진단 보고서 및 로그 파일. 삭제해도 시스템 기능에 영향이 없습니다.",
        .de: "Diagnoseberichte und Protokolldateien. Entfernung gibt Speicherplatz frei, ohne die Systemfunktion zu beeinträchtigen.",
        .es: "Informes de diagnóstico y archivos de registro. Eliminarlos libera espacio sin afectar el funcionamiento del sistema.",
        .fr: "Rapports de diagnostic et fichiers journaux. Leur suppression libère de l'espace sans affecter le système.",
        .pt: "Relatórios de diagnóstico e ficheiros de registo. A remoção liberta espaço sem afetar o funcionamento do sistema.",
        .ru: "Диагностические отчёты и файлы журналов. Удаление освобождает место без влияния на работу системы.",
        .ar: "تقارير التشخيص وملفات السجل. إزالتها تحرر مساحة دون التأثير على وظائف النظام.",
        .hi: "डायग्नोस्टिक रिपोर्ट और लॉग फ़ाइलें। हटाने से सिस्टम कार्य प्रभावित नहीं होता।",
        .it: "Rapporti diagnostici e file di registro. La rimozione non influisce sul funzionamento del sistema.",
        .nl: "Diagnostische rapporten en logbestanden. Verwijderen heeft geen invloed op de systeemwerking.",
        .tr: "Tanılama raporları ve günlük dosyaları. Kaldırılması sistem işlevini etkilemez.",
    ]) }
    var browserCache: String { t([
        .en: "Browser Cache", .zhHant: "瀏覽器快取", .zhHans: "浏览器缓存", .ja: "ブラウザキャッシュ", .ko: "브라우저 캐시",
        .de: "Browser-Cache", .es: "Caché del navegador", .fr: "Cache du navigateur", .pt: "Cache do navegador", .ru: "Кэш браузера",
        .ar: "ذاكرة التخزين المؤقت للمتصفح", .hi: "ब्राउज़र कैश", .it: "Cache del browser", .nl: "Browsercache", .tr: "Tarayıcı Önbelleği",
    ]) }
    var browserCacheDesc: String { t([
        .en: "Browser cached data. Clearing this will NOT log you out of websites, but pages may load slower initially.",
        .zhHant: "瀏覽器快取資料。清除後不會登出網站，但頁面初次載入可能較慢。",
        .zhHans: "浏览器缓存数据。清除后不会退出网站登录，但页面首次加载可能较慢。",
        .ja: "ブラウザのキャッシュデータ。クリアしてもウェブサイトからログアウトされませんが、最初はページの読み込みが遅くなる場合があります。",
        .ko: "브라우저 캐시 데이터. 삭제해도 웹사이트에서 로그아웃되지 않지만, 처음에는 페이지 로딩이 느릴 수 있습니다.",
        .de: "Browser-Cache-Daten. Das Löschen meldet Sie nicht von Websites ab, aber Seiten laden möglicherweise anfänglich langsamer.",
        .es: "Datos en caché del navegador. Limpiar esto NO cerrará su sesión en los sitios web, pero las páginas pueden cargar más lento al inicio.",
        .fr: "Données en cache du navigateur. L'effacement ne vous déconnectera PAS des sites web, mais les pages peuvent charger plus lentement au début.",
        .pt: "Dados em cache do navegador. Limpar não o desligará dos sites, mas as páginas podem carregar mais lentamente inicialmente.",
        .ru: "Кэш браузера. Очистка НЕ выполнит выход с сайтов, но страницы могут загружаться медленнее в первый раз.",
        .ar: "بيانات التخزين المؤقت للمتصفح. لن يؤدي المسح إلى تسجيل الخروج من المواقع، لكن قد تكون الصفحات أبطأ في التحميل مبدئياً.",
        .hi: "ब्राउज़र कैश डेटा। साफ़ करने से वेबसाइटों से लॉगआउट नहीं होगा, लेकिन पेज शुरू में धीमे लोड हो सकते हैं।",
        .it: "Dati memorizzati nella cache del browser. La cancellazione non effettuerà il logout dai siti web, ma le pagine potrebbero caricarsi più lentamente inizialmente.",
        .nl: "Gecachte browsergegevens. Wissen logt je niet uit van websites, maar pagina's laden mogelijk langzamer in het begin.",
        .tr: "Tarayıcı önbellek verileri. Temizlemek web sitelerinden çıkış yapmaz ancak sayfalar başlangıçta daha yavaş yüklenebilir.",
    ]) }
    var trash: String { t([
        .en: "Trash", .zhHant: "垃圾桶", .zhHans: "废纸篓", .ja: "ゴミ箱", .ko: "휴지통",
        .de: "Papierkorb", .es: "Papelera", .fr: "Corbeille", .pt: "Lixo", .ru: "Корзина",
        .ar: "سلة المهملات", .hi: "ट्रैश", .it: "Cestino", .nl: "Prullenmand", .tr: "Çöp Sepeti",
    ]) }
    var trashDesc: String { t([
        .en: "Files in your Trash. These are already deleted and waiting to be permanently removed.",
        .zhHant: "垃圾桶中的檔案。這些檔案已被刪除，等待永久移除。",
        .zhHans: "废纸篓中的文件。这些文件已被删除，等待永久移除。",
        .ja: "ゴミ箱内のファイル。削除済みで、完全に削除されるのを待っています。",
        .ko: "휴지통의 파일. 이미 삭제되어 영구 삭제를 기다리고 있습니다.",
        .de: "Dateien im Papierkorb. Diese sind bereits gelöscht und warten auf endgültige Entfernung.",
        .es: "Archivos en la Papelera. Ya están eliminados y esperan ser eliminados permanentemente.",
        .fr: "Fichiers dans la Corbeille. Ils sont déjà supprimés et attendent d'être définitivement effacés.",
        .pt: "Ficheiros no Lixo. Já foram eliminados e aguardam remoção permanente.",
        .ru: "Файлы в Корзине. Они уже удалены и ожидают окончательного удаления.",
        .ar: "ملفات في سلة المهملات. تم حذفها بالفعل وتنتظر الإزالة نهائياً.",
        .hi: "ट्रैश में फ़ाइलें। ये पहले से हटाई जा चुकी हैं और स्थायी रूप से हटाने की प्रतीक्षा में हैं।",
        .it: "File nel Cestino. Sono già stati eliminati e attendono la rimozione definitiva.",
        .nl: "Bestanden in je Prullenmand. Deze zijn al verwijderd en wachten op definitieve verwijdering.",
        .tr: "Çöp Sepetindeki dosyalar. Bunlar zaten silinmiş olup kalıcı olarak kaldırılmayı bekliyor.",
    ]) }
    var xcode: String { t([
        .en: "Xcode", .zhHant: "Xcode", .zhHans: "Xcode", .ja: "Xcode", .ko: "Xcode",
        .de: "Xcode", .es: "Xcode", .fr: "Xcode", .pt: "Xcode", .ru: "Xcode",
        .ar: "Xcode", .hi: "Xcode", .it: "Xcode", .nl: "Xcode", .tr: "Xcode",
    ]) }
    var xcodeDesc: String { t([
        .en: "Xcode build caches, archives, and simulator data. Safe to remove; Xcode will rebuild as needed.",
        .zhHant: "Xcode 建置快取、歸檔和模擬器資料。可安全移除，Xcode 會在需要時重新建置。",
        .zhHans: "Xcode 构建缓存、归档和模拟器数据。可安全移除，Xcode 会在需要时重新构建。",
        .ja: "Xcodeのビルドキャッシュ、アーカイブ、シミュレーターデータ。安全に削除できます。",
        .ko: "Xcode 빌드 캐시, 아카이브, 시뮬레이터 데이터. 안전하게 삭제 가능합니다.",
        .de: "Xcode-Build-Caches, Archive und Simulator-Daten. Sicher zu entfernen; Xcode baut bei Bedarf neu.",
        .es: "Cachés de compilación, archivos y datos del simulador de Xcode. Seguro de eliminar; Xcode los reconstruirá cuando sea necesario.",
        .fr: "Caches de compilation, archives et données du simulateur Xcode. Suppression sûre ; Xcode les reconstruira si nécessaire.",
        .pt: "Caches de compilação, arquivos e dados do simulador do Xcode. Seguro remover; o Xcode reconstruirá quando necessário.",
        .ru: "Кэш сборки, архивы и данные симулятора Xcode. Безопасно удалять; Xcode пересоздаст при необходимости.",
        .ar: "ذاكرة التخزين المؤقت للبناء والأرشيفات وبيانات المحاكي في Xcode. آمنة للإزالة.",
        .hi: "Xcode बिल्ड कैश, आर्काइव और सिमुलेटर डेटा। हटाना सुरक्षित है।",
        .it: "Cache di compilazione, archivi e dati del simulatore di Xcode. Sicuro da rimuovere.",
        .nl: "Xcode-bouwcache, archieven en simulatorgegevens. Veilig te verwijderen.",
        .tr: "Xcode derleme önbelleği, arşivler ve simülatör verileri. Güvenle kaldırılabilir.",
    ]) }
    var homebrew: String { t([
        .en: "Homebrew", .zhHant: "Homebrew", .zhHans: "Homebrew", .ja: "Homebrew", .ko: "Homebrew",
        .de: "Homebrew", .es: "Homebrew", .fr: "Homebrew", .pt: "Homebrew", .ru: "Homebrew",
        .ar: "Homebrew", .hi: "Homebrew", .it: "Homebrew", .nl: "Homebrew", .tr: "Homebrew",
    ]) }
    var homebrewDesc: String { t([
        .en: "Homebrew download cache and outdated formula files.",
        .zhHant: "Homebrew 下載快取和過時的套件檔案。",
        .zhHans: "Homebrew 下载缓存和过时的套件文件。",
        .ja: "Homebrewのダウンロードキャッシュと古いフォーミュラファイル。",
        .ko: "Homebrew 다운로드 캐시 및 오래된 포뮬러 파일.",
        .de: "Homebrew-Download-Cache und veraltete Formel-Dateien.",
        .es: "Caché de descargas y archivos de fórmulas obsoletos de Homebrew.",
        .fr: "Cache de téléchargement et fichiers de formules obsolètes de Homebrew.",
        .pt: "Cache de download e ficheiros de fórmulas desatualizados do Homebrew.",
        .ru: "Кэш загрузок и устаревшие файлы формул Homebrew.",
        .ar: "ذاكرة التخزين المؤقت للتنزيل وملفات الحزم القديمة في Homebrew.",
        .hi: "Homebrew डाउनलोड कैश और पुरानी फॉर्मूला फ़ाइलें।",
        .it: "Cache di download e file di pacchetti obsoleti di Homebrew.",
        .nl: "Homebrew-downloadcache en verouderde pakketbestanden.",
        .tr: "Homebrew indirme önbelleği ve eski paket dosyaları.",
    ]) }
    var devToolsCache: String { t([
        .en: "Dev Tools Cache", .zhHant: "開發工具快取", .zhHans: "开发工具缓存", .ja: "開発ツールキャッシュ", .ko: "개발 도구 캐시",
        .de: "Entwicklertools-Cache", .es: "Caché de herramientas de desarrollo", .fr: "Cache des outils de développement", .pt: "Cache de ferramentas de desenvolvimento", .ru: "Кэш инструментов разработки",
        .ar: "ذاكرة التخزين المؤقت لأدوات التطوير", .hi: "डेव टूल्स कैश", .it: "Cache strumenti di sviluppo", .nl: "Ontwikkeltools-cache", .tr: "Geliştirici Araçları Önbelleği",
    ]) }
    var devToolsCacheDesc: String { t([
        .en: "Global caches for npm, pip, Cargo, Go, Gradle, CocoaPods, and more.",
        .zhHant: "npm、pip、Cargo、Go、Gradle、CocoaPods 等工具的全域快取。",
        .zhHans: "npm、pip、Cargo、Go、Gradle、CocoaPods 等工具的全局缓存。",
        .ja: "npm、pip、Cargo、Go、Gradle、CocoaPods等のグローバルキャッシュ。",
        .ko: "npm, pip, Cargo, Go, Gradle, CocoaPods 등의 글로벌 캐시.",
        .de: "Globale Caches für npm, pip, Cargo, Go, Gradle, CocoaPods und mehr.",
        .es: "Cachés globales de npm, pip, Cargo, Go, Gradle, CocoaPods y más.",
        .fr: "Caches globaux pour npm, pip, Cargo, Go, Gradle, CocoaPods et plus.",
        .pt: "Caches globais para npm, pip, Cargo, Go, Gradle, CocoaPods e mais.",
        .ru: "Глобальные кэши npm, pip, Cargo, Go, Gradle, CocoaPods и другие.",
        .ar: "ذاكرة التخزين المؤقت العامة لـ npm وpip وCargo وGo وGradle وCocoaPods والمزيد.",
        .hi: "npm, pip, Cargo, Go, Gradle, CocoaPods आदि का ग्लोबल कैश।",
        .it: "Cache globali per npm, pip, Cargo, Go, Gradle, CocoaPods e altri.",
        .nl: "Globale caches voor npm, pip, Cargo, Go, Gradle, CocoaPods en meer.",
        .tr: "npm, pip, Cargo, Go, Gradle, CocoaPods ve diğerlerinin genel önbellekleri.",
    ]) }
    var appCache: String { t([
        .en: "App Cache", .zhHant: "應用程式快取", .zhHans: "应用程序缓存", .ja: "アプリキャッシュ", .ko: "앱 캐시",
        .de: "App-Cache", .es: "Caché de apps", .fr: "Cache des apps", .pt: "Cache de apps", .ru: "Кэш приложений",
        .ar: "ذاكرة التخزين المؤقت للتطبيقات", .hi: "ऐप कैश", .it: "Cache delle app", .nl: "App-cache", .tr: "Uygulama Önbelleği",
    ]) }
    var appCacheDesc: String { t([
        .en: "Cached data from popular apps like Spotify, Slack, Discord, Adobe, JetBrains, etc.",
        .zhHant: "Spotify、Slack、Discord、Adobe、JetBrains 等常用應用的快取資料。",
        .zhHans: "Spotify、Slack、Discord、Adobe、JetBrains 等常用应用的缓存数据。",
        .ja: "Spotify、Slack、Discord、Adobe、JetBrains等の人気アプリのキャッシュデータ。",
        .ko: "Spotify, Slack, Discord, Adobe, JetBrains 등 인기 앱의 캐시 데이터.",
        .de: "Zwischengespeicherte Daten beliebter Apps wie Spotify, Slack, Discord, Adobe, JetBrains usw.",
        .es: "Datos en caché de apps populares como Spotify, Slack, Discord, Adobe, JetBrains, etc.",
        .fr: "Données en cache d'apps populaires comme Spotify, Slack, Discord, Adobe, JetBrains, etc.",
        .pt: "Dados em cache de apps populares como Spotify, Slack, Discord, Adobe, JetBrains, etc.",
        .ru: "Кэш популярных приложений: Spotify, Slack, Discord, Adobe, JetBrains и др.",
        .ar: "بيانات مخزنة مؤقتاً من تطبيقات شائعة مثل Spotify وSlack وDiscord وAdobe وJetBrains وغيرها.",
        .hi: "Spotify, Slack, Discord, Adobe, JetBrains आदि लोकप्रिय ऐप्स का कैश डेटा।",
        .it: "Dati memorizzati nella cache di app popolari come Spotify, Slack, Discord, Adobe, JetBrains, ecc.",
        .nl: "Gecachte gegevens van populaire apps zoals Spotify, Slack, Discord, Adobe, JetBrains, enz.",
        .tr: "Spotify, Slack, Discord, Adobe, JetBrains gibi popüler uygulamaların önbellek verileri.",
    ]) }
    var installers: String { t([
        .en: "Installers", .zhHant: "安裝器", .zhHans: "安装器", .ja: "インストーラー", .ko: "설치 프로그램",
        .de: "Installationsprogramme", .es: "Instaladores", .fr: "Programmes d'installation", .pt: "Instaladores", .ru: "Установщики",
        .ar: "برامج التثبيت", .hi: "इंस्टॉलर", .it: "Programmi di installazione", .nl: "Installatieprogramma's", .tr: "Yükleyiciler",
    ]) }
    var installersDesc: String { t([
        .en: "Installer files (.dmg, .pkg, .iso) in Downloads and Desktop.",
        .zhHant: "下載和桌面中的安裝器檔案（.dmg、.pkg、.iso）。",
        .zhHans: "下载和桌面中的安装器文件（.dmg、.pkg、.iso）。",
        .ja: "ダウンロードとデスクトップのインストーラーファイル（.dmg、.pkg、.iso）。",
        .ko: "다운로드 및 데스크탑의 설치 파일(.dmg, .pkg, .iso).",
        .de: "Installationsdateien (.dmg, .pkg, .iso) in Downloads und auf dem Schreibtisch.",
        .es: "Archivos de instalación (.dmg, .pkg, .iso) en Descargas y Escritorio.",
        .fr: "Fichiers d'installation (.dmg, .pkg, .iso) dans Téléchargements et Bureau.",
        .pt: "Ficheiros de instalação (.dmg, .pkg, .iso) em Transferências e Secretária.",
        .ru: "Файлы установщиков (.dmg, .pkg, .iso) в Загрузках и на Рабочем столе.",
        .ar: "ملفات التثبيت (.dmg، .pkg، .iso) في التنزيلات وسطح المكتب.",
        .hi: "डाउनलोड और डेस्कटॉप में इंस्टॉलर फ़ाइलें (.dmg, .pkg, .iso)।",
        .it: "File di installazione (.dmg, .pkg, .iso) in Download e sulla Scrivania.",
        .nl: "Installatiebestanden (.dmg, .pkg, .iso) in Downloads en op het Bureaublad.",
        .tr: "İndirilenler ve Masaüstündeki yükleyici dosyaları (.dmg, .pkg, .iso).",
    ]) }
    var iosBackups: String { t([
        .en: "iOS Backups", .zhHant: "iOS 備份", .zhHans: "iOS 备份", .ja: "iOS バックアップ", .ko: "iOS 백업",
        .de: "iOS-Backups", .es: "Copias de seguridad iOS", .fr: "Sauvegardes iOS", .pt: "Backups do iOS", .ru: "Резервные копии iOS",
        .ar: "نسخ iOS الاحتياطية", .hi: "iOS बैकअप", .it: "Backup iOS", .nl: "iOS-back-ups", .tr: "iOS Yedekleri",
    ]) }
    var iosBackupsDesc: String { t([
        .en: "iPhone/iPad backups stored locally. May be very large.",
        .zhHant: "儲存在本機的 iPhone/iPad 備份。可能非常大。",
        .zhHans: "存储在本地的 iPhone/iPad 备份。可能非常大。",
        .ja: "ローカルに保存されたiPhone/iPadバックアップ。非常に大きい場合があります。",
        .ko: "로컬에 저장된 iPhone/iPad 백업. 매우 클 수 있습니다.",
        .de: "Lokal gespeicherte iPhone-/iPad-Backups. Können sehr groß sein.",
        .es: "Copias de seguridad de iPhone/iPad almacenadas localmente. Pueden ser muy grandes.",
        .fr: "Sauvegardes iPhone/iPad stockées localement. Peuvent être très volumineuses.",
        .pt: "Backups de iPhone/iPad armazenados localmente. Podem ser muito grandes.",
        .ru: "Локальные резервные копии iPhone/iPad. Могут быть очень большими.",
        .ar: "نسخ احتياطية لـ iPhone/iPad مخزنة محلياً. قد تكون كبيرة جداً.",
        .hi: "स्थानीय रूप से संग्रहीत iPhone/iPad बैकअप। बहुत बड़े हो सकते हैं।",
        .it: "Backup locali di iPhone/iPad. Possono essere molto grandi.",
        .nl: "Lokaal opgeslagen iPhone-/iPad-back-ups. Kunnen erg groot zijn.",
        .tr: "Yerel olarak saklanan iPhone/iPad yedekleri. Çok büyük olabilir.",
    ]) }

    func categoryDescription(for name: String) -> String {
        switch name {
        case "System Cache": return systemCacheDesc
        case "System Logs": return systemLogsDesc
        case "Browser Cache": return browserCacheDesc
        case "Trash": return trashDesc
        case "Xcode": return xcodeDesc
        case "Homebrew": return homebrewDesc
        case "Dev Tools Cache": return devToolsCacheDesc
        case "App Cache": return appCacheDesc
        case "Installers": return installersDesc
        case "iOS Backups": return iosBackupsDesc
        default: return ""
        }
    }

    func categoryLocalizedName(for name: String) -> String {
        switch name {
        case "System Cache": return systemCache
        case "System Logs": return systemLogs
        case "Browser Cache": return browserCache
        case "Trash": return trash
        case "Xcode": return xcode
        case "Homebrew": return homebrew
        case "Dev Tools Cache": return devToolsCache
        case "App Cache": return appCache
        case "Installers": return installers
        case "iOS Backups": return iosBackups
        default: return name
        }
    }

    // MARK: - Dynamic functions
    func scanningModule(_ name: String) -> String {
        let localized = categoryLocalizedName(for: name)
        return t([
            .en: "Scanning \(localized)", .zhHant: "正在掃描 \(localized)", .zhHans: "正在扫描 \(localized)",
            .ja: "\(localized) をスキャン中", .ko: "\(localized) 스캔 중",
            .de: "\(localized) wird gescannt", .es: "Escaneando \(localized)", .fr: "Analyse de \(localized)",
            .pt: "A verificar \(localized)", .ru: "Сканирование \(localized)",
            .ar: "جارٍ فحص \(localized)", .hi: "\(localized) स्कैन हो रहा है",
            .it: "Scansione di \(localized)", .nl: "\(localized) scannen", .tr: "\(localized) taranıyor",
        ])
    }
    func itemsCount(_ count: Int) -> String { t([
        .en: "\(count) items", .zhHant: "\(count) 個項目", .zhHans: "\(count) 个项目",
        .ja: "\(count) 項目", .ko: "\(count)개 항목",
        .de: "\(count) Elemente", .es: "\(count) elementos", .fr: "\(count) éléments",
        .pt: "\(count) itens", .ru: "\(count) элементов",
        .ar: "\(count) عنصر", .hi: "\(count) आइटम",
        .it: "\(count) elementi", .nl: "\(count) items", .tr: "\(count) öğe",
    ]) }
    func itemsSummary(_ count: Int, _ size: String) -> String { t([
        .en: "\(count) items, \(size)", .zhHant: "\(count) 個項目，\(size)", .zhHans: "\(count) 个项目，\(size)",
        .ja: "\(count) 項目、\(size)", .ko: "\(count)개 항목, \(size)",
        .de: "\(count) Elemente, \(size)", .es: "\(count) elementos, \(size)", .fr: "\(count) éléments, \(size)",
        .pt: "\(count) itens, \(size)", .ru: "\(count) элементов, \(size)",
        .ar: "\(count) عنصر، \(size)", .hi: "\(count) आइटम, \(size)",
        .it: "\(count) elementi, \(size)", .nl: "\(count) items, \(size)", .tr: "\(count) öğe, \(size)",
    ]) }
    func willBeRemoved(_ count: Int, _ size: String) -> String { t([
        .en: "\(count) files totaling \(size) will be removed",
        .zhHant: "將移除 \(count) 個檔案，共 \(size)",
        .zhHans: "将移除 \(count) 个文件，共 \(size)",
        .ja: "\(count) 個のファイル（合計 \(size)）が削除されます",
        .ko: "\(count)개 파일, 총 \(size)가 제거됩니다",
        .de: "\(count) Dateien mit insgesamt \(size) werden entfernt",
        .es: "Se eliminarán \(count) archivos con un total de \(size)",
        .fr: "\(count) fichiers totalisant \(size) seront supprimés",
        .pt: "\(count) ficheiros totalizando \(size) serão removidos",
        .ru: "Будет удалено \(count) файлов общим размером \(size)",
        .ar: "سيتم إزالة \(count) ملف بحجم إجمالي \(size)",
        .hi: "\(count) फ़ाइलें कुल \(size) हटाई जाएंगी",
        .it: "\(count) file per un totale di \(size) verranno rimossi",
        .nl: "\(count) bestanden van in totaal \(size) worden verwijderd",
        .tr: "Toplam \(size) boyutunda \(count) dosya kaldırılacak",
    ]) }
    func removingProgress(_ current: Int, _ total: Int) -> String { t([
        .en: "Removing \(current) / \(total)", .zhHant: "正在移除 \(current) / \(total)", .zhHans: "正在移除 \(current) / \(total)",
        .ja: "\(current) / \(total) を削除中", .ko: "\(current) / \(total) 제거 중",
        .de: "Entferne \(current) / \(total)", .es: "Eliminando \(current) / \(total)", .fr: "Suppression \(current) / \(total)",
        .pt: "A remover \(current) / \(total)", .ru: "Удаление \(current) / \(total)",
        .ar: "جارٍ إزالة \(current) / \(total)", .hi: "\(current) / \(total) हटाया जा रहा है",
        .it: "Rimozione \(current) / \(total)", .nl: "Verwijderen \(current) / \(total)", .tr: "\(current) / \(total) kaldırılıyor",
    ]) }
    func restoredCount(_ count: Int) -> String { t([
        .en: "\(count) files restored", .zhHant: "已復原 \(count) 個檔案", .zhHans: "已恢复 \(count) 个文件",
        .ja: "\(count) 個のファイルを復元しました", .ko: "\(count)개 파일 복원됨",
        .de: "\(count) Dateien wiederhergestellt", .es: "\(count) archivos restaurados", .fr: "\(count) fichiers restaurés",
        .pt: "\(count) ficheiros restaurados", .ru: "\(count) файлов восстановлено",
        .ar: "تمت استعادة \(count) ملف", .hi: "\(count) फ़ाइलें पुनर्स्थापित",
        .it: "\(count) file ripristinati", .nl: "\(count) bestanden hersteld", .tr: "\(count) dosya geri yüklendi",
    ]) }
    func freedSpace(_ size: String) -> String { t([
        .en: "Freed \(size)", .zhHant: "已幫你清理出 \(size) 空間", .zhHans: "已释放 \(size) 空间",
        .ja: "\(size) を解放しました", .ko: "\(size) 확보됨",
        .de: "\(size) freigegeben", .es: "\(size) liberados", .fr: "\(size) libérés",
        .pt: "\(size) libertados", .ru: "Освобождено \(size)",
        .ar: "تم تحرير \(size)", .hi: "\(size) मुक्त किया गया",
        .it: "\(size) liberati", .nl: "\(size) vrijgemaakt", .tr: "\(size) boşaltıldı",
    ]) }
    func diskUsed(_ used: String, _ total: String) -> String { t([
        .en: "Used \(used) of \(total)", .zhHant: "已使用 \(used) / \(total)", .zhHans: "已使用 \(used) / \(total)",
        .ja: "\(total) 中 \(used) 使用", .ko: "\(total) 중 \(used) 사용",
        .de: "\(used) von \(total) verwendet", .es: "\(used) de \(total) usados", .fr: "\(used) sur \(total) utilisés",
        .pt: "\(used) de \(total) utilizados", .ru: "Использовано \(used) из \(total)",
        .ar: "مستخدم \(used) من \(total)", .hi: "\(total) में से \(used) उपयोग में",
        .it: "\(used) di \(total) utilizzati", .nl: "\(used) van \(total) gebruikt", .tr: "\(total) üzerinden \(used) kullanılıyor",
    ]) }
    func diskFree(_ free: String) -> String { t([
        .en: "\(free) available", .zhHant: "可用 \(free)", .zhHans: "可用 \(free)",
        .ja: "\(free) 空き", .ko: "\(free) 사용 가능",
        .de: "\(free) verfügbar", .es: "\(free) disponibles", .fr: "\(free) disponibles",
        .pt: "\(free) disponíveis", .ru: "\(free) доступно",
        .ar: "\(free) متاح", .hi: "\(free) उपलब्ध",
        .it: "\(free) disponibili", .nl: "\(free) beschikbaar", .tr: "\(free) kullanılabilir",
    ]) }
    func scannedFiles(_ count: Int) -> String { t([
        .en: "Scanned \(count) files", .zhHant: "已掃描 \(count) 個檔案", .zhHans: "已扫描 \(count) 个文件",
        .ja: "\(count) 個のファイルをスキャン済み", .ko: "\(count)개 파일 스캔됨",
        .de: "\(count) Dateien gescannt", .es: "\(count) archivos escaneados", .fr: "\(count) fichiers analysés",
        .pt: "\(count) ficheiros verificados", .ru: "Просканировано \(count) файлов",
        .ar: "تم فحص \(count) ملف", .hi: "\(count) फ़ाइलें स्कैन की गईं",
        .it: "\(count) file analizzati", .nl: "\(count) bestanden gescand", .tr: "\(count) dosya tarandı",
    ]) }
    func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = currentLanguage.locale
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = currentLanguage.locale
        return formatter.string(from: date)
    }
    func lastUsed(_ date: Date) -> String {
        let relative = relativeDate(date)
        return t([
            .en: "Last used \(relative)", .zhHant: "上次使用於\(relative)", .zhHans: "上次使用于\(relative)",
            .ja: "最終使用: \(relative)", .ko: "마지막 사용: \(relative)",
            .de: "Zuletzt verwendet \(relative)", .es: "Último uso \(relative)", .fr: "Dernière utilisation \(relative)",
            .pt: "Última utilização \(relative)", .ru: "Последнее использование \(relative)",
            .ar: "آخر استخدام \(relative)", .hi: "अंतिम उपयोग \(relative)",
            .it: "Ultimo utilizzo \(relative)", .nl: "Laatst gebruikt \(relative)", .tr: "Son kullanım \(relative)",
        ])
    }

    // MARK: - Dry Run
    var dryRunReport: String { t([
        .en: "Dry Run Report", .zhHant: "試跑報告", .zhHans: "试运行报告", .ja: "ドライランレポート", .ko: "시뮬레이션 보고서",
        .de: "Testlauf-Bericht", .es: "Informe de prueba", .fr: "Rapport de simulation", .pt: "Relatório de simulação", .ru: "Отчёт о пробном запуске",
        .ar: "تقرير التشغيل التجريبي", .hi: "ड्राई रन रिपोर्ट", .it: "Rapporto di simulazione", .nl: "Testrapport", .tr: "Deneme Raporu",
    ]) }
    var reviewChanges: String { t([
        .en: "Review Changes", .zhHant: "檢視變更", .zhHans: "查看变更", .ja: "変更を確認", .ko: "변경 사항 검토",
        .de: "Änderungen prüfen", .es: "Revisar cambios", .fr: "Examiner les modifications", .pt: "Rever alterações", .ru: "Просмотр изменений",
        .ar: "مراجعة التغييرات", .hi: "बदलाव देखें", .it: "Rivedi modifiche", .nl: "Wijzigingen bekijken", .tr: "Değişiklikleri İncele",
    ]) }
    var back: String { t([
        .en: "Back", .zhHant: "返回", .zhHans: "返回", .ja: "戻る", .ko: "뒤로",
        .de: "Zurück", .es: "Atrás", .fr: "Retour", .pt: "Voltar", .ru: "Назад",
        .ar: "رجوع", .hi: "वापस", .it: "Indietro", .nl: "Terug", .tr: "Geri",
    ]) }
    var moveToTrash: String { t([
        .en: "Move to Trash", .zhHant: "移至垃圾桶", .zhHans: "移至废纸篓", .ja: "ゴミ箱に移動", .ko: "휴지통으로 이동",
        .de: "In den Papierkorb legen", .es: "Mover a la Papelera", .fr: "Placer dans la Corbeille", .pt: "Mover para o Lixo", .ru: "Переместить в Корзину",
        .ar: "نقل إلى سلة المهملات", .hi: "ट्रैश में ले जाएं", .it: "Sposta nel Cestino", .nl: "Verplaats naar Prullenmand", .tr: "Çöp Sepetine Taşı",
    ]) }

    // MARK: - Execute
    var movedToTrash: String { t([
        .en: "Simulated Clean", .zhHant: "模擬清除", .zhHans: "模拟清除", .ja: "シミュレーションクリーン", .ko: "시뮬레이션 정리",
        .de: "Simulierte Bereinigung", .es: "Limpieza simulada", .fr: "Nettoyage simulé", .pt: "Limpeza simulada", .ru: "Имитация очистки",
        .ar: "تنظيف تجريبي", .hi: "सिमुलेटेड क्लीन", .it: "Pulizia simulata", .nl: "Gesimuleerd opruimen", .tr: "Simüle Temizlik",
    ]) }
    var movedToTrashDesc: String { t([
        .en: "Confirm everything is fine, then clean up unnecessary files.",
        .zhHant: "確認沒問題即可清除無用檔案。",
        .zhHans: "确认没问题即可清除无用文件。",
        .ja: "問題がないことを確認してから、不要なファイルを削除してください。",
        .ko: "문제가 없는지 확인한 후 불필요한 파일을 정리하세요.",
        .de: "Bestätigen Sie, dass alles in Ordnung ist, und bereinigen Sie dann unnötige Dateien.",
        .es: "Confirme que todo está bien y luego limpie los archivos innecesarios.",
        .fr: "Confirmez que tout est correct, puis nettoyez les fichiers inutiles.",
        .pt: "Confirme que está tudo bem e depois limpe os ficheiros desnecessários.",
        .ru: "Убедитесь, что всё в порядке, затем удалите ненужные файлы.",
        .ar: "تأكد من أن كل شيء على ما يرام، ثم نظف الملفات غير الضرورية.",
        .hi: "सब ठीक है यह पुष्टि करें, फिर अनावश्यक फ़ाइलें साफ़ करें।",
        .it: "Conferma che tutto è in ordine, poi pulisci i file non necessari.",
        .nl: "Bevestig dat alles in orde is en ruim dan onnodige bestanden op.",
        .tr: "Her şeyin yolunda olduğunu onaylayın, ardından gereksiz dosyaları temizleyin.",
    ]) }
    var confirmPermanentDelete: String { t([
        .en: "Confirm Permanent Delete", .zhHant: "確認永久刪除", .zhHans: "确认永久删除", .ja: "完全削除を確認", .ko: "영구 삭제 확인",
        .de: "Endgültiges Löschen bestätigen", .es: "Confirmar eliminación permanente", .fr: "Confirmer la suppression définitive", .pt: "Confirmar eliminação permanente", .ru: "Подтвердить окончательное удаление",
        .ar: "تأكيد الحذف الدائم", .hi: "स्थायी हटाने की पुष्टि करें", .it: "Conferma eliminazione definitiva", .nl: "Definitief verwijderen bevestigen", .tr: "Kalıcı Silmeyi Onayla",
    ]) }
    var restoreAll: String { t([
        .en: "Cancel Delete", .zhHant: "取消刪除", .zhHans: "取消删除", .ja: "削除をキャンセル", .ko: "삭제 취소",
        .de: "Löschen abbrechen", .es: "Cancelar eliminación", .fr: "Annuler la suppression", .pt: "Cancelar eliminação", .ru: "Отменить удаление",
        .ar: "إلغاء الحذف", .hi: "हटाना रद्द करें", .it: "Annulla eliminazione", .nl: "Verwijderen annuleren", .tr: "Silmeyi İptal Et",
    ]) }
    var permanentDeleteDone: String { t([
        .en: "Permanently Deleted", .zhHant: "已永久刪除", .zhHans: "已永久删除", .ja: "完全に削除しました", .ko: "영구 삭제됨",
        .de: "Endgültig gelöscht", .es: "Eliminado permanentemente", .fr: "Supprimé définitivement", .pt: "Eliminado permanentemente", .ru: "Окончательно удалено",
        .ar: "تم الحذف نهائياً", .hi: "स्थायी रूप से हटाया गया", .it: "Eliminato definitivamente", .nl: "Definitief verwijderd", .tr: "Kalıcı Olarak Silindi",
    ]) }
    var restoredDone: String { t([
        .en: "Files Restored", .zhHant: "檔案已復原", .zhHans: "文件已恢复", .ja: "ファイルが復元されました", .ko: "파일 복원됨",
        .de: "Dateien wiederhergestellt", .es: "Archivos restaurados", .fr: "Fichiers restaurés", .pt: "Ficheiros restaurados", .ru: "Файлы восстановлены",
        .ar: "تمت استعادة الملفات", .hi: "फ़ाइलें पुनर्स्थापित", .it: "File ripristinati", .nl: "Bestanden hersteld", .tr: "Dosyalar Geri Yüklendi",
    ]) }
    var cleaningComplete: String { t([
        .en: "Cleaning Complete", .zhHant: "清理完成", .zhHans: "清理完成", .ja: "クリーニング完了", .ko: "정리 완료",
        .de: "Bereinigung abgeschlossen", .es: "Limpieza completada", .fr: "Nettoyage terminé", .pt: "Limpeza concluída", .ru: "Очистка завершена",
        .ar: "اكتمل التنظيف", .hi: "सफ़ाई पूर्ण", .it: "Pulizia completata", .nl: "Opruimen voltooid", .tr: "Temizlik Tamamlandı",
    ]) }
    var spaceFreed: String { t([
        .en: "Space freed", .zhHant: "釋放空間", .zhHans: "释放空间", .ja: "解放した容量", .ko: "확보된 공간",
        .de: "Freigegebener Speicher", .es: "Espacio liberado", .fr: "Espace libéré", .pt: "Espaço libertado", .ru: "Освобождено места",
        .ar: "المساحة المحررة", .hi: "खाली किया गया स्थान", .it: "Spazio liberato", .nl: "Vrijgemaakte ruimte", .tr: "Boşaltılan Alan",
    ]) }
    var filesRemoved: String { t([
        .en: "Files removed", .zhHant: "移除檔案", .zhHans: "移除文件", .ja: "削除したファイル", .ko: "제거된 파일",
        .de: "Entfernte Dateien", .es: "Archivos eliminados", .fr: "Fichiers supprimés", .pt: "Ficheiros removidos", .ru: "Удалено файлов",
        .ar: "الملفات المحذوفة", .hi: "हटाई गई फ़ाइलें", .it: "File rimossi", .nl: "Verwijderde bestanden", .tr: "Kaldırılan Dosyalar",
    ]) }
    var duration: String { t([
        .en: "Duration", .zhHant: "耗時", .zhHans: "耗时", .ja: "所要時間", .ko: "소요 시간",
        .de: "Dauer", .es: "Duración", .fr: "Durée", .pt: "Duração", .ru: "Длительность",
        .ar: "المدة", .hi: "अवधि", .it: "Durata", .nl: "Duur", .tr: "Süre",
    ]) }
    var errors: String { t([
        .en: "Errors", .zhHant: "錯誤", .zhHans: "错误", .ja: "エラー", .ko: "오류",
        .de: "Fehler", .es: "Errores", .fr: "Erreurs", .pt: "Erros", .ru: "Ошибки",
        .ar: "الأخطاء", .hi: "त्रुटियां", .it: "Errori", .nl: "Fouten", .tr: "Hatalar",
    ]) }
    var done: String { t([
        .en: "Done", .zhHant: "完成", .zhHans: "完成", .ja: "完了", .ko: "완료",
        .de: "Fertig", .es: "Hecho", .fr: "Terminé", .pt: "Concluído", .ru: "Готово",
        .ar: "تم", .hi: "हो गया", .it: "Fine", .nl: "Klaar", .tr: "Tamam",
    ]) }

    // MARK: - Disk Usage
    var diskUsage: String { t([
        .en: "Disk Usage", .zhHant: "磁碟用量", .zhHans: "磁盘用量", .ja: "ディスク使用量", .ko: "디스크 사용량",
        .de: "Festplattennutzung", .es: "Uso del disco", .fr: "Utilisation du disque", .pt: "Utilização do disco", .ru: "Использование диска",
        .ar: "استخدام القرص", .hi: "डिस्क उपयोग", .it: "Utilizzo disco", .nl: "Schijfgebruik", .tr: "Disk Kullanımı",
    ]) }

    // MARK: - History
    var noHistory: String { t([
        .en: "No History", .zhHant: "暫無紀錄", .zhHans: "暂无记录", .ja: "履歴なし", .ko: "기록 없음",
        .de: "Kein Verlauf", .es: "Sin historial", .fr: "Aucun historique", .pt: "Sem histórico", .ru: "Нет истории",
        .ar: "لا يوجد سجل", .hi: "कोई इतिहास नहीं", .it: "Nessuna cronologia", .nl: "Geen geschiedenis", .tr: "Geçmiş Yok",
    ]) }
    var historyDescription: String { t([
        .en: "Cleaning history will appear here", .zhHant: "清理紀錄將顯示在這裡", .zhHans: "清理记录将显示在这里", .ja: "クリーニング履歴がここに表示されます", .ko: "정리 기록이 여기에 표시됩니다",
        .de: "Der Bereinigungsverlauf wird hier angezeigt", .es: "El historial de limpieza aparecerá aquí", .fr: "L'historique de nettoyage apparaîtra ici", .pt: "O histórico de limpeza aparecerá aqui", .ru: "Здесь появится история очистки",
        .ar: "سيظهر سجل التنظيف هنا", .hi: "सफ़ाई इतिहास यहां दिखेगा", .it: "La cronologia di pulizia apparirà qui", .nl: "Opruimgeschiedenis verschijnt hier", .tr: "Temizlik geçmişi burada görünecek",
    ]) }
    var clearAll: String { t([
        .en: "Clear All", .zhHant: "清除全部", .zhHans: "清除全部", .ja: "すべてクリア", .ko: "전체 삭제",
        .de: "Alle löschen", .es: "Borrar todo", .fr: "Tout effacer", .pt: "Limpar tudo", .ru: "Очистить всё",
        .ar: "مسح الكل", .hi: "सब साफ़ करें", .it: "Cancella tutto", .nl: "Alles wissen", .tr: "Tümünü Temizle",
    ]) }
    var cleaningDetails: String { t([
        .en: "Cleaning Details", .zhHant: "清理詳情", .zhHans: "清理详情", .ja: "クリーニング詳細", .ko: "정리 상세",
        .de: "Bereinigungsdetails", .es: "Detalles de limpieza", .fr: "Détails du nettoyage", .pt: "Detalhes da limpeza", .ru: "Детали очистки",
        .ar: "تفاصيل التنظيف", .hi: "सफ़ाई विवरण", .it: "Dettagli pulizia", .nl: "Opruimdetails", .tr: "Temizlik Detayları",
    ]) }
    var summary: String { t([
        .en: "Summary", .zhHant: "摘要", .zhHans: "摘要", .ja: "概要", .ko: "요약",
        .de: "Zusammenfassung", .es: "Resumen", .fr: "Résumé", .pt: "Resumo", .ru: "Сводка",
        .ar: "ملخص", .hi: "सारांश", .it: "Riepilogo", .nl: "Samenvatting", .tr: "Özet",
    ]) }
    var date: String { t([
        .en: "Date", .zhHant: "日期", .zhHans: "日期", .ja: "日付", .ko: "날짜",
        .de: "Datum", .es: "Fecha", .fr: "Date", .pt: "Data", .ru: "Дата",
        .ar: "التاريخ", .hi: "तारीख", .it: "Data", .nl: "Datum", .tr: "Tarih",
    ]) }
    var totalCleaned: String { t([
        .en: "Total Cleaned", .zhHant: "清理總量", .zhHans: "清理总量", .ja: "クリーニング合計", .ko: "총 정리량",
        .de: "Insgesamt bereinigt", .es: "Total limpiado", .fr: "Total nettoyé", .pt: "Total limpo", .ru: "Всего очищено",
        .ar: "إجمالي التنظيف", .hi: "कुल सफ़ाई", .it: "Totale pulito", .nl: "Totaal opgeruimd", .tr: "Toplam Temizlenen",
    ]) }
    var categories: String { t([
        .en: "Categories", .zhHant: "分類", .zhHans: "分类", .ja: "カテゴリー", .ko: "카테고리",
        .de: "Kategorien", .es: "Categorías", .fr: "Catégories", .pt: "Categorias", .ru: "Категории",
        .ar: "الفئات", .hi: "श्रेणियां", .it: "Categorie", .nl: "Categorieën", .tr: "Kategoriler",
    ]) }
    var lifetimeStats: String { t([
        .en: "Lifetime Stats", .zhHant: "累計統計", .zhHans: "累计统计", .ja: "累計統計", .ko: "전체 통계",
        .de: "Gesamtstatistiken", .es: "Estadísticas totales", .fr: "Statistiques globales", .pt: "Estatísticas totais", .ru: "Общая статистика",
        .ar: "الإحصائيات الإجمالية", .hi: "समग्र आंकड़े", .it: "Statistiche totali", .nl: "Totaalstatistieken", .tr: "Toplam İstatistikler",
    ]) }
    var totalCleanedAllTime: String { t([
        .en: "Total Cleaned (All Time)", .zhHant: "歷史累計清理量", .zhHans: "历史累计清理量", .ja: "累計クリーニング量", .ko: "전체 정리량",
        .de: "Insgesamt bereinigt (gesamt)", .es: "Total limpiado (histórico)", .fr: "Total nettoyé (historique)", .pt: "Total limpo (histórico)", .ru: "Всего очищено (за всё время)",
        .ar: "إجمالي التنظيف (كل الأوقات)", .hi: "कुल सफ़ाई (सर्वकालिक)", .it: "Totale pulito (storico)", .nl: "Totaal opgeruimd (alle tijd)", .tr: "Toplam Temizlenen (Tüm Zamanlar)",
    ]) }
    var totalSessions: String { t([
        .en: "Cleaning Sessions", .zhHant: "清理次數", .zhHans: "清理次数", .ja: "クリーニング回数", .ko: "정리 횟수",
        .de: "Bereinigungssitzungen", .es: "Sesiones de limpieza", .fr: "Sessions de nettoyage", .pt: "Sessões de limpeza", .ru: "Сеансы очистки",
        .ar: "جلسات التنظيف", .hi: "सफ़ाई सत्र", .it: "Sessioni di pulizia", .nl: "Opruimsessies", .tr: "Temizlik Oturumları",
    ]) }

    // MARK: - Whitelist
    var noWhitelist: String { t([
        .en: "No Whitelist Entries", .zhHant: "白名單為空", .zhHans: "白名单为空", .ja: "ホワイトリストなし", .ko: "화이트리스트 항목 없음",
        .de: "Keine Whitelist-Einträge", .es: "Sin entradas en la lista blanca", .fr: "Aucune entrée dans la liste blanche", .pt: "Sem entradas na lista branca", .ru: "Нет записей в белом списке",
        .ar: "لا توجد إدخالات في القائمة البيضاء", .hi: "श्वेतसूची में कोई प्रविष्टि नहीं", .it: "Nessuna voce nella lista bianca", .nl: "Geen witte-lijstinvoer", .tr: "Beyaz Liste Girişi Yok",
    ]) }
    var whitelistDescription: String { t([
        .en: "Add paths to exclude from scanning", .zhHant: "新增要排除掃描的路徑", .zhHans: "添加要排除扫描的路径", .ja: "スキャンから除外するパスを追加", .ko: "스캔에서 제외할 경로 추가",
        .de: "Pfade zum Ausschließen vom Scan hinzufügen", .es: "Agregar rutas para excluir del escaneo", .fr: "Ajouter des chemins à exclure de l'analyse", .pt: "Adicionar caminhos para excluir da verificação", .ru: "Добавить пути для исключения из сканирования",
        .ar: "أضف مسارات لاستبعادها من الفحص", .hi: "स्कैन से बाहर रखने के लिए पथ जोड़ें", .it: "Aggiungi percorsi da escludere dalla scansione", .nl: "Voeg paden toe om uit te sluiten van scannen", .tr: "Taramadan hariç tutulacak yollar ekleyin",
    ]) }
    var addWhitelistEntry: String { t([
        .en: "Add Whitelist Entry", .zhHant: "新增白名單項目", .zhHans: "添加白名单项目", .ja: "ホワイトリストに追加", .ko: "화이트리스트 항목 추가",
        .de: "Whitelist-Eintrag hinzufügen", .es: "Agregar entrada a la lista blanca", .fr: "Ajouter une entrée à la liste blanche", .pt: "Adicionar entrada à lista branca", .ru: "Добавить запись в белый список",
        .ar: "إضافة إدخال للقائمة البيضاء", .hi: "श्वेतसूची प्रविष्टि जोड़ें", .it: "Aggiungi voce alla lista bianca", .nl: "Witte-lijstinvoer toevoegen", .tr: "Beyaz Liste Girişi Ekle",
    ]) }
    var pathPlaceholder: String { t([
        .en: "Path (e.g. ~/Library/Caches/MyApp)", .zhHant: "路徑（例如 ~/Library/Caches/MyApp）", .zhHans: "路径（例如 ~/Library/Caches/MyApp）", .ja: "パス（例: ~/Library/Caches/MyApp）", .ko: "경로 (예: ~/Library/Caches/MyApp)",
        .de: "Pfad (z.B. ~/Library/Caches/MyApp)", .es: "Ruta (ej. ~/Library/Caches/MyApp)", .fr: "Chemin (ex. ~/Library/Caches/MyApp)", .pt: "Caminho (ex. ~/Library/Caches/MyApp)", .ru: "Путь (напр. ~/Library/Caches/MyApp)",
        .ar: "المسار (مثال ~/Library/Caches/MyApp)", .hi: "पथ (उदा. ~/Library/Caches/MyApp)", .it: "Percorso (es. ~/Library/Caches/MyApp)", .nl: "Pad (bijv. ~/Library/Caches/MyApp)", .tr: "Yol (ör. ~/Library/Caches/MyApp)",
    ]) }
    var notePlaceholder: String { t([
        .en: "Note (optional)", .zhHant: "備註（選填）", .zhHans: "备注（选填）", .ja: "メモ（任意）", .ko: "메모 (선택)",
        .de: "Notiz (optional)", .es: "Nota (opcional)", .fr: "Note (facultatif)", .pt: "Nota (opcional)", .ru: "Заметка (необязательно)",
        .ar: "ملاحظة (اختياري)", .hi: "नोट (वैकल्पिक)", .it: "Nota (facoltativo)", .nl: "Opmerking (optioneel)", .tr: "Not (isteğe bağlı)",
    ]) }
    var cancel: String { t([
        .en: "Cancel", .zhHant: "取消", .zhHans: "取消", .ja: "キャンセル", .ko: "취소",
        .de: "Abbrechen", .es: "Cancelar", .fr: "Annuler", .pt: "Cancelar", .ru: "Отмена",
        .ar: "إلغاء", .hi: "रद्द करें", .it: "Annulla", .nl: "Annuleer", .tr: "İptal",
    ]) }
    var browse: String { t([
        .en: "Browse...", .zhHant: "瀏覽...", .zhHans: "浏览...", .ja: "参照...", .ko: "찾아보기...",
        .de: "Durchsuchen...", .es: "Explorar...", .fr: "Parcourir...", .pt: "Procurar...", .ru: "Обзор...",
        .ar: "تصفح...", .hi: "ब्राउज़ करें...", .it: "Sfoglia...", .nl: "Bladeren...", .tr: "Gözat...",
    ]) }
    var add: String { t([
        .en: "Add", .zhHant: "新增", .zhHans: "添加", .ja: "追加", .ko: "추가",
        .de: "Hinzufügen", .es: "Agregar", .fr: "Ajouter", .pt: "Adicionar", .ru: "Добавить",
        .ar: "إضافة", .hi: "जोड़ें", .it: "Aggiungi", .nl: "Toevoegen", .tr: "Ekle",
    ]) }

    // MARK: - Settings
    var general: String { t([
        .en: "General", .zhHant: "一般", .zhHans: "通用", .ja: "一般", .ko: "일반",
        .de: "Allgemein", .es: "General", .fr: "Général", .pt: "Geral", .ru: "Основные",
        .ar: "عام", .hi: "सामान्य", .it: "Generali", .nl: "Algemeen", .tr: "Genel",
    ]) }
    var permissions: String { t([
        .en: "Permissions", .zhHant: "權限", .zhHans: "权限", .ja: "権限", .ko: "권한",
        .de: "Berechtigungen", .es: "Permisos", .fr: "Autorisations", .pt: "Permissões", .ru: "Разрешения",
        .ar: "الأذونات", .hi: "अनुमतियां", .it: "Permessi", .nl: "Machtigingen", .tr: "İzinler",
    ]) }
    var about: String { t([
        .en: "About", .zhHant: "關於", .zhHans: "关于", .ja: "このアプリについて", .ko: "정보",
        .de: "Über", .es: "Acerca de", .fr: "À propos", .pt: "Sobre", .ru: "О приложении",
        .ar: "حول", .hi: "परिचय", .it: "Informazioni", .nl: "Over", .tr: "Hakkında",
    ]) }
    var version: String { t([
        .en: "Version", .zhHant: "版本", .zhHans: "版本", .ja: "バージョン", .ko: "버전",
        .de: "Version", .es: "Versión", .fr: "Version", .pt: "Versão", .ru: "Версия",
        .ar: "الإصدار", .hi: "संस्करण", .it: "Versione", .nl: "Versie", .tr: "Sürüm",
    ]) }
    var build: String { t([
        .en: "Build", .zhHant: "建置", .zhHans: "构建", .ja: "ビルド", .ko: "빌드",
        .de: "Build", .es: "Compilación", .fr: "Build", .pt: "Compilação", .ru: "Сборка",
        .ar: "البناء", .hi: "बिल्ड", .it: "Build", .nl: "Build", .tr: "Derleme",
    ]) }
    var language: String { t([
        .en: "Language", .zhHant: "語言", .zhHans: "语言", .ja: "言語", .ko: "언어",
        .de: "Sprache", .es: "Idioma", .fr: "Langue", .pt: "Idioma", .ru: "Язык",
        .ar: "اللغة", .hi: "भाषा", .it: "Lingua", .nl: "Taal", .tr: "Dil",
    ]) }
    var fullDiskAccess: String { t([
        .en: "Full Disk Access", .zhHant: "完整磁碟取用權限", .zhHans: "完全磁盘访问权限", .ja: "フルディスクアクセス", .ko: "전체 디스크 접근",
        .de: "Voller Festplattenzugriff", .es: "Acceso completo al disco", .fr: "Accès complet au disque", .pt: "Acesso total ao disco", .ru: "Полный доступ к диску",
        .ar: "الوصول الكامل للقرص", .hi: "पूर्ण डिस्क एक्सेस", .it: "Accesso completo al disco", .nl: "Volledige schijftoegang", .tr: "Tam Disk Erişimi",
    ]) }
    var fdaGranted: String { t([
        .en: "Full Disk Access granted", .zhHant: "已授予完整磁碟取用權限", .zhHans: "已授予完全磁盘访问权限", .ja: "フルディスクアクセスが許可されました", .ko: "전체 디스크 접근 허용됨",
        .de: "Voller Festplattenzugriff gewährt", .es: "Acceso completo al disco concedido", .fr: "Accès complet au disque accordé", .pt: "Acesso total ao disco concedido", .ru: "Полный доступ к диску предоставлен",
        .ar: "تم منح الوصول الكامل للقرص", .hi: "पूर्ण डिस्क एक्सेस दी गई", .it: "Accesso completo al disco concesso", .nl: "Volledige schijftoegang verleend", .tr: "Tam Disk Erişimi verildi",
    ]) }
    var fdaNotDetected: String { t([
        .en: "Full Disk Access not detected", .zhHant: "未偵測到完整磁碟取用權限", .zhHans: "未检测到完全磁盘访问权限", .ja: "フルディスクアクセスが検出されません", .ko: "전체 디스크 접근이 감지되지 않음",
        .de: "Voller Festplattenzugriff nicht erkannt", .es: "Acceso completo al disco no detectado", .fr: "Accès complet au disque non détecté", .pt: "Acesso total ao disco não detetado", .ru: "Полный доступ к диску не обнаружен",
        .ar: "لم يتم اكتشاف الوصول الكامل للقرص", .hi: "पूर्ण डिस्क एक्सेस का पता नहीं चला", .it: "Accesso completo al disco non rilevato", .nl: "Volledige schijftoegang niet gedetecteerd", .tr: "Tam Disk Erişimi algılanmadı",
    ]) }
    var fdaExplanation: String { t([
        .en: "Maclean needs Full Disk Access to scan all system caches and logs.",
        .zhHant: "Maclean 需要完整磁碟取用權限才能掃描所有系統快取和日誌。",
        .zhHans: "Maclean 需要完全磁盘访问权限才能扫描所有系统缓存和日志。",
        .ja: "Macleanがすべてのシステムキャッシュとログをスキャンするにはフルディスクアクセスが必要です。",
        .ko: "Maclean이 모든 시스템 캐시와 로그를 스캔하려면 전체 디스크 접근이 필요합니다.",
        .de: "Maclean benötigt vollen Festplattenzugriff, um alle System-Caches und Protokolle zu scannen.",
        .es: "Maclean necesita Acceso completo al disco para escanear todos los cachés y registros del sistema.",
        .fr: "Maclean a besoin de l'Accès complet au disque pour analyser tous les caches et journaux système.",
        .pt: "Maclean precisa de Acesso total ao disco para verificar todos os caches e registos do sistema.",
        .ru: "Maclean нужен Полный доступ к диску для сканирования всех системных кэшей и журналов.",
        .ar: "يحتاج Maclean إلى الوصول الكامل للقرص لفحص جميع ذاكرات التخزين المؤقت وسجلات النظام.",
        .hi: "Maclean को सभी सिस्टम कैश और लॉग स्कैन करने के लिए पूर्ण डिस्क एक्सेस चाहिए।",
        .it: "Maclean necessita dell'Accesso completo al disco per scansionare tutte le cache e i registri di sistema.",
        .nl: "Maclean heeft Volledige schijftoegang nodig om alle systeemcaches en logboeken te scannen.",
        .tr: "Maclean'in tüm sistem önbelleklerini ve günlüklerini taraması için Tam Disk Erişimi gereklidir.",
    ]) }
    var openSystemSettings: String { t([
        .en: "Open System Settings", .zhHant: "開啟系統設定", .zhHans: "打开系统设置", .ja: "システム設定を開く", .ko: "시스템 설정 열기",
        .de: "Systemeinstellungen öffnen", .es: "Abrir Ajustes del Sistema", .fr: "Ouvrir les Réglages Système", .pt: "Abrir Definições do Sistema", .ru: "Открыть Системные настройки",
        .ar: "فتح إعدادات النظام", .hi: "सिस्टम सेटिंग्स खोलें", .it: "Apri Impostazioni di Sistema", .nl: "Open Systeeminstellingen", .tr: "Sistem Ayarlarını Aç",
    ]) }
    var refresh: String { t([
        .en: "Refresh", .zhHant: "重新整理", .zhHans: "刷新", .ja: "更新", .ko: "새로고침",
        .de: "Aktualisieren", .es: "Actualizar", .fr: "Actualiser", .pt: "Atualizar", .ru: "Обновить",
        .ar: "تحديث", .hi: "रिफ़्रेश", .it: "Aggiorna", .nl: "Vernieuwen", .tr: "Yenile",
    ]) }

    // MARK: - FDA Prompt
    var fdaRecommended: String { t([
        .en: "Full Disk Access Recommended", .zhHant: "建議授予完整磁碟取用權限", .zhHans: "建议授予完全磁盘访问权限", .ja: "フルディスクアクセスを推奨", .ko: "전체 디스크 접근 권장",
        .de: "Voller Festplattenzugriff empfohlen", .es: "Se recomienda Acceso completo al disco", .fr: "Accès complet au disque recommandé", .pt: "Acesso total ao disco recomendado", .ru: "Рекомендуется Полный доступ к диску",
        .ar: "يوصى بالوصول الكامل للقرص", .hi: "पूर्ण डिस्क एक्सेस अनुशंसित", .it: "Accesso completo al disco consigliato", .nl: "Volledige schijftoegang aanbevolen", .tr: "Tam Disk Erişimi Önerilir",
    ]) }
    var fdaPromptDesc: String { t([
        .en: "Maclean works best with Full Disk Access. Without it, some caches and logs may not be accessible.",
        .zhHant: "授予完整磁碟取用權限後 Maclean 才能發揮最佳效果。否則部分快取和日誌可能無法存取。",
        .zhHans: "授予完全磁盘访问权限后 Maclean 才能发挥最佳效果。否则部分缓存和日志可能无法访问。",
        .ja: "Macleanはフルディスクアクセスで最も効果を発揮します。なければ一部のキャッシュやログにアクセスできない場合があります。",
        .ko: "Maclean은 전체 디스크 접근 권한이 있을 때 가장 잘 작동합니다. 없으면 일부 캐시와 로그에 접근할 수 없을 수 있습니다.",
        .de: "Maclean funktioniert am besten mit vollem Festplattenzugriff. Ohne ihn sind einige Caches und Protokolle möglicherweise nicht zugänglich.",
        .es: "Maclean funciona mejor con Acceso completo al disco. Sin él, algunos cachés y registros pueden no ser accesibles.",
        .fr: "Maclean fonctionne au mieux avec l'Accès complet au disque. Sans cela, certains caches et journaux peuvent ne pas être accessibles.",
        .pt: "Maclean funciona melhor com Acesso total ao disco. Sem ele, alguns caches e registos podem não ser acessíveis.",
        .ru: "Maclean лучше всего работает с Полным доступом к диску. Без него некоторые кэши и журналы могут быть недоступны.",
        .ar: "يعمل Maclean بشكل أفضل مع الوصول الكامل للقرص. بدونه، قد لا يمكن الوصول إلى بعض ذاكرات التخزين المؤقت والسجلات.",
        .hi: "Maclean पूर्ण डिस्क एक्सेस के साथ सबसे अच्छा काम करता है। इसके बिना कुछ कैश और लॉग एक्सेस योग्य नहीं हो सकते।",
        .it: "Maclean funziona al meglio con l'Accesso completo al disco. Senza, alcune cache e registri potrebbero non essere accessibili.",
        .nl: "Maclean werkt het beste met Volledige schijftoegang. Zonder kan sommige cache en logboeken niet toegankelijk zijn.",
        .tr: "Maclean, Tam Disk Erişimi ile en iyi şekilde çalışır. Bu olmadan bazı önbellekler ve günlükler erişilemeyebilir.",
    ]) }
    var howToEnable: String { t([
        .en: "How to enable:", .zhHant: "啟用方式：", .zhHans: "启用方式：", .ja: "有効にする方法：", .ko: "활성화 방법:",
        .de: "So aktivieren Sie es:", .es: "Cómo activar:", .fr: "Comment activer :", .pt: "Como ativar:", .ru: "Как включить:",
        .ar: "كيفية التفعيل:", .hi: "सक्षम कैसे करें:", .it: "Come abilitare:", .nl: "Hoe in te schakelen:", .tr: "Nasıl etkinleştirilir:",
    ]) }
    var fdaStep1: String { t([
        .en: "Open System Settings", .zhHant: "開啟系統設定", .zhHans: "打开系统设置", .ja: "システム設定を開く", .ko: "시스템 설정 열기",
        .de: "Systemeinstellungen öffnen", .es: "Abrir Ajustes del Sistema", .fr: "Ouvrir les Réglages Système", .pt: "Abrir Definições do Sistema", .ru: "Откройте Системные настройки",
        .ar: "افتح إعدادات النظام", .hi: "सिस्टम सेटिंग्स खोलें", .it: "Apri Impostazioni di Sistema", .nl: "Open Systeeminstellingen", .tr: "Sistem Ayarlarını Açın",
    ]) }
    var fdaStep2: String { t([
        .en: "Go to Privacy & Security → Full Disk Access", .zhHant: "前往隱私權與安全性 → 完整磁碟取用權限", .zhHans: "前往隐私与安全性 → 完全磁盘访问权限", .ja: "プライバシーとセキュリティ → フルディスクアクセスへ移動", .ko: "개인 정보 보호 및 보안 → 전체 디스크 접근으로 이동",
        .de: "Gehen Sie zu Datenschutz & Sicherheit → Voller Festplattenzugriff", .es: "Vaya a Privacidad y Seguridad → Acceso completo al disco", .fr: "Allez dans Confidentialité et sécurité → Accès complet au disque", .pt: "Vá a Privacidade e Segurança → Acesso total ao disco", .ru: "Перейдите в Конфиденциальность и безопасность → Полный доступ к диску",
        .ar: "انتقل إلى الخصوصية والأمان → الوصول الكامل للقرص", .hi: "गोपनीयता और सुरक्षा → पूर्ण डिस्क एक्सेस पर जाएं", .it: "Vai a Privacy e Sicurezza → Accesso completo al disco", .nl: "Ga naar Privacy en beveiliging → Volledige schijftoegang", .tr: "Gizlilik ve Güvenlik → Tam Disk Erişimi'ne gidin",
    ]) }
    var fdaStep3: String { t([
        .en: "Enable Maclean", .zhHant: "啟用 Maclean", .zhHans: "启用 Maclean", .ja: "Macleanを有効にする", .ko: "Maclean 활성화",
        .de: "Maclean aktivieren", .es: "Activar Maclean", .fr: "Activer Maclean", .pt: "Ativar Maclean", .ru: "Включите Maclean",
        .ar: "تفعيل Maclean", .hi: "Maclean सक्षम करें", .it: "Abilita Maclean", .nl: "Schakel Maclean in", .tr: "Maclean'i etkinleştirin",
    ]) }
    var later: String { t([
        .en: "Later", .zhHant: "稍後", .zhHans: "稍后", .ja: "後で", .ko: "나중에",
        .de: "Später", .es: "Más tarde", .fr: "Plus tard", .pt: "Mais tarde", .ru: "Позже",
        .ar: "لاحقاً", .hi: "बाद में", .it: "Più tardi", .nl: "Later", .tr: "Sonra",
    ]) }

    // MARK: - App Manager
    var appManager: String { t([
        .en: "App Manager", .zhHant: "應用管理", .zhHans: "应用管理", .ja: "アプリマネージャー", .ko: "앱 관리자",
        .de: "App-Manager", .es: "Gestor de apps", .fr: "Gestionnaire d'apps", .pt: "Gestor de apps", .ru: "Менеджер приложений",
        .ar: "مدير التطبيقات", .hi: "ऐप प्रबंधक", .it: "Gestore app", .nl: "App-beheer", .tr: "Uygulama Yöneticisi",
    ]) }
    var appManagerDesc: String { t([
        .en: "Scan for apps unused over 90 days and remove them along with leftover data.",
        .zhHant: "掃描超過 90 天未使用的應用程式，可連同殘留資料一起移除。",
        .zhHans: "扫描超过 90 天未使用的应用程序，可连同残留数据一起移除。",
        .ja: "90日以上未使用のアプリをスキャンし、残留データとともに削除します。",
        .ko: "90일 이상 사용하지 않은 앱을 스캔하고 잔여 데이터와 함께 제거합니다.",
        .de: "Nach Apps suchen, die über 90 Tage nicht benutzt wurden, und diese samt Restdaten entfernen.",
        .es: "Buscar apps sin usar durante más de 90 días y eliminarlas junto con datos residuales.",
        .fr: "Rechercher les apps inutilisées depuis plus de 90 jours et les supprimer avec leurs données résiduelles.",
        .pt: "Procurar apps não utilizadas há mais de 90 dias e removê-las juntamente com dados residuais.",
        .ru: "Поиск приложений, не используемых более 90 дней, и удаление их вместе с остаточными данными.",
        .ar: "البحث عن التطبيقات غير المستخدمة لأكثر من 90 يوماً وإزالتها مع البيانات المتبقية.",
        .hi: "90 दिनों से अधिक समय से अप्रयुक्त ऐप्स स्कैन करें और बचे हुए डेटा के साथ हटाएं।",
        .it: "Cerca app inutilizzate da oltre 90 giorni e rimuovile insieme ai dati residui.",
        .nl: "Scan apps die meer dan 90 dagen niet zijn gebruikt en verwijder ze samen met achtergebleven gegevens.",
        .tr: "90 günden fazla kullanılmayan uygulamaları tarayın ve kalan verilerle birlikte kaldırın.",
    ]) }
    var scanningApps: String { t([
        .en: "Scanning Applications", .zhHant: "正在掃描應用程式", .zhHans: "正在扫描应用程序", .ja: "アプリケーションをスキャン中", .ko: "애플리케이션 스캔 중",
        .de: "Anwendungen werden gescannt", .es: "Escaneando aplicaciones", .fr: "Analyse des applications", .pt: "A verificar aplicações", .ru: "Сканирование приложений",
        .ar: "جارٍ فحص التطبيقات", .hi: "ऐप्स स्कैन हो रहे हैं", .it: "Scansione applicazioni", .nl: "Apps scannen", .tr: "Uygulamalar Taranıyor",
    ]) }
    var noIdleApps: String { t([
        .en: "No Idle Apps Found", .zhHant: "沒有找到閒置應用程式", .zhHans: "没有找到闲置应用程序", .ja: "アイドル状態のアプリなし", .ko: "유휴 앱 없음",
        .de: "Keine ungenutzten Apps gefunden", .es: "No se encontraron apps inactivas", .fr: "Aucune app inactive trouvée", .pt: "Nenhuma app inativa encontrada", .ru: "Неиспользуемые приложения не найдены",
        .ar: "لم يتم العثور على تطبيقات غير مستخدمة", .hi: "कोई निष्क्रिय ऐप नहीं मिला", .it: "Nessuna app inattiva trovata", .nl: "Geen ongebruikte apps gevonden", .tr: "Kullanılmayan Uygulama Bulunamadı",
    ]) }
    var noIdleAppsDesc: String { t([
        .en: "All your apps have been used within the last 90 days.",
        .zhHant: "所有應用程式都在過去 90 天內使用過。",
        .zhHans: "所有应用程序都在过去 90 天内使用过。",
        .ja: "すべてのアプリは過去90日以内に使用されています。",
        .ko: "모든 앱이 지난 90일 이내에 사용되었습니다.",
        .de: "Alle Ihre Apps wurden in den letzten 90 Tagen verwendet.",
        .es: "Todas sus apps se han utilizado en los últimos 90 días.",
        .fr: "Toutes vos apps ont été utilisées au cours des 90 derniers jours.",
        .pt: "Todas as suas apps foram utilizadas nos últimos 90 dias.",
        .ru: "Все ваши приложения использовались в течение последних 90 дней.",
        .ar: "تم استخدام جميع تطبيقاتك خلال الـ 90 يوماً الماضية.",
        .hi: "आपके सभी ऐप्स पिछले 90 दिनों में उपयोग किए गए हैं।",
        .it: "Tutte le tue app sono state utilizzate negli ultimi 90 giorni.",
        .nl: "Al je apps zijn in de afgelopen 90 dagen gebruikt.",
        .tr: "Tüm uygulamalarınız son 90 gün içinde kullanılmış.",
    ]) }
    var neverUsed: String { t([
        .en: "Never used", .zhHant: "從未使用", .zhHans: "从未使用", .ja: "未使用", .ko: "사용한 적 없음",
        .de: "Nie verwendet", .es: "Nunca usado", .fr: "Jamais utilisé", .pt: "Nunca utilizado", .ru: "Никогда не использовалось",
        .ar: "لم يُستخدم أبداً", .hi: "कभी उपयोग नहीं किया", .it: "Mai utilizzata", .nl: "Nooit gebruikt", .tr: "Hiç kullanılmadı",
    ]) }
    var includeAppData: String { t([
        .en: "Include application data", .zhHant: "包含應用程式資料", .zhHans: "包含应用程序数据", .ja: "アプリケーションデータを含む", .ko: "앱 데이터 포함",
        .de: "Anwendungsdaten einschließen", .es: "Incluir datos de la aplicación", .fr: "Inclure les données de l'application", .pt: "Incluir dados da aplicação", .ru: "Включить данные приложения",
        .ar: "تضمين بيانات التطبيق", .hi: "ऐप डेटा शामिल करें", .it: "Includi dati dell'applicazione", .nl: "App-gegevens opnemen", .tr: "Uygulama verilerini dahil et",
    ]) }
    var noAssociatedData: String { t([
        .en: "No associated data found", .zhHant: "沒有找到關聯資料", .zhHans: "没有找到关联数据", .ja: "関連データが見つかりません", .ko: "관련 데이터 없음",
        .de: "Keine zugehörigen Daten gefunden", .es: "No se encontraron datos asociados", .fr: "Aucune donnée associée trouvée", .pt: "Nenhum dado associado encontrado", .ru: "Связанные данные не найдены",
        .ar: "لم يتم العثور على بيانات مرتبطة", .hi: "कोई संबंधित डेटा नहीं मिला", .it: "Nessun dato associato trovato", .nl: "Geen gekoppelde gegevens gevonden", .tr: "İlişkili veri bulunamadı",
    ]) }
    var selectAll: String { t([
        .en: "Select All", .zhHant: "全選", .zhHans: "全选", .ja: "すべて選択", .ko: "전체 선택",
        .de: "Alle auswählen", .es: "Seleccionar todo", .fr: "Tout sélectionner", .pt: "Selecionar tudo", .ru: "Выбрать всё",
        .ar: "تحديد الكل", .hi: "सभी चुनें", .it: "Seleziona tutto", .nl: "Alles selecteren", .tr: "Tümünü Seç",
    ]) }
    var deselectAll: String { t([
        .en: "Deselect All", .zhHant: "取消全選", .zhHans: "取消全选", .ja: "すべて解除", .ko: "전체 선택 해제",
        .de: "Alle abwählen", .es: "Deseleccionar todo", .fr: "Tout désélectionner", .pt: "Desselecionar tudo", .ru: "Снять всё",
        .ar: "إلغاء تحديد الكل", .hi: "सभी अचयनित करें", .it: "Deseleziona tutto", .nl: "Alles deselecteren", .tr: "Tümünün Seçimini Kaldır",
    ]) }
    var cleanApps: String { t([
        .en: "Clean Apps", .zhHant: "清理應用", .zhHans: "清理应用", .ja: "アプリをクリーン", .ko: "앱 정리",
        .de: "Apps bereinigen", .es: "Limpiar apps", .fr: "Nettoyer les apps", .pt: "Limpar apps", .ru: "Очистить приложения",
        .ar: "تنظيف التطبيقات", .hi: "ऐप्स साफ़ करें", .it: "Pulisci app", .nl: "Apps opruimen", .tr: "Uygulamaları Temizle",
    ]) }
    var appsRemoved: String { t([
        .en: "Apps Removed", .zhHant: "應用程式已移除", .zhHans: "应用程序已移除", .ja: "アプリが削除されました", .ko: "앱 제거됨",
        .de: "Apps entfernt", .es: "Apps eliminadas", .fr: "Apps supprimées", .pt: "Apps removidas", .ru: "Приложения удалены",
        .ar: "تمت إزالة التطبيقات", .hi: "ऐप्स हटाए गए", .it: "App rimosse", .nl: "Apps verwijderd", .tr: "Uygulamalar Kaldırıldı",
    ]) }
    var appsRemovedCount: String { t([
        .en: "Apps removed", .zhHant: "移除應用程式", .zhHans: "移除应用程序", .ja: "削除したアプリ", .ko: "제거된 앱",
        .de: "Entfernte Apps", .es: "Apps eliminadas", .fr: "Apps supprimées", .pt: "Apps removidas", .ru: "Удалено приложений",
        .ar: "التطبيقات المحذوفة", .hi: "हटाए गए ऐप्स", .it: "App rimosse", .nl: "Verwijderde apps", .tr: "Kaldırılan Uygulamalar",
    ]) }
    var rescan: String { t([
        .en: "Scan Again", .zhHant: "重新掃描", .zhHans: "重新扫描", .ja: "再スキャン", .ko: "다시 스캔",
        .de: "Erneut scannen", .es: "Escanear de nuevo", .fr: "Analyser à nouveau", .pt: "Verificar novamente", .ru: "Сканировать снова",
        .ar: "فحص مرة أخرى", .hi: "फिर से स्कैन करें", .it: "Scansiona di nuovo", .nl: "Opnieuw scannen", .tr: "Tekrar Tara",
    ]) }

    // MARK: - Project Cleanup
    var projectCleanup: String { t([
        .en: "Project Cleanup", .zhHant: "專案清理", .zhHans: "项目清理", .ja: "プロジェクトクリーンアップ", .ko: "프로젝트 정리",
        .de: "Projektbereinigung", .es: "Limpieza de proyectos", .fr: "Nettoyage de projets", .pt: "Limpeza de projetos", .ru: "Очистка проектов",
        .ar: "تنظيف المشاريع", .hi: "प्रोजेक्ट क्लीनअप", .it: "Pulizia progetti", .nl: "Projectopruiming", .tr: "Proje Temizliği",
    ]) }
    var projectCleanupDesc: String { t([
        .en: "Scan for build artifacts like node_modules, build, target, dist in your projects.",
        .zhHant: "掃描專案中的建置產物，如 node_modules、build、target、dist。",
        .zhHans: "扫描项目中的构建产物，如 node_modules、build、target、dist。",
        .ja: "プロジェクト内のnode_modules、build、target、distなどのビルド成果物をスキャンします。",
        .ko: "프로젝트에서 node_modules, build, target, dist 등의 빌드 산출물을 스캔합니다.",
        .de: "Nach Build-Artefakten wie node_modules, build, target, dist in Ihren Projekten suchen.",
        .es: "Buscar artefactos de compilación como node_modules, build, target, dist en sus proyectos.",
        .fr: "Rechercher des artefacts de build comme node_modules, build, target, dist dans vos projets.",
        .pt: "Procurar artefatos de compilação como node_modules, build, target, dist nos seus projetos.",
        .ru: "Поиск артефактов сборки, таких как node_modules, build, target, dist в ваших проектах.",
        .ar: "البحث عن مخرجات البناء مثل node_modules وbuild وtarget وdist في مشاريعك.",
        .hi: "अपने प्रोजेक्ट्स में node_modules, build, target, dist जैसे बिल्ड आर्टिफ़ैक्ट स्कैन करें।",
        .it: "Cerca artefatti di compilazione come node_modules, build, target, dist nei tuoi progetti.",
        .nl: "Scan bouw-artefacten zoals node_modules, build, target, dist in je projecten.",
        .tr: "Projelerinizde node_modules, build, target, dist gibi derleme çıktılarını tarayın.",
    ]) }
    var scanningProjects: String { t([
        .en: "Scanning Projects", .zhHant: "正在掃描專案", .zhHans: "正在扫描项目", .ja: "プロジェクトをスキャン中", .ko: "프로젝트 스캔 중",
        .de: "Projekte werden gescannt", .es: "Escaneando proyectos", .fr: "Analyse des projets", .pt: "A verificar projetos", .ru: "Сканирование проектов",
        .ar: "جارٍ فحص المشاريع", .hi: "प्रोजेक्ट स्कैन हो रहे हैं", .it: "Scansione progetti", .nl: "Projecten scannen", .tr: "Projeler Taranıyor",
    ]) }
    var noArtifacts: String { t([
        .en: "No Build Artifacts Found", .zhHant: "沒有找到建置產物", .zhHans: "没有找到构建产物", .ja: "ビルド成果物が見つかりません", .ko: "빌드 산출물 없음",
        .de: "Keine Build-Artefakte gefunden", .es: "No se encontraron artefactos de compilación", .fr: "Aucun artefact de build trouvé", .pt: "Nenhum artefato de compilação encontrado", .ru: "Артефакты сборки не найдены",
        .ar: "لم يتم العثور على مخرجات بناء", .hi: "कोई बिल्ड आर्टिफ़ैक्ट नहीं मिला", .it: "Nessun artefatto di compilazione trovato", .nl: "Geen bouw-artefacten gevonden", .tr: "Derleme Çıktısı Bulunamadı",
    ]) }
    var noArtifactsDesc: String { t([
        .en: "No cleanable build artifacts were found in your project directories.",
        .zhHant: "在專案目錄中沒有找到可清理的建置產物。",
        .zhHans: "在项目目录中没有找到可清理的构建产物。",
        .ja: "プロジェクトディレクトリにクリーン可能なビルド成果物が見つかりませんでした。",
        .ko: "프로젝트 디렉토리에서 정리 가능한 빌드 산출물이 발견되지 않았습니다.",
        .de: "In Ihren Projektverzeichnissen wurden keine bereinigbaren Build-Artefakte gefunden.",
        .es: "No se encontraron artefactos de compilación limpiables en sus directorios de proyectos.",
        .fr: "Aucun artefact de build nettoyable trouvé dans vos répertoires de projets.",
        .pt: "Não foram encontrados artefatos de compilação para limpar nos seus diretórios de projetos.",
        .ru: "В каталогах ваших проектов не найдено очищаемых артефактов сборки.",
        .ar: "لم يتم العثور على مخرجات بناء قابلة للتنظيف في مجلدات مشاريعك.",
        .hi: "आपकी प्रोजेक्ट डायरेक्टरी में कोई सफ़ाई योग्य बिल्ड आर्टिफ़ैक्ट नहीं मिला।",
        .it: "Non sono stati trovati artefatti di compilazione eliminabili nelle directory dei progetti.",
        .nl: "Er zijn geen opruimbare bouw-artefacten gevonden in je projectmappen.",
        .tr: "Proje dizinlerinizde temizlenebilir derleme çıktısı bulunamadı.",
    ]) }
    var cleanProjects: String { t([
        .en: "Clean Projects", .zhHant: "清理專案", .zhHans: "清理项目", .ja: "プロジェクトをクリーン", .ko: "프로젝트 정리",
        .de: "Projekte bereinigen", .es: "Limpiar proyectos", .fr: "Nettoyer les projets", .pt: "Limpar projetos", .ru: "Очистить проекты",
        .ar: "تنظيف المشاريع", .hi: "प्रोजेक्ट साफ़ करें", .it: "Pulisci progetti", .nl: "Projecten opruimen", .tr: "Projeleri Temizle",
    ]) }
    var chooseScanRoot: String { t([
        .en: "Choose Folders to Scan", .zhHant: "選擇要掃描的資料夾", .zhHans: "选择要扫描的文件夹", .ja: "スキャンするフォルダを選択", .ko: "스캔할 폴더 선택",
        .de: "Zu scannende Ordner auswählen", .es: "Elegir carpetas para escanear", .fr: "Choisir les dossiers à analyser", .pt: "Escolher pastas para verificar", .ru: "Выберите папки для сканирования",
        .ar: "اختر المجلدات للفحص", .hi: "स्कैन करने के लिए फ़ोल्डर चुनें", .it: "Scegli cartelle da scansionare", .nl: "Kies mappen om te scannen", .tr: "Taranacak Klasörleri Seçin",
    ]) }
    var addFolder: String { t([
        .en: "Add Folder", .zhHant: "新增資料夾", .zhHans: "添加文件夹", .ja: "フォルダを追加", .ko: "폴더 추가",
        .de: "Ordner hinzufügen", .es: "Agregar carpeta", .fr: "Ajouter un dossier", .pt: "Adicionar pasta", .ru: "Добавить папку",
        .ar: "إضافة مجلد", .hi: "फ़ोल्डर जोड़ें", .it: "Aggiungi cartella", .nl: "Map toevoegen", .tr: "Klasör Ekle",
    ]) }
    var artifactType: String { t([
        .en: "Type", .zhHant: "類型", .zhHans: "类型", .ja: "タイプ", .ko: "유형",
        .de: "Typ", .es: "Tipo", .fr: "Type", .pt: "Tipo", .ru: "Тип",
        .ar: "النوع", .hi: "प्रकार", .it: "Tipo", .nl: "Type", .tr: "Tür",
    ]) }
    var lastModified: String { t([
        .en: "Last Modified", .zhHant: "最後修改", .zhHans: "最后修改", .ja: "最終更新", .ko: "마지막 수정",
        .de: "Zuletzt geändert", .es: "Última modificación", .fr: "Dernière modification", .pt: "Última modificação", .ru: "Последнее изменение",
        .ar: "آخر تعديل", .hi: "अंतिम संशोधन", .it: "Ultima modifica", .nl: "Laatst gewijzigd", .tr: "Son Değişiklik",
    ]) }
    var projectsCleaned: String { t([
        .en: "Projects Cleaned", .zhHant: "專案已清理", .zhHans: "项目已清理", .ja: "プロジェクトがクリーンされました", .ko: "프로젝트 정리됨",
        .de: "Projekte bereinigt", .es: "Proyectos limpiados", .fr: "Projets nettoyés", .pt: "Projetos limpos", .ru: "Проекты очищены",
        .ar: "تم تنظيف المشاريع", .hi: "प्रोजेक्ट साफ़ किए गए", .it: "Progetti puliti", .nl: "Projecten opgeruimd", .tr: "Projeler Temizlendi",
    ]) }

    // MARK: - Disk Analyzer
    var diskAnalyzer: String { t([
        .en: "Disk Analyzer", .zhHant: "磁碟分析", .zhHans: "磁盘分析", .ja: "ディスクアナライザー", .ko: "디스크 분석기",
        .de: "Festplattenanalyse", .es: "Analizador de disco", .fr: "Analyseur de disque", .pt: "Analisador de disco", .ru: "Анализатор диска",
        .ar: "محلل القرص", .hi: "डिस्क विश्लेषक", .it: "Analizzatore disco", .nl: "Schijfanalyse", .tr: "Disk Analizcisi",
    ]) }
    var diskAnalyzerDesc: String { t([
        .en: "Find the largest files on your disk.",
        .zhHant: "找出磁碟上佔用空間最多的檔案。",
        .zhHans: "查找磁盘上占用空间最多的文件。",
        .ja: "ディスク上の最大のファイルを検索します。",
        .ko: "디스크에서 가장 큰 파일을 찾습니다.",
        .de: "Finden Sie die größten Dateien auf Ihrer Festplatte.",
        .es: "Encuentre los archivos más grandes en su disco.",
        .fr: "Trouvez les fichiers les plus volumineux sur votre disque.",
        .pt: "Encontre os maiores ficheiros no seu disco.",
        .ru: "Найдите самые большие файлы на вашем диске.",
        .ar: "اعثر على أكبر الملفات على قرصك.",
        .hi: "अपनी डिस्क पर सबसे बड़ी फ़ाइलें खोजें।",
        .it: "Trova i file più grandi sul tuo disco.",
        .nl: "Vind de grootste bestanden op je schijf.",
        .tr: "Diskinizdeki en büyük dosyaları bulun.",
    ]) }
    var scanningDisk: String { t([
        .en: "Analyzing Disk", .zhHant: "正在分析磁碟", .zhHans: "正在分析磁盘", .ja: "ディスクを分析中", .ko: "디스크 분석 중",
        .de: "Festplatte wird analysiert", .es: "Analizando disco", .fr: "Analyse du disque", .pt: "A analisar disco", .ru: "Анализ диска",
        .ar: "جارٍ تحليل القرص", .hi: "डिस्क विश्लेषण हो रहा है", .it: "Analisi disco", .nl: "Schijf analyseren", .tr: "Disk Analiz Ediliyor",
    ]) }
    var noLargeFiles: String { t([
        .en: "No Large Files Found", .zhHant: "沒有找到大檔案", .zhHans: "没有找到大文件", .ja: "大きなファイルが見つかりません", .ko: "대용량 파일 없음",
        .de: "Keine großen Dateien gefunden", .es: "No se encontraron archivos grandes", .fr: "Aucun gros fichier trouvé", .pt: "Nenhum ficheiro grande encontrado", .ru: "Большие файлы не найдены",
        .ar: "لم يتم العثور على ملفات كبيرة", .hi: "कोई बड़ी फ़ाइल नहीं मिली", .it: "Nessun file di grandi dimensioni trovato", .nl: "Geen grote bestanden gevonden", .tr: "Büyük Dosya Bulunamadı",
    ]) }
    var noLargeFilesDesc: String { t([
        .en: "No files larger than 100 MB were found.",
        .zhHant: "沒有找到大於 100 MB 的檔案。",
        .zhHans: "没有找到大于 100 MB 的文件。",
        .ja: "100 MB以上のファイルは見つかりませんでした。",
        .ko: "100 MB 이상의 파일이 발견되지 않았습니다.",
        .de: "Es wurden keine Dateien größer als 100 MB gefunden.",
        .es: "No se encontraron archivos de más de 100 MB.",
        .fr: "Aucun fichier de plus de 100 Mo trouvé.",
        .pt: "Não foram encontrados ficheiros com mais de 100 MB.",
        .ru: "Файлы размером более 100 МБ не найдены.",
        .ar: "لم يتم العثور على ملفات أكبر من 100 ميغابايت.",
        .hi: "100 MB से बड़ी कोई फ़ाइल नहीं मिली।",
        .it: "Non sono stati trovati file più grandi di 100 MB.",
        .nl: "Er zijn geen bestanden groter dan 100 MB gevonden.",
        .tr: "100 MB'dan büyük dosya bulunamadı.",
    ]) }
    var filterAll: String { t([
        .en: "All", .zhHant: "全部", .zhHans: "全部", .ja: "すべて", .ko: "전체",
        .de: "Alle", .es: "Todos", .fr: "Tous", .pt: "Todos", .ru: "Все",
        .ar: "الكل", .hi: "सभी", .it: "Tutti", .nl: "Alle", .tr: "Tümü",
    ]) }
    var filterVideo: String { t([
        .en: "Videos", .zhHant: "影片", .zhHans: "视频", .ja: "動画", .ko: "동영상",
        .de: "Videos", .es: "Vídeos", .fr: "Vidéos", .pt: "Vídeos", .ru: "Видео",
        .ar: "فيديوهات", .hi: "वीडियो", .it: "Video", .nl: "Video's", .tr: "Videolar",
    ]) }
    var filterArchive: String { t([
        .en: "Archives", .zhHant: "壓縮檔", .zhHans: "压缩文件", .ja: "アーカイブ", .ko: "압축 파일",
        .de: "Archive", .es: "Archivos comprimidos", .fr: "Archives", .pt: "Arquivos", .ru: "Архивы",
        .ar: "أرشيفات", .hi: "संग्रह", .it: "Archivi", .nl: "Archieven", .tr: "Arşivler",
    ]) }
    var filterDiskImage: String { t([
        .en: "Disk Images", .zhHant: "磁碟映像", .zhHans: "磁盘映像", .ja: "ディスクイメージ", .ko: "디스크 이미지",
        .de: "Disk-Images", .es: "Imágenes de disco", .fr: "Images disque", .pt: "Imagens de disco", .ru: "Образы дисков",
        .ar: "صور الأقراص", .hi: "डिस्क इमेज", .it: "Immagini disco", .nl: "Schijfkopieën", .tr: "Disk İmajları",
    ]) }
    var filterInstaller: String { t([
        .en: "Installers", .zhHant: "安裝包", .zhHans: "安装包", .ja: "インストーラー", .ko: "설치 프로그램",
        .de: "Installationsprogramme", .es: "Instaladores", .fr: "Programmes d'installation", .pt: "Instaladores", .ru: "Установщики",
        .ar: "برامج التثبيت", .hi: "इंस्टॉलर", .it: "Programmi di installazione", .nl: "Installatieprogramma's", .tr: "Yükleyiciler",
    ]) }
    var filterVM: String { t([
        .en: "Virtual Machines", .zhHant: "虛擬機", .zhHans: "虚拟机", .ja: "仮想マシン", .ko: "가상 머신",
        .de: "Virtuelle Maschinen", .es: "Máquinas virtuales", .fr: "Machines virtuelles", .pt: "Máquinas virtuais", .ru: "Виртуальные машины",
        .ar: "الأجهزة الافتراضية", .hi: "वर्चुअल मशीन", .it: "Macchine virtuali", .nl: "Virtuele machines", .tr: "Sanal Makineler",
    ]) }
    var filterOther: String { t([
        .en: "Other", .zhHant: "其他", .zhHans: "其他", .ja: "その他", .ko: "기타",
        .de: "Sonstige", .es: "Otros", .fr: "Autres", .pt: "Outros", .ru: "Другое",
        .ar: "أخرى", .hi: "अन्य", .it: "Altri", .nl: "Overig", .tr: "Diğer",
    ]) }
    var cleanFiles: String { t([
        .en: "Clean Files", .zhHant: "清理檔案", .zhHans: "清理文件", .ja: "ファイルをクリーン", .ko: "파일 정리",
        .de: "Dateien bereinigen", .es: "Limpiar archivos", .fr: "Nettoyer les fichiers", .pt: "Limpar ficheiros", .ru: "Очистить файлы",
        .ar: "تنظيف الملفات", .hi: "फ़ाइलें साफ़ करें", .it: "Pulisci file", .nl: "Bestanden opruimen", .tr: "Dosyaları Temizle",
    ]) }
    var filesCleaned: String { t([
        .en: "Files Cleaned", .zhHant: "檔案已清理", .zhHans: "文件已清理", .ja: "ファイルがクリーンされました", .ko: "파일 정리됨",
        .de: "Dateien bereinigt", .es: "Archivos limpiados", .fr: "Fichiers nettoyés", .pt: "Ficheiros limpos", .ru: "Файлы очищены",
        .ar: "تم تنظيف الملفات", .hi: "फ़ाइलें साफ़ की गईं", .it: "File puliti", .nl: "Bestanden opgeruimd", .tr: "Dosyalar Temizlendi",
    ]) }

    // MARK: - App Lipo
    var scanningArchitectures: String { t([
        .en: "Scanning Architectures", .zhHant: "正在掃描架構", .zhHans: "正在扫描架构", .ja: "アーキテクチャをスキャン中", .ko: "아키텍처 스캔 중",
        .de: "Architekturen werden gescannt", .es: "Escaneando arquitecturas", .fr: "Analyse des architectures", .pt: "A verificar arquitecturas", .ru: "Сканирование архитектур",
        .ar: "جارٍ فحص البنيات", .hi: "आर्किटेक्चर स्कैन हो रहे हैं", .it: "Scansione architetture", .nl: "Architecturen scannen", .tr: "Mimariler Taranıyor",
    ]) }
    var noUniversalApps: String { t([
        .en: "No Universal Apps Found", .zhHant: "沒有找到通用應用", .zhHans: "没有找到通用应用", .ja: "ユニバーサルアプリが見つかりません", .ko: "유니버설 앱 없음",
        .de: "Keine Universal-Apps gefunden", .es: "No se encontraron apps universales", .fr: "Aucune app universelle trouvée", .pt: "Nenhuma app universal encontrada", .ru: "Универсальные приложения не найдены",
        .ar: "لم يتم العثور على تطبيقات شاملة", .hi: "कोई यूनिवर्सल ऐप नहीं मिला", .it: "Nessuna app universale trovata", .nl: "Geen universele apps gevonden", .tr: "Evrensel Uygulama Bulunamadı",
    ]) }
    var noUniversalAppsDesc: String { t([
        .en: "All apps are already optimized for your architecture.",
        .zhHant: "所有應用程式已針對你的架構進行最佳化。",
        .zhHans: "所有应用已针对你的架构进行优化。",
        .ja: "すべてのアプリはお使いのアーキテクチャに最適化されています。",
        .ko: "모든 앱이 이미 사용자의 아키텍처에 최적화되어 있습니다.",
        .de: "Alle Apps sind bereits für Ihre Architektur optimiert.",
        .es: "Todas las apps ya están optimizadas para su arquitectura.",
        .fr: "Toutes les apps sont déjà optimisées pour votre architecture.",
        .pt: "Todas as apps já estão otimizadas para a sua arquitectura.",
        .ru: "Все приложения уже оптимизированы для вашей архитектуры.",
        .ar: "جميع التطبيقات محسّنة بالفعل لبنية جهازك.",
        .hi: "सभी ऐप्स पहले से आपके आर्किटेक्चर के लिए अनुकूलित हैं।",
        .it: "Tutte le app sono già ottimizzate per la tua architettura.",
        .nl: "Alle apps zijn al geoptimaliseerd voor je architectuur.",
        .tr: "Tüm uygulamalar zaten mimariniz için optimize edilmiş.",
    ]) }
    var lipoWarning: String { t([
        .en: "Thinning removes unused architectures. Apps will still work normally.",
        .zhHant: "瘦身會移除未使用的架構。應用程式仍可正常運作。",
        .zhHans: "瘦身会移除未使用的架构。应用仍可正常运行。",
        .ja: "スリム化は未使用のアーキテクチャを削除します。アプリは引き続き正常に動作します。",
        .ko: "슬리밍은 사용하지 않는 아키텍처를 제거합니다. 앱은 정상적으로 작동합니다.",
        .de: "Das Verschlanken entfernt nicht verwendete Architekturen. Apps funktionieren weiterhin normal.",
        .es: "El adelgazamiento elimina arquitecturas no utilizadas. Las apps seguirán funcionando normalmente.",
        .fr: "L'amincissement supprime les architectures inutilisées. Les apps continueront à fonctionner normalement.",
        .pt: "O emagrecimento remove arquitecturas não utilizadas. As apps continuarão a funcionar normalmente.",
        .ru: "Оптимизация удаляет неиспользуемые архитектуры. Приложения продолжат работать нормально.",
        .ar: "التنحيف يزيل البنيات غير المستخدمة. ستستمر التطبيقات في العمل بشكل طبيعي.",
        .hi: "स्लिमिंग अप्रयुक्त आर्किटेक्चर हटाता है। ऐप्स सामान्य रूप से काम करते रहेंगे।",
        .it: "Lo snellimento rimuove le architetture non utilizzate. Le app continueranno a funzionare normalmente.",
        .nl: "Afslanken verwijdert ongebruikte architecturen. Apps blijven normaal werken.",
        .tr: "İnceleme kullanılmayan mimarileri kaldırır. Uygulamalar normal çalışmaya devam eder.",
    ]) }
    var thinApps: String { t([
        .en: "Clean Up", .zhHant: "執行清理", .zhHans: "执行清理", .ja: "クリーンアップ", .ko: "정리하기",
        .de: "Aufräumen", .es: "Limpiar", .fr: "Nettoyer", .pt: "Limpar", .ru: "Очистить",
        .ar: "تنظيف", .hi: "साफ़ करें", .it: "Pulisci", .nl: "Opruimen", .tr: "Temizle",
    ]) }
    var appsThinned: String { t([
        .en: "Apps Thinned", .zhHant: "應用已瘦身", .zhHans: "应用已瘦身", .ja: "アプリがスリム化されました", .ko: "앱 슬리밍 완료",
        .de: "Apps verschlankt", .es: "Apps adelgazadas", .fr: "Apps amincies", .pt: "Apps emagrecidas", .ru: "Приложения оптимизированы",
        .ar: "تم تنحيف التطبيقات", .hi: "ऐप्स स्लिम किए गए", .it: "App snellite", .nl: "Apps afgeslankt", .tr: "Uygulamalar İncelendi",
    ]) }
    var potentialSavings: String { t([
        .en: "Potential Savings", .zhHant: "預估可節省", .zhHans: "预估可节省", .ja: "節約可能", .ko: "절약 가능",
        .de: "Mögliche Einsparung", .es: "Ahorro potencial", .fr: "Économie potentielle", .pt: "Economia potencial", .ru: "Возможная экономия",
        .ar: "التوفير المحتمل", .hi: "संभावित बचत", .it: "Risparmio potenziale", .nl: "Mogelijke besparing", .tr: "Potansiyel Tasarruf",
    ]) }

    // MARK: - Settings (Sentinel)
    var sentinel: String { t([
        .en: "Sentinel", .zhHant: "自動監控", .zhHans: "自动监控", .ja: "センチネル", .ko: "센티넬",
        .de: "Sentinel", .es: "Sentinel", .fr: "Sentinel", .pt: "Sentinel", .ru: "Sentinel",
        .ar: "الحارس", .hi: "सेंटिनल", .it: "Sentinel", .nl: "Sentinel", .tr: "Sentinel",
    ]) }
    var sentinelEnabled: String { t([
        .en: "Enable Sentinel", .zhHant: "啟用自動監控", .zhHans: "启用自动监控", .ja: "センチネルを有効にする", .ko: "센티넬 활성화",
        .de: "Sentinel aktivieren", .es: "Activar Sentinel", .fr: "Activer Sentinel", .pt: "Ativar Sentinel", .ru: "Включить Sentinel",
        .ar: "تفعيل الحارس", .hi: "सेंटिनल सक्षम करें", .it: "Attiva Sentinel", .nl: "Sentinel inschakelen", .tr: "Sentinel'i Etkinleştir",
    ]) }
    var sentinelDesc: String { t([
        .en: "Automatically monitor and notify when junk files accumulate.",
        .zhHant: "自動監控並在垃圾檔案累積時通知你。",
        .zhHans: "自动监控并在垃圾文件累积时通知你。",
        .ja: "不要なファイルが蓄積された時に自動的に監視して通知します。",
        .ko: "정크 파일이 누적되면 자동으로 모니터링하고 알림을 보냅니다.",
        .de: "Automatisch überwachen und benachrichtigen, wenn sich Datenmüll ansammelt.",
        .es: "Supervisar automáticamente y notificar cuando se acumulen archivos basura.",
        .fr: "Surveiller automatiquement et notifier lorsque les fichiers inutiles s'accumulent.",
        .pt: "Monitorizar automaticamente e notificar quando ficheiros de lixo se acumularem.",
        .ru: "Автоматический мониторинг и уведомление при накоплении мусорных файлов.",
        .ar: "مراقبة تلقائية وإشعار عند تراكم الملفات غير الضرورية.",
        .hi: "जंक फ़ाइलें जमा होने पर स्वचालित रूप से मॉनिटर करें और सूचित करें।",
        .it: "Monitora automaticamente e notifica quando i file spazzatura si accumulano.",
        .nl: "Automatisch monitoren en melden wanneer ongewenste bestanden zich ophopen.",
        .tr: "Gereksiz dosyalar biriktiğinde otomatik olarak izle ve bildir.",
    ]) }

    // MARK: - System Tools
    var systemTools: String { t([
        .en: "System Tools", .zhHant: "系統工具", .zhHans: "系统工具", .ja: "システムツール", .ko: "시스템 도구",
        .de: "Systemwerkzeuge", .es: "Herramientas del sistema", .fr: "Outils système", .pt: "Ferramentas do sistema", .ru: "Системные инструменты",
        .ar: "أدوات النظام", .hi: "सिस्टम उपकरण", .it: "Strumenti di sistema", .nl: "Systeemgereedschappen", .tr: "Sistem araçları",
    ]) }
    var tools: String { t([
        .en: "Tools", .zhHant: "工具", .zhHans: "工具", .ja: "ツール", .ko: "도구",
        .de: "Werkzeuge", .es: "Herramientas", .fr: "Outils", .pt: "Ferramentas", .ru: "Инструменты",
        .ar: "الأدوات", .hi: "उपकरण", .it: "Strumenti", .nl: "Gereedschappen", .tr: "Araçlar",
    ]) }
    var flushDNS: String { t([
        .en: "Flush DNS Cache", .zhHant: "清除 DNS 快取", .zhHans: "清除 DNS 缓存", .ja: "DNSキャッシュをフラッシュ", .ko: "DNS 캐시 비우기",
        .de: "DNS-Cache leeren", .es: "Vaciar caché DNS", .fr: "Vider le cache DNS", .pt: "Limpar cache DNS", .ru: "Очистить кэш DNS",
        .ar: "مسح ذاكرة التخزين المؤقت لـ DNS", .hi: "DNS कैश फ्लश करें", .it: "Svuota cache DNS", .nl: "DNS-cache wissen", .tr: "DNS Önbelleğini Temizle",
    ]) }
    var flushDNSDesc: String { t([
        .en: "Clear the DNS cache to resolve network issues.",
        .zhHant: "清除 DNS 快取以解決網路問題。",
        .zhHans: "清除 DNS 缓存以解决网络问题。",
        .ja: "ネットワークの問題を解決するためにDNSキャッシュをクリアします。",
        .ko: "네트워크 문제를 해결하기 위해 DNS 캐시를 비웁니다.",
        .de: "DNS-Cache leeren, um Netzwerkprobleme zu beheben.",
        .es: "Vaciar la caché DNS para resolver problemas de red.",
        .fr: "Vider le cache DNS pour résoudre les problèmes réseau.",
        .pt: "Limpar a cache DNS para resolver problemas de rede.",
        .ru: "Очистить кэш DNS для решения сетевых проблем.",
        .ar: "مسح ذاكرة التخزين المؤقت لـ DNS لحل مشاكل الشبكة.",
        .hi: "नेटवर्क समस्याओं को हल करने के लिए DNS कैश साफ़ करें।",
        .it: "Svuota la cache DNS per risolvere problemi di rete.",
        .nl: "DNS-cache wissen om netwerkproblemen op te lossen.",
        .tr: "Ağ sorunlarını çözmek için DNS önbelleğini temizleyin.",
    ]) }
    var dockerCleanup: String { t([
        .en: "Docker Cleanup", .zhHant: "Docker 清理", .zhHans: "Docker 清理", .ja: "Dockerクリーンアップ", .ko: "Docker 정리",
        .de: "Docker-Bereinigung", .es: "Limpieza de Docker", .fr: "Nettoyage Docker", .pt: "Limpeza Docker", .ru: "Очистка Docker",
        .ar: "تنظيف Docker", .hi: "Docker क्लीनअप", .it: "Pulizia Docker", .nl: "Docker opruimen", .tr: "Docker Temizliği",
    ]) }
    var dockerCleanupDesc: String { t([
        .en: "Remove unused Docker images, containers, and build cache.",
        .zhHant: "移除未使用的 Docker 映像、容器和建置快取。",
        .zhHans: "移除未使用的 Docker 镜像、容器和构建缓存。",
        .ja: "未使用のDockerイメージ、コンテナ、ビルドキャッシュを削除します。",
        .ko: "사용하지 않는 Docker 이미지, 컨테이너, 빌드 캐시를 제거합니다.",
        .de: "Ungenutzte Docker-Images, Container und Build-Cache entfernen.",
        .es: "Eliminar imágenes, contenedores y caché de compilación de Docker no utilizados.",
        .fr: "Supprimer les images, conteneurs et cache de build Docker inutilisés.",
        .pt: "Remover imagens, contentores e cache de compilação Docker não utilizados.",
        .ru: "Удалить неиспользуемые образы, контейнеры и кэш сборки Docker.",
        .ar: "إزالة صور Docker والحاويات وذاكرة التخزين المؤقت للبناء غير المستخدمة.",
        .hi: "अप्रयुक्त Docker इमेज, कंटेनर और बिल्ड कैश हटाएं।",
        .it: "Rimuovi immagini, container e cache di compilazione Docker inutilizzati.",
        .nl: "Ongebruikte Docker-images, containers en bouwcache verwijderen.",
        .tr: "Kullanılmayan Docker imajlarını, konteynerleri ve derleme önbelleğini kaldırın.",
    ]) }
    var dockerNotFound: String { t([
        .en: "Docker not installed", .zhHant: "未安裝 Docker", .zhHans: "未安装 Docker", .ja: "Dockerがインストールされていません", .ko: "Docker가 설치되어 있지 않음",
        .de: "Docker nicht installiert", .es: "Docker no instalado", .fr: "Docker non installé", .pt: "Docker não instalado", .ru: "Docker не установлен",
        .ar: "Docker غير مثبت", .hi: "Docker इंस्टॉल नहीं है", .it: "Docker non installato", .nl: "Docker niet geïnstalleerd", .tr: "Docker yüklü değil",
    ]) }
    var rebuildSpotlight: String { t([
        .en: "Rebuild Spotlight Index", .zhHant: "重建 Spotlight 索引", .zhHans: "重建 Spotlight 索引", .ja: "Spotlightインデックスを再構築", .ko: "Spotlight 색인 재구축",
        .de: "Spotlight-Index neu aufbauen", .es: "Reconstruir índice de Spotlight", .fr: "Reconstruire l'index Spotlight", .pt: "Reconstruir índice do Spotlight", .ru: "Перестроить индекс Spotlight",
        .ar: "إعادة بناء فهرس Spotlight", .hi: "Spotlight इंडेक्स पुनर्निर्माण करें", .it: "Ricostruisci indice Spotlight", .nl: "Spotlight-index opnieuw opbouwen", .tr: "Spotlight Dizinini Yeniden Oluştur",
    ]) }
    var rebuildSpotlightDesc: String { t([
        .en: "Rebuild the Spotlight search index. This may take several minutes.",
        .zhHant: "重建 Spotlight 搜尋索引。這可能需要幾分鐘。",
        .zhHans: "重建 Spotlight 搜索索引。这可能需要几分钟。",
        .ja: "Spotlight検索インデックスを再構築します。数分かかる場合があります。",
        .ko: "Spotlight 검색 색인을 재구축합니다. 몇 분이 걸릴 수 있습니다.",
        .de: "Spotlight-Suchindex neu aufbauen. Dies kann einige Minuten dauern.",
        .es: "Reconstruir el índice de búsqueda de Spotlight. Esto puede tardar varios minutos.",
        .fr: "Reconstruire l'index de recherche Spotlight. Cela peut prendre plusieurs minutes.",
        .pt: "Reconstruir o índice de pesquisa do Spotlight. Pode demorar vários minutos.",
        .ru: "Перестроить поисковый индекс Spotlight. Это может занять несколько минут.",
        .ar: "إعادة بناء فهرس بحث Spotlight. قد يستغرق هذا عدة دقائق.",
        .hi: "Spotlight खोज इंडेक्स पुनर्निर्माण करें। इसमें कई मिनट लग सकते हैं।",
        .it: "Ricostruisci l'indice di ricerca Spotlight. Potrebbe richiedere diversi minuti.",
        .nl: "Spotlight-zoekindex opnieuw opbouwen. Dit kan enkele minuten duren.",
        .tr: "Spotlight arama dizinini yeniden oluşturun. Bu birkaç dakika sürebilir.",
    ]) }
    var rebuildLaunchServices: String { t([
        .en: "Rebuild Launch Services", .zhHant: "重建啟動服務", .zhHans: "重建启动服务", .ja: "Launch Servicesを再構築", .ko: "Launch Services 재구축",
        .de: "Launch Services neu aufbauen", .es: "Reconstruir Launch Services", .fr: "Reconstruire Launch Services", .pt: "Reconstruir Launch Services", .ru: "Перестроить Launch Services",
        .ar: "إعادة بناء Launch Services", .hi: "Launch Services पुनर्निर्माण करें", .it: "Ricostruisci Launch Services", .nl: "Launch Services opnieuw opbouwen", .tr: "Launch Services'ı Yeniden Oluştur",
    ]) }
    var rebuildLaunchServicesDesc: String { t([
        .en: "Fix \"Open With\" menu showing duplicate or missing apps.",
        .zhHant: "修復「打開方式」選單顯示重複或缺少的應用程式。",
        .zhHans: "修复「打开方式」菜单显示重复或缺少的应用程序。",
        .ja: "「このアプリケーションで開く」メニューの重複や欠落を修正します。",
        .ko: "\"다음으로 열기\" 메뉴에 중복 또는 누락된 앱이 표시되는 문제를 수정합니다.",
        .de: "\"Öffnen mit\"-Menü mit doppelten oder fehlenden Apps reparieren.",
        .es: "Corregir el menú \"Abrir con\" que muestra apps duplicadas o faltantes.",
        .fr: "Corriger le menu \"Ouvrir avec\" affichant des apps en double ou manquantes.",
        .pt: "Corrigir o menu \"Abrir com\" que mostra apps duplicadas ou em falta.",
        .ru: "Исправить меню «Открыть с помощью», показывающее дубликаты или отсутствующие приложения.",
        .ar: "إصلاح قائمة \"فتح باستخدام\" التي تعرض تطبيقات مكررة أو مفقودة.",
        .hi: "डुप्लिकेट या गायब ऐप्स दिखाने वाले \"ओपन विथ\" मेनू को ठीक करें।",
        .it: "Correggi il menu \"Apri con\" che mostra app duplicate o mancanti.",
        .nl: "\"Open met\"-menu met dubbele of ontbrekende apps repareren.",
        .tr: "Yinelenen veya eksik uygulamaları gösteren \"Birlikte Aç\" menüsünü düzeltin.",
    ]) }
    var clearFontCache: String { t([
        .en: "Clear Font Cache", .zhHant: "清除字型快取", .zhHans: "清除字体缓存", .ja: "フォントキャッシュをクリア", .ko: "글꼴 캐시 지우기",
        .de: "Schrift-Cache löschen", .es: "Limpiar caché de fuentes", .fr: "Vider le cache des polices", .pt: "Limpar cache de fontes", .ru: "Очистить кэш шрифтов",
        .ar: "مسح ذاكرة التخزين المؤقت للخطوط", .hi: "फ़ॉन्ट कैश साफ़ करें", .it: "Svuota cache font", .nl: "Lettertype-cache wissen", .tr: "Yazı Tipi Önbelleğini Temizle",
    ]) }
    var clearFontCacheDesc: String { t([
        .en: "Rebuild font caches to fix font rendering issues.",
        .zhHant: "重建字型快取以修復字型顯示問題。",
        .zhHans: "重建字体缓存以修复字体渲染问题。",
        .ja: "フォントのレンダリング問題を修正するためにフォントキャッシュを再構築します。",
        .ko: "글꼴 렌더링 문제를 해결하기 위해 글꼴 캐시를 재구축합니다.",
        .de: "Schrift-Caches neu aufbauen, um Probleme mit der Schriftdarstellung zu beheben.",
        .es: "Reconstruir cachés de fuentes para corregir problemas de renderizado de fuentes.",
        .fr: "Reconstruire les caches de polices pour corriger les problèmes de rendu des polices.",
        .pt: "Reconstruir caches de fontes para corrigir problemas de renderização de fontes.",
        .ru: "Перестроить кэш шрифтов для исправления проблем с отображением шрифтов.",
        .ar: "إعادة بناء ذاكرة التخزين المؤقت للخطوط لإصلاح مشاكل عرض الخطوط.",
        .hi: "फ़ॉन्ट रेंडरिंग समस्याओं को ठीक करने के लिए फ़ॉन्ट कैश पुनर्निर्माण करें।",
        .it: "Ricostruisci le cache dei font per risolvere problemi di rendering dei font.",
        .nl: "Lettertypecaches opnieuw opbouwen om weergaveproblemen met lettertypen te verhelpen.",
        .tr: "Yazı tipi oluşturma sorunlarını gidermek için yazı tipi önbelleklerini yeniden oluşturun.",
    ]) }
    var running: String { t([
        .en: "Running...", .zhHant: "執行中...", .zhHans: "运行中...", .ja: "実行中...", .ko: "실행 중...",
        .de: "Wird ausgeführt...", .es: "Ejecutando...", .fr: "En cours...", .pt: "A executar...", .ru: "Выполняется...",
        .ar: "قيد التشغيل...", .hi: "चल रहा है...", .it: "In esecuzione...", .nl: "Bezig...", .tr: "Çalışıyor...",
    ]) }
    var completed: String { t([
        .en: "Completed", .zhHant: "已完成", .zhHans: "已完成", .ja: "完了", .ko: "완료됨",
        .de: "Abgeschlossen", .es: "Completado", .fr: "Terminé", .pt: "Concluído", .ru: "Завершено",
        .ar: "اكتمل", .hi: "पूर्ण", .it: "Completato", .nl: "Voltooid", .tr: "Tamamlandı",
    ]) }
    var requiresAdmin: String { t([
        .en: "Requires admin password", .zhHant: "需要管理員密碼", .zhHans: "需要管理员密码", .ja: "管理者パスワードが必要です", .ko: "관리자 암호 필요",
        .de: "Erfordert Admin-Passwort", .es: "Requiere contraseña de administrador", .fr: "Nécessite le mot de passe administrateur", .pt: "Requer palavra-passe de administrador", .ru: "Требуется пароль администратора",
        .ar: "يتطلب كلمة مرور المسؤول", .hi: "एडमिन पासवर्ड आवश्यक", .it: "Richiede password di amministratore", .nl: "Vereist beheerderswachtwoord", .tr: "Yönetici şifresi gerektirir",
    ]) }
    var runTool: String { t([
        .en: "Run", .zhHant: "執行", .zhHans: "执行", .ja: "実行", .ko: "실행",
        .de: "Ausführen", .es: "Ejecutar", .fr: "Exécuter", .pt: "Executar", .ru: "Запустить",
        .ar: "تشغيل", .hi: "चलाएं", .it: "Esegui", .nl: "Uitvoeren", .tr: "Çalıştır",
    ]) }

    // MARK: - IAP / Paywall
    var unlockPro: String { t([
        .en: "Unlock Maclean Pro", .zhHant: "解鎖 Maclean Pro", .zhHans: "解锁 Maclean Pro", .ja: "Maclean Pro をアンロック", .ko: "Maclean Pro 잠금 해제",
        .de: "Maclean Pro freischalten", .es: "Desbloquear Maclean Pro", .fr: "Débloquer Maclean Pro", .pt: "Desbloquear Maclean Pro", .ru: "Разблокировать Maclean Pro",
        .ar: "فتح Maclean Pro", .hi: "Maclean Pro अनलॉक करें", .it: "Sblocca Maclean Pro", .nl: "Maclean Pro ontgrendelen", .tr: "Maclean Pro Kilidini Aç",
    ]) }
    func quotaUsed(_ size: String) -> String { t([
        .en: "You have cleaned \(size) in total", .zhHant: "您已累計清理 \(size)", .zhHans: "您已累计清理 \(size)", .ja: "合計 \(size) をクリーンアップしました", .ko: "총 \(size)를 정리했습니다",
        .de: "Sie haben insgesamt \(size) bereinigt", .es: "Ha limpiado \(size) en total", .fr: "Vous avez nettoyé \(size) au total", .pt: "Limpou \(size) no total", .ru: "Всего очищено \(size)",
        .ar: "لقد قمت بتنظيف \(size) إجمالاً", .hi: "आपने कुल \(size) साफ़ किया है", .it: "Hai pulito \(size) in totale", .nl: "U heeft in totaal \(size) opgeruimd", .tr: "Toplam \(size) temizlediniz",
    ]) }
    var freeQuotaReached: String { t([
        .en: "Free quota reached", .zhHant: "免費額度已用完", .zhHans: "免费额度已用完", .ja: "無料枠に達しました", .ko: "무료 할당량에 도달했습니다",
        .de: "Kostenloses Kontingent erreicht", .es: "Cuota gratuita alcanzada", .fr: "Quota gratuit atteint", .pt: "Quota gratuita atingida", .ru: "Бесплатная квота исчерпана",
        .ar: "تم الوصول إلى الحد المجاني", .hi: "मुफ़्त कोटा समाप्त", .it: "Quota gratuita raggiunta", .nl: "Gratis limiet bereikt", .tr: "Ücretsiz kota doldu",
    ]) }
    var benefitUnlimited: String { t([
        .en: "Unlimited cleanup", .zhHant: "無限制清理額度", .zhHans: "无限制清理额度", .ja: "無制限のクリーンアップ", .ko: "무제한 정리",
        .de: "Unbegrenztes Aufräumen", .es: "Limpieza ilimitada", .fr: "Nettoyage illimité", .pt: "Limpeza ilimitada", .ru: "Безлимитная очистка",
        .ar: "تنظيف غير محدود", .hi: "असीमित सफ़ाई", .it: "Pulizia illimitata", .nl: "Onbeperkt opruimen", .tr: "Sınırsız temizlik",
    ]) }
    var benefitLifetime: String { t([
        .en: "Lifetime access, one-time purchase", .zhHant: "終身有效，一次購買", .zhHans: "终身有效，一次购买", .ja: "買い切り、永久利用可能", .ko: "평생 이용, 일회 구매",
        .de: "Lebenslanger Zugang, einmaliger Kauf", .es: "Acceso de por vida, compra única", .fr: "Accès à vie, achat unique", .pt: "Acesso vitalício, compra única", .ru: "Пожизненный доступ, разовая покупка",
        .ar: "وصول مدى الحياة، شراء لمرة واحدة", .hi: "आजीवन एक्सेस, एक बार खरीदें", .it: "Accesso a vita, acquisto singolo", .nl: "Levenslange toegang, eenmalige aankoop", .tr: "Ömür boyu erişim, tek seferlik satın alma",
    ]) }
    var benefitUpdates: String { t([
        .en: "All future updates", .zhHant: "所有未來更新", .zhHans: "所有未来更新", .ja: "将来のすべてのアップデート", .ko: "모든 향후 업데이트",
        .de: "Alle zukünftigen Updates", .es: "Todas las actualizaciones futuras", .fr: "Toutes les mises à jour futures", .pt: "Todas as atualizações futuras", .ru: "Все будущие обновления",
        .ar: "جميع التحديثات المستقبلية", .hi: "सभी भविष्य के अपडेट", .it: "Tutti gli aggiornamenti futuri", .nl: "Alle toekomstige updates", .tr: "Tüm gelecek güncellemeler",
    ]) }
    var restorePurchase: String { t([
        .en: "Restore Purchase", .zhHant: "恢復購買", .zhHans: "恢复购买", .ja: "購入を復元", .ko: "구매 복원",
        .de: "Kauf wiederherstellen", .es: "Restaurar compra", .fr: "Restaurer l'achat", .pt: "Restaurar compra", .ru: "Восстановить покупку",
        .ar: "استعادة الشراء", .hi: "खरीदारी पुनर्स्थापित करें", .it: "Ripristina acquisto", .nl: "Aankoop herstellen", .tr: "Satın Almayı Geri Yükle",
    ]) }
    var maybeLater: String { t([
        .en: "Maybe Later", .zhHant: "稍後再說", .zhHans: "稍后再说", .ja: "後で", .ko: "나중에",
        .de: "Vielleicht später", .es: "Quizás más tarde", .fr: "Peut-être plus tard", .pt: "Talvez mais tarde", .ru: "Позже",
        .ar: "ربما لاحقاً", .hi: "बाद में", .it: "Forse dopo", .nl: "Misschien later", .tr: "Belki Sonra",
    ]) }
    var restoreNotFound: String { t([
        .en: "No previous purchase found", .zhHant: "找不到先前的購買紀錄", .zhHans: "找不到先前的购买记录", .ja: "以前の購入が見つかりません", .ko: "이전 구매를 찾을 수 없습니다",
        .de: "Kein früherer Kauf gefunden", .es: "No se encontró compra previa", .fr: "Aucun achat précédent trouvé", .pt: "Nenhuma compra anterior encontrada", .ru: "Предыдущая покупка не найдена",
        .ar: "لم يتم العثور على شراء سابق", .hi: "पिछली खरीदारी नहीं मिली", .it: "Nessun acquisto precedente trovato", .nl: "Geen eerdere aankoop gevonden", .tr: "Önceki satın alma bulunamadı",
    ]) }
    func paywallHeadline(_ size: String) -> String { t([
        .en: "Maclean has helped you clean \(size)", .zhHant: "Maclean 已幫你清理了 \(size) 的空間", .zhHans: "Maclean 已帮你清理了 \(size) 的空间", .ja: "Maclean は \(size) のクリーンアップをお手伝いしました", .ko: "Maclean이 \(size)를 정리해 드렸습니다",
        .de: "Maclean hat \(size) für Sie bereinigt", .es: "Maclean ha limpiado \(size) para ti", .fr: "Maclean a nettoyé \(size) pour vous", .pt: "Maclean limpou \(size) para si", .ru: "Maclean очистил для вас \(size)",
        .ar: "ساعدك Maclean في تنظيف \(size)", .hi: "Maclean ने आपके लिए \(size) साफ़ किया", .it: "Maclean ha pulito \(size) per te", .nl: "Maclean heeft \(size) voor u opgeruimd", .tr: "Maclean sizin için \(size) temizledi",
    ]) }
    var paywallSubtitle: String { t([
        .en: "Unlock Pro to continue cleaning without limits", .zhHant: "解鎖 Pro 即可繼續無限制清理", .zhHans: "解锁 Pro 即可继续无限制清理", .ja: "Pro にアップグレードして無制限にクリーンアップ", .ko: "Pro로 업그레이드하여 무제한 정리",
        .de: "Schalten Sie Pro frei, um ohne Limits weiterzumachen", .es: "Desbloquea Pro para seguir limpiando sin límites", .fr: "Débloquez Pro pour continuer sans limites", .pt: "Desbloqueie Pro para continuar sem limites", .ru: "Разблокируйте Pro для безлимитной очистки",
        .ar: "افتح Pro للاستمرار في التنظيف بلا حدود", .hi: "असीमित सफ़ाई के लिए Pro अनलॉक करें", .it: "Sblocca Pro per continuare senza limiti", .nl: "Ontgrendel Pro om onbeperkt door te gaan", .tr: "Sınırsız temizliğe devam etmek için Pro'yu açın",
    ]) }
    var proStatus: String { t([
        .en: "Pro Status", .zhHant: "Pro 狀態", .zhHans: "Pro 状态", .ja: "Pro ステータス", .ko: "Pro 상태",
        .de: "Pro-Status", .es: "Estado Pro", .fr: "Statut Pro", .pt: "Estado Pro", .ru: "Статус Pro",
        .ar: "حالة Pro", .hi: "Pro स्थिति", .it: "Stato Pro", .nl: "Pro-status", .tr: "Pro Durumu",
    ]) }
    var proUnlocked: String { t([
        .en: "Pro Unlocked", .zhHant: "已解鎖 Pro", .zhHans: "已解锁 Pro", .ja: "Pro アンロック済み", .ko: "Pro 잠금 해제됨",
        .de: "Pro freigeschaltet", .es: "Pro desbloqueado", .fr: "Pro débloqué", .pt: "Pro desbloqueado", .ru: "Pro разблокирован",
        .ar: "تم فتح Pro", .hi: "Pro अनलॉक", .it: "Pro sbloccato", .nl: "Pro ontgrendeld", .tr: "Pro Açık",
    ]) }
    func freeQuotaStatus(_ used: String, _ total: String) -> String { t([
        .en: "Free — \(used) / \(total) used", .zhHant: "免費版 — 已使用 \(used) / \(total)", .zhHans: "免费版 — 已使用 \(used) / \(total)", .ja: "無料 — \(used) / \(total) 使用済み", .ko: "무료 — \(used) / \(total) 사용됨",
        .de: "Kostenlos — \(used) / \(total) verbraucht", .es: "Gratis — \(used) / \(total) usado", .fr: "Gratuit — \(used) / \(total) utilisé", .pt: "Grátis — \(used) / \(total) usado", .ru: "Бесплатно — \(used) / \(total) использовано",
        .ar: "مجاني — \(used) / \(total) مستخدم", .hi: "मुफ़्त — \(used) / \(total) उपयोग किया", .it: "Gratis — \(used) / \(total) usato", .nl: "Gratis — \(used) / \(total) gebruikt", .tr: "Ücretsiz — \(used) / \(total) kullanıldı",
    ]) }
}
