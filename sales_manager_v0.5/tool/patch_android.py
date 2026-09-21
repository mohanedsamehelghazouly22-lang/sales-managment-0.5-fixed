#!/usr/bin/env python3
"""يجهّز مشروع الأندرويد لإشعارات flutter_local_notifications:
  1) تفعيل core library desugaring في android/app/build.gradle(.kts)
  2) إضافة صلاحية POST_NOTIFICATIONS في AndroidManifest.xml
آمن للتشغيل أكثر من مرة — لو التعديل موجود بالفعل مش بيعمل حاجة.
الاستخدام (من جذر المشروع):  python3 tool/patch_android.py
"""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
APP = ROOT / 'android' / 'app'
DESUGAR = 'com.android.tools:desugar_jdk_libs:2.0.4'


def patch_gradle(path: pathlib.Path) -> None:
    txt = path.read_text(encoding='utf-8')
    kts = path.suffix == '.kts'
    changed = False

    if 'oreLibraryDesugaringEnabled' not in txt:
        flag = ('isCoreLibraryDesugaringEnabled = true' if kts
                else 'coreLibraryDesugaringEnabled true')
        m = re.search(r'compileOptions\s*\{', txt)
        if m:
            txt = txt[:m.end()] + '\n        ' + flag + txt[m.end():]
        else:
            m = re.search(r'android\s*\{', txt)
            if m:
                block = '\n    compileOptions {\n        ' + flag + '\n    }\n'
                txt = txt[:m.end()] + block + txt[m.end():]
            else:
                print(f'! لم أجد android {{ }} في {path.name} — فعّل desugaring يدويًا')
                return
        changed = True

    if 'desugar_jdk_libs' not in txt:
        dep = (f'coreLibraryDesugaring("{DESUGAR}")' if kts
               else f"coreLibraryDesugaring '{DESUGAR}'")
        m = re.search(r'(?m)^dependencies\s*\{', txt)
        if m:
            txt = txt[:m.end()] + '\n    ' + dep + txt[m.end():]
        else:
            txt = txt.rstrip() + '\n\ndependencies {\n    ' + dep + '\n}\n'
        changed = True

    if changed:
        path.write_text(txt, encoding='utf-8')
        print(f'✓ تم تعديل {path.relative_to(ROOT)}')
    else:
        print(f'= {path.relative_to(ROOT)} جاهز بالفعل')


def patch_manifest(path: pathlib.Path) -> None:
    txt = path.read_text(encoding='utf-8')
    if 'POST_NOTIFICATIONS' in txt:
        print(f'= {path.relative_to(ROOT)} جاهز بالفعل')
        return
    perm = '    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>'
    m = re.search(r'<manifest[^>]*>', txt)
    if not m:
        print('! لم أجد وسم manifest — أضف صلاحية POST_NOTIFICATIONS يدويًا')
        return
    txt = txt[:m.end()] + '\n' + perm + txt[m.end():]
    path.write_text(txt, encoding='utf-8')
    print(f'✓ تم تعديل {path.relative_to(ROOT)}')


def main() -> None:
    if not APP.exists():
        print('android/app غير موجود — تخطّي (لا يوجد مشروع أندرويد هنا)')
        return
    gradle = APP / 'build.gradle'
    if not gradle.exists():
        gradle = APP / 'build.gradle.kts'
    if gradle.exists():
        patch_gradle(gradle)
    else:
        print('! لم أجد build.gradle للتطبيق')
    manifest = APP / 'src' / 'main' / 'AndroidManifest.xml'
    if manifest.exists():
        patch_manifest(manifest)
    else:
        print('! لم أجد AndroidManifest.xml')


if __name__ == '__main__':
    main()
    sys.exit(0)
