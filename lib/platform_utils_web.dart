import 'dart:html' as html;
import 'dart:ui_web' as ui;

void registerViewFactory(String viewId, String src) {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    viewId,
    (int viewId) => html.IFrameElement()
      ..src = src
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%',
  );
}
