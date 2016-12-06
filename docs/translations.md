## Rails

Pick [[your locale here|https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale]]

## Devise

See [[https://github.com/plataformatec/devise/wiki/I18n]] and [[https://github.com/tigrish/devise-i18n]]

## RailsAdmin

Copy [[https://github.com/sferik/rails_admin/blob/master/config/locales/rails_admin.en.yml]] to your `config/locales` directory and adapt it to your needs.

## Translation Missing?

**You can pick your locales or contribute in translation here: https://www.localeapp.com/projects/905**

Make sure your existing locales do not have admin: key under :en, :es, :de etc. You will get translation missing warning then

Community sourced translations:
* [[Arabic: ar|https://gist.github.com/yamanaltereh/6874413]]
* [[Catalan: ca|https://gist.github.com/1764593]]
* [[Chinese (Traditional): zh-TW|https://gist.github.com/2001808]]
* [[Chinese (Simplified): zh-CN|https://gist.github.com/x-ji/d3be402de194a152a859]]
* [[Czech: cs|https://gist.github.com/4618569]]
* [[Danish: da|https://gist.github.com/1780778]]
* [[Dutch: nl|https://gist.github.com/1909240]]
* [[English: en|https://github.com/sferik/rails_admin/blob/master/config/locales/rails_admin.en.yml]]
* [[French: fr|https://gist.github.com/simonc/3a21074223d2f36a7232]]
* [[German: de|https://gist.github.com/3188219#file_rails_admin.de.yml]]
* [[Italian (Italy): it|https://gist.github.com/1700678#file_rails_admin.it.yml]]
* [[Japanese: ja|https://gist.github.com/1662352#file_rails_admin.ja.yml]]
* [[Korean: ko|https://gist.github.com/YoonjaeYoo/787eb279e5d46c7e96dc]]
* [[Thai: th|https://gist.github.com/wittawasw/2a7d6c62d28613702753]]
* [[Polish (Poland): pl|https://gist.github.com/1717477#file_rails_admin.pl.yml]]
* [[Portuguese (Brazil): pt-BR|https://gist.github.com/1844723#file_rails_admin.pt_br.yml]]
* [[Portuguese (Portugal): pt-PT|https://gist.github.com/1751856#file_rails_admin.pt-PT.yml]]
* [[Russian (Russia): ru|https://gist.github.com/serghost/9832270cbddc5678a3ca]]
* [[Slovenian (Slovenia): sl|https://gist.github.com/3290930#file_rails_admin.sl.yml]]
* [[Spanish (Spain): es|https://gist.github.com/1647597#file_rails_admin.es.yml]]
* [[Swedish: sv|https://gist.github.com/4433235]]
* [[Norwegian: no|https://gist.github.com/2844960#file_rails_admin.nb.yml]]
* [[Turkish: tr|https://gist.github.com/2888924#file_rails_admin.tr.yml]]

* Add your own (create a gist first)

You can find old included translations here:

[[https://github.com/sferik/rails_admin/tree/df631d6d4ed49a5417d8135000611c37f6a3ed9b/config/locales]]

## Datepicker
If you use the rails-i18n gem and your model has a date/datetime attribute, you may need add a key called `month_names` in your translation file. A good example is provided by the comment here: https://gist.github.com/simonc/3a21074223d2f36a7232#gistcomment-1574237.

This is because rails-i18n gem which you use may specify the long format like `long: "%Y年%b%d日"`. Notice the month field is just a number without translated month name. Then rails_admin uses long format by default for its date and datetime fields (https://github.com/sferik/rails_admin/blob/v1.1.0/lib/rails_admin/config/fields/types/date.rb#L11). As a result you may need to add month_names in your locale file so rails_admin can correctly delocalize it ( https://github.com/sferik/rails_admin/blob/v1.1.0/lib/rails_admin/support/datetime.rb#L31). For more discussion see https://github.com/sferik/rails_admin/issues/982