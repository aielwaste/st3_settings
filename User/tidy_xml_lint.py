import sublime
import sublime_plugin
import subprocess

class TidyXmlLintCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        command = "XMLLINT_INDENT='\t' xmllint --format --encode utf-8 -"

    # help from http://www.sublimetext.com/forum/viewtopic.php?f=2&p=12451
    if self.view.sel()[0].empty():
        xmlRegion = sublime.Region(0, self.view.size())
    else:
        xmlRegion = self.view.sel()[0]

    p = subprocess.Popen(command, bufsize=-1, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE, shell=True)
    result, err = p.communicate(self.view.substr(xmlRegion).encode('utf-8'))

    if err != b"":
        self.view.set_status('xmllint', "xmllint: " + err.decode("utf-8"))
        sublime.set_timeout(self.clear,10000)
    else:
        self.view.replace(edit, xmlRegion, result.decode('utf-8'))
        sublime.set_timeout(self.clear,0)

    def clear(self):
        self.view.erase_status('xmllint')
