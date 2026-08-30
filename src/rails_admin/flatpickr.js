// flatpickr with every locale registered onto its shared `l10ns` singleton, so the
// date/time widgets can honour `locale: I18n.locale`. This is the equivalent of the
// Sprockets manifest's old `flatpickr-with-locales` require. Import this instead of
// "flatpickr" directly.
//
// flatpickr assigns itself to `window.flatpickr` on load, and the l10n bundle
// self-registers onto that global - so the "flatpickr" import has to come first to
// win the evaluation-order race. Assigning the locales by hand instead does not
// work: esbuild's Node interop hands back the wrapped module namespace, which
// clobbers `l10ns.default` and breaks every picker.
import flatpickr from "flatpickr";
import "flatpickr/dist/l10n";

export default flatpickr;
