import sublime, sublime_plugin, os, subprocess, glob, tempfile, plistlib
from zipfile import ZipFile

class PrintScopeListCommand(sublime_plugin.TextCommand):
    # This function gives array of scope names from the plist dictionary passed as argument
    def scopes_inside(d):
        result = []
        for k in d.keys():
            if k == 'scopeName':
                result = result + [ s.strip() for s in d[k].split(',') ]
            elif isinstance(d[k], dict):
                result = result + scopes_inside(d[k])
        return result

    # Using set to have unique values
    scopes = set()
    
    # Parsing all .tmLanguage files from the Packages directory
    for x in os.walk(sublime.packages_path()):
        for f in glob.glob(os.path.join(x[0], '*.tmLanguage')):
            for s in scopes_inside(plistlib.readPlist(f)):
                scopes.add(s.strip())
    # Parsing all .tmLanguage files inside .sublime-package files from the Installed Packages directory
    for x in os.walk(sublime.installed_packages_path()):
        for f in glob.glob(os.path.join(x[0], '*.sublime-package')):
            input_zip = ZipFile(f)
            for name in input_zip.namelist():
                if name.endswith('.tmLanguage'):
                    for s in self.get_scopes_from(plistlib.readPlistFromBytes(input_zip.read(name))):
                        scopes.add(s.strip())
    # Parsing all .tmLanguage files inside .sublime-package files from the Installation directory
    for x in os.walk(os.path.dirname(sublime.executable_path())):
        for f in glob.glob(os.path.join(x[0], '*.sublime-package')):
            input_zip = ZipFile(f)
            for name in input_zip.namelist():
                if name.endswith('.tmLanguage'):
                    for s in self.get_scopes_from(plistlib.readPlistFromBytes(input_zip.read(name))):
                        scopes.add(s.strip())
    scopes = list(scopes)