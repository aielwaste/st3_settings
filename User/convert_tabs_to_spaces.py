import sublime, sublime_plugin

class ConvertTabsToSpaces(sublime_plugin.TextCommand):
    def run(self, edit):
        self.view.run_command('expand_tabs', {"set_translate_tabs": True})